Graphen Datenbanken
-------------------

![Graph](../images/Graph.png)

<p style="font-size: 0.5em">Quelle: <a href="https://neo4j.com/blog/aggregate-stores-tour/">Neo4j Blog</a></p>

---

Graphen Datenbanken sind die speziellste Form von NoSQL Datenbanken.

Haben ein anderes Datenspeicherkonzept als andere NoSQL Datenbanken, meistens verschachtelte Listen.

Eigen sich vorzüglich um Relationen zwischen Entitäten, beispielsweise Personen, darzustellen. 

Typische Systeme wo Graphen Datenbanken nutzen sind Facebook und LinkedIn.

Neue Knoten und Kanten können an jeder Stelle des Graphen eingesetzt werden.

### Anwendungen

- Graphen Probleme, wie Personenbeziehungen, Netzwerktopologien
- Fahrpläne darstellen und abfragen.
- What music do my friends like that I don't yet own?
- Who is following me? (Soziale Netzwerke)
- Routing Tables (Restaurants in einer Stadt)
- Kombination von geographischen Infos mit sozialen Verbindungen

### Links

- [Neo4J](https://neo4j.com/)

### Beispiele

![neo4j](../images/neo4j.png)

Nach dem Starten der neo4j Docker Instanz kann das User Interface via `startsvc neo4j` erreicht werden.

    kubectl apply -f duk/bigdata/neo4j.yaml
    startsvc neo4j

Nach dem Setzen eines Standardpasswortes und evtl. Refresh des Browser können die Befehle im Browser abgefüllt werden.

**Alternative zu untenstehenden Befehlen:** -> Jump into code -> Write Code -> Movie Graph -> create a graph.

**Daten erstellen:**

	CREATE (m:Movie { movie_name : 'Stirb langsam'})
	CREATE (a:Actor { actor_name : 'Bruce Willis' })
	CREATE (d:Director { director_name : 'John McTiernan' })
	
**Beziehungen aufbauen:**

	MATCH (a:Actor),(m:Movie) WHERE a.actor_name = 'Bruce Willis' AND m.movie_name = 'Stirb langsam' CREATE (m)-[r:acts_in]->(t)
	
	MATCH (d:Director),(m:Movie) WHERE d.director_name = 'John McTiernan' AND m.movie_name = 'Stirb langsam' CREATE (m)-[r:directed]->(t)	
	
**Daten abfragen:**

	MATCH (a:Actor { actor_name:'Bruce Willis' }),(d:Director { director_name:'John McTiernan' }), p = shortestPath((a)-[:directed|:acts_in*]-(d)) RETURN p
	
