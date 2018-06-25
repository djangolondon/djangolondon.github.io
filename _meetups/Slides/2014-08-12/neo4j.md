Neo4j + Django
======

#### In General: ####
*   Avoid immature software 
*   Keep it simple
*   Mainstream == tools & support
*   Right tool for the right job
*   Django == Great
*   Neo4j == Good
*   Neo4j + Django == Almost OK

### Solvable Problems ###

#### Problem 1 & 2 (prefetch and inflate) ####

```python
query = '''
     START
         person=node:Person(email={email}),
         deleted = node:Group(group='deleted')
     MATCH
         (person)-[:COUNTRY]-(country),
         (person)-[:KNOWS]-(other_person),
     WHERE
        NOT (person)<-[:MEMBER]-(deleted) AND
        NOT (other_person)<-[:MEMBER]-(deleted) 
     RETURN
     	person, country, other_person
 '''
 params = dict(email='spam@eggs')
 result = cypher_query(query, params)[0]

 person = Person.inflate(result[0])
 country = Country.inflate(result[1])
 knows_people = [Person.inflate(i) for i in result[2]]

 # person.country -> Attribute Error
 
 # On post_save if you want to notify all known people
 # you have to make another query
```

### Solution ###
```
# Steal the ideas from django
Person.objects.get(email="spam@eggs").select_related('KNOWS')
```

### Problem 3 cache ###
```python
def get_a_lot_of_staff():
    cypher = '''
    	....
    '''
    params = {...}
    # No easy way to cache this
    cypher_query(cypher, params)
```

### Solution ###
```
cypher_query(cypher, params, cache=True)
```

### Problem 4 memory ###
```
# This may not feed in memory
Person.category().instance.all()
```

### Solution ###
```
# Use SKIP and LIMIT
batches = Person.category().instance.all().batch_size(100)
[process_people(i) for i in batches]
```
