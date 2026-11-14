// Queries your kid app will actually use.
// Your Node API will run these with neo4j-driver.

-- Q1: Get all buddies for map pins
MATCH (p:Planet)-[:HOME_TO]->(s:Spacecraft)
RETURN p.name AS planet, s.name AS name, s.nickname AS nickname,
       s.lat AS lat, s.lon AS lon, s.place AS place,
       s.category AS category
ORDER BY planet, s.year_arrived;

-- Q2: Get one buddy story page
// param: $name e.g. 'Opportunity'
MATCH (s:Spacecraft {name: $name})
OPTIONAL MATCH (s)-[:PART_OF]->(m:Mission)-[:MADE]->(d:Discovery)
RETURN s.nickname AS nickname, s.voice_line AS voice_line,
       s.superpower AS superpower, s.discovery AS discovery,
       s.kid_fact AS kid_fact, s.status AS status,
       collect(DISTINCT m.goal) AS mission_goals,
       collect(DISTINCT d.title) AS discoveries;

-- Q3: Passport progress - count by world
MATCH (p:Planet)-[:HOME_TO]->(s:Spacecraft)
RETURN p.name AS world, count(s) AS total;

-- Q4: Story connection - who else looked for water? (for "Friends who helped too" section)
MATCH (s:Spacecraft)
WHERE s.discovery CONTAINS 'water' OR s.discovery CONTAINS 'wet' OR s.discovery CONTAINS 'ice'
RETURN s.nickname AS nickname, s.discovery AS discovery;

-- Q5: Timeline for kids 1967-2024
MATCH (s:Spacecraft)
RETURN s.name AS name, s.nickname AS nickname, s.year_arrived AS arrived, s.year_sleep AS sleep
ORDER BY arrived;
