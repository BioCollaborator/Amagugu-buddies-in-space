// Amagugu Buddies in Space - Demo queries
// Query 2 is the core demo trail for judges

// Q1 - All buddies for picker
MATCH (b:Body)<-[:LOCATED_ON]-(h:Hardware)
RETURN b.name AS world, h.name AS name, h.nickname AS nickname,
       h.image_emoji AS emoji, h.place AS place
ORDER BY world, h.year_arrived;

// Q2 - CORE DEMO TRAIL: engineering -> science -> earth benefit
// Change the name to Oppy, InSight, Ginny for demo
MATCH p = (h:Hardware {name: 'Opportunity'})-[:HAS_FEATURE]->(f:Feature)-[:MADE_POSSIBLE]->(d:Discovery)-[:MATTERS_FOR]->(e:EarthBenefit)
RETURN h.nickname AS buddy, f.name AS built_with, d.title AS discovered, e.title AS matters_for_us;
MATCH p2 = (h:Hardware {name: 'Opportunity'})-[:LEFT_BY]->(m:Mission)
RETURN h.nickname AS buddy, m.name AS mission;

// Q3 - Map pins (Moon + Mars only have lat/lon)
MATCH (h:Hardware)
WHERE h.lat <> 0
RETURN h.name AS name, h.nickname AS nickname, h.lat AS lat, h.lon AS lon, h.place AS place;

// Q4 - Timeline 1967-2024
MATCH (h:Hardware)
RETURN h.name AS name, h.year_arrived AS arrived, h.year_sleep AS sleep
ORDER BY arrived;

// Q5 - Who else looked for water? (graph power)
MATCH (h:Hardware)-[:LED_TO]->(d:Discovery)
WHERE d.title CONTAINS 'water' OR d.title CONTAINS 'wet' OR d.title CONTAINS 'ice'
RETURN h.nickname AS nickname, d.title AS discovery;
