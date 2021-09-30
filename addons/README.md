Add-ons
=======

Nützliche Add-ons

Dashboard
---------

Einloggen ins Dashboard ohne Token und fixem Port 32443.

    kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/addons/dashboard-skip-login.yaml
    
Einloggen ins Dashoard ohne Token, ohne Ingress und mit fixem Port 8443:

    kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/addons/dashboard-skip-login-no-ingress.yaml
    
Ideal für eine minimale Kubernetes Umgebung mit microk8s.