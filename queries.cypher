// Amagugu – demo queries

// 1. Sanity check: how many of each thing did we load?
MATCH (n) RETURN labels(n)[0] AS label, count(*) AS total ORDER BY total DESC;

// 2. THE TRAIL (the core demo): one object, from engineering to Earth.
MATCH (h:Hardware {name: 'Opportunity rover'})-[:HAS_FEATURE]->(f:Feature)
      -[:MADE_POSSIBLE]->(d:Discovery)-[:MATTERS_FOR]->(e:EarthBenefit)
OPTIONAL MATCH (h)-[:LEFT_BY]->(m:Mission)
OPTIONAL MATCH (h)-[:LOCATED_ON]->(b:Body)
OPTIONAL MATCH (h)-[:PAVED_THE_WAY_FOR]->(l:Legacy)
RETURN h.name AS object, m.name AS mission, b.name AS world, h.year AS year,
       f.text AS how_it_worked, d.text AS discovery, e.text AS why_it_matters,
       l.name AS paved_the_way_for;

// 3. Who is still talking to us?
MATCH (h:Hardware {status: 'Still in use'})-[:LOCATED_ON]->(b:Body)
RETURN h.name AS object, b.name AS where, h.year AS since ORDER BY since;

// 4. Everything on one world, oldest first (drives the map/timeline view).
MATCH (h:Hardware)-[:LOCATED_ON]->(b:Body {name: 'Moon'})
RETURN h.name, h.year, h.location, h.status ORDER BY h.year;

// 5. The multi-hop question a table cannot answer:
//    "Which old machines made today's Artemis plans possible?"
MATCH (h:Hardware)-[:PAVED_THE_WAY_FOR]->(l:Legacy)
WHERE l.name CONTAINS 'Artemis'
MATCH (h)-[:LED_TO]->(d:Discovery)
RETURN h.name AS object, h.year AS year, d.text AS what_it_found, l.name AS led_to
ORDER BY year;

// 6. Graph picture for the demo (run in Browser to see the trail drawn).
MATCH p = (h:Hardware {name: 'Lunar Prospector'})-[*1..2]-() RETURN p;

// 7. Data quality: rows still waiting for a NASA source.
MATCH (h:Hardware) WHERE h.checked <> 'Verified' OR h.sourceUrl IS NULL
RETURN h.name, h.checked ORDER BY h.name;
