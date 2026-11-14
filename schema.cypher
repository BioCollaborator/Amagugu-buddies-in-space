// Amagugu – graph schema (run once in Neo4j Browser / Aura Query)
// Model:
// (:Hardware)-[:LEFT_BY]->(:Mission)
// (:Hardware)-[:LOCATED_ON]->(:Body)
// (:Hardware)-[:CARRIED]->(:Instrument)
// (:Hardware)-[:HAS_FEATURE]->(:Feature)-[:MADE_POSSIBLE]->(:Discovery)
// (:Hardware)-[:LED_TO]->(:Discovery)-[:MATTERS_FOR]->(:EarthBenefit)
// (:Hardware)-[:PAVED_THE_WAY_FOR]->(:Legacy)

CREATE CONSTRAINT hardware_name IF NOT EXISTS FOR (n:Hardware) REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT mission_name IF NOT EXISTS FOR (n:Mission) REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT body_name IF NOT EXISTS FOR (n:Body) REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT instrument_name IF NOT EXISTS FOR (n:Instrument) REQUIRE n.name IS UNIQUE;
CREATE CONSTRAINT feature_text IF NOT EXISTS FOR (n:Feature) REQUIRE n.text IS UNIQUE;
CREATE CONSTRAINT discovery_text IF NOT EXISTS FOR (n:Discovery) REQUIRE n.text IS UNIQUE;
CREATE CONSTRAINT benefit_text IF NOT EXISTS FOR (n:EarthBenefit) REQUIRE n.text IS UNIQUE;
CREATE CONSTRAINT legacy_name IF NOT EXISTS FOR (n:Legacy) REQUIRE n.name IS UNIQUE;
