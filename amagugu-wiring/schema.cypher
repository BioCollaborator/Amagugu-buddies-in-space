// Amagugu Buddies in Space - Schema
// Run once in Aura Query before python load.py --wipe

CREATE CONSTRAINT hardware_name IF NOT EXISTS FOR (h:Hardware) REQUIRE h.name IS UNIQUE;
CREATE CONSTRAINT body_name IF NOT EXISTS FOR (b:Body) REQUIRE b.name IS UNIQUE;
CREATE CONSTRAINT mission_name IF NOT EXISTS FOR (m:Mission) REQUIRE m.name IS UNIQUE;
CREATE CONSTRAINT discovery_title IF NOT EXISTS FOR (d:Discovery) REQUIRE d.title IS UNIQUE;
CREATE CONSTRAINT feature_name IF NOT EXISTS FOR (f:Feature) REQUIRE f.name IS UNIQUE;
