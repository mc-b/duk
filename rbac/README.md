RBAC-Autorisierung
==================

![](https://d33wubrfki0l68.cloudfront.net/673dbafd771491a080c02c6de3fdd41b09623c90/50100/images/docs/admin/access-control-overview.svg)

Quelle: [https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/](https://kubernetes.io/docs/reference/access-authn-authz/controlling-access/)

- - -

Die rollenbasierte Zugriffssteuerung (RBAC) ist eine Methode zur Regulierung des Zugriffs auf Computer- oder Netzwerkressourcen basierend auf den Rollen einzelner User in einem Unternehmen.

Kubernetes verwendet die **rbac.authorization.k8s.io** API-Gruppe womit Administratoren API-Zugriffe steuern können.

Kubernetes-»User«
-----------------

Alle Kubernetes-Cluster haben zwei Kategorien von Usern: von Kubernetes verwaltete Dienstkonten und normale User.

Es wird davon ausgegangen, dass normale User von einem externen, unabhängigen Dienst verwaltet werden. Ein Administrator, der private Schlüssel verteilt, ein Userspeicher wie OpenStacks Keystone, Google-Konten oder eine Datei mit einer Liste von Usernamen und Kennwörtern.

**Kubernetes verfügt nicht über Objekte, die normale Userkonten darstellen. Normale User können nicht über einen API-Aufruf zu einem Cluster hinzugefügt werden.**

### Authentifizierungsstrategien

Kubernetes verwendet 
* X509-Client-Zertifikate
* Inhaber-Token
* einen Authentifizierungs-Proxy 
* HTTP-Basisauthentifizierung, um API-Anforderungen über Authentifizierungs-Plug-ins zu authentifizieren. 

Weitere Informationen: 
* [Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
* [Manage TLS Certificates in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/)

Rolle und ClusterRole
---------------------

Eine `Role` gilt für einen Namespace, eine `ClusterRole` für den gesamten Cluster.
 
Beispiel `Role`:

    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      namespace: default
      name: pod-reader
    rules:
    - apiGroups: [""] # "" indicates the core API group
      resources: ["pods"]
      verbs: ["get", "watch", "list"]

Weitere Informationen: [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

Ein einfaches RBAC-Beispiel mit einem Kubernetes-»User«
-------------------------------------------------------

Die Befehle müssen in der VM als `root` ausgeführt werden. 

Dazu ist wie folgt in die VM und dort als `root` zu wechseln:

    vagrant ssh
    sudo -i

### Anlegen des User Zertifikates

Zuerst müssen wir den Private Key für das User-Zertifikat generieren und diesen signieren:

    openssl genrsa -out snoopy.pem 2048
    openssl req -new -key snoopy.pem -out snoopy.csr -subj "/CN=snoopy"
    
Diese Aktionen erzeut die Dateien `snoopy.pem` und `snoopy.csr`.

Der CSR (Certificate Signing Request) ist in Kubernetes als Ressource zu erstellen:

    cat <<%EOF% | kubectl apply -f -
    apiVersion: certificates.k8s.io/v1beta1
    kind: CertificateSigningRequest
    metadata:
      name: user-request-snoopy
    spec:
      groups:
      - system:authenticated
      request: $(cat snoopy.csr | base64 | tr -d '\n')
      usages:
      - digital signature
      - key encipherment
      - client auth
    %EOF%

Und zu beglaubigen:

    kubectl certificate approve user-request-snoopy

Das Resultat können wir uns wie folgt anschauen:

    kubectl get csr | grep snoopy    


Anschließend muss der Zertifikatsrequest noch signiert werden:

    kubectl get csr user-request-snoopy -o jsonpath='{.status.certificate}' | base64 -d > snoopy.crt
    
Damit wir den User Account verwenden können, benötigen wir eine entsprechende K8s-Konfiguration, diese steht nachher in `.kube/config-snoopy`:

    kubectl --kubeconfig ~/.kube/config-snoopy config set-cluster kubernetes --insecure-skip-tls-verify=true --server=https://192.168.137.100:6443
    kubectl --kubeconfig ~/.kube/config-snoopy config set-credentials snoopy --client-certificate=snoopy.crt --client-key=snoopy.pem --embed-certs=true
    
Der erste Befehl legt die Datei `.kube/config-snoopy` mit den Cluster Informationen (`server=` ggf. ändern) an, der zweite Befehl ergänzt die User Informationen.

Anschliessend Erzeugen wir einen Context `snoopy` und wechseln auf diesen.

    kubectl --kubeconfig ~/.kube/config-snoopy config set-context snoopy --cluster=kubernetes --user=snoopy 
    kubectl --kubeconfig ~/.kube/config-snoopy config use-context snoopy
    
Da noch die entsprechende Rolle und das Binding fehlt sollte folgender Befehl eine Fehler ausgeben:

    kubectl --kubeconfig .kube/config-snoopy get pods    

### Role und RoleBinding erzeugen

Damit der neue User Zugriff auf die Pods erhält, ist die nachfolgende YAML Datei zu erstellen

    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1beta1
    metadata:
      namespace: default
      name: pod-reader-role
    rules:
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["get", "watch", "list"]
    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1beta1
    metadata:
      name: pod-reader-rolebinding
      namespace: default
    subjects:
    - kind: User
      name: snoopy
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: Role
      name: pod-reader-role
      apiGroup: rbac.authorization.k8s.io

und auszuführen:
 
    kubectl apply -f rbac-snoopy.yaml
   
Anschliessend muss die Abfrage von `Pods` in der Namespace `default` mit dem User funktionieren:

    kubectl --kubeconfig .kube/config-snoopy get pods   
 
   
Ein einfaches Dashboard-Beispiel mit einem Dienstkonto (Service Account)
------------------------------------------------------------------------

Um via Dashboard die gleichen Informationen wie oben anzuzeigen, muss ein `ServiceAccount` mit dem gleichen RoleBinding wie der User `snoopy` angelegt werden.   

Die YAML Datei sieht dabei wie folgt aus:

    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: snoopy
    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: pod-reader-rolebinding
      namespace: default
    roleRef:
      apiGroup: rbac.authorization.k8s.io  
      kind: Role
      name: pod-reader-role
    subjects:
    - kind: ServiceAccount
      name: snoopy
      namespace: default  

ausführen mittels:

    kubectl apply -f dashboard-snoopy.yaml
    
Neben dem Service Account und der RoleBinding wird ein `secret` im Namespace `default` angelegt. Der **Token** des `secrets` brauchen wir um ins in das Dashboard einzuloggen.

Den **Token** können wir wie folgt abfragen:

    kubectl describe secret $(kubectl get secret | grep snoopy | awk '{print $1}')
    
          