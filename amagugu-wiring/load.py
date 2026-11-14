"""Amagugu Buddies in Space - loader.
Reads data/hardware.csv and builds the knowledge-graph trail:
(Hardware)-[:HAS_FEATURE]->(Feature)-[:MADE_POSSIBLE]->(Discovery)-[:MATTERS_FOR]->(EarthBenefit)
"""
import csv, os, argparse
from dotenv import load_dotenv
from neo4j import GraphDatabase

load_dotenv()
URI = os.getenv("NEO4J_URI")
USER = os.getenv("NEO4J_USERNAME", "neo4j")
PW = os.getenv("NEO4J_PASSWORD")

if not URI or not PW:
    raise SystemExit("Missing .env - copy .env.example to .env and paste Aura URI + password")

driver = GraphDatabase.driver(URI, auth=(USER, PW))

TRAIL_CYPHER = """
MERGE (b:Body {name: $planet})
MERGE (h:Hardware {name: $name})
SET h.nickname=$nickname, h.category=$category, h.place=$place_name,
    h.lat=toFloat($lat), h.lon=toFloat($lon),
    h.year_arrived=toInteger($year_arrived), h.year_sleep=toInteger($year_sleep),
    h.status=$status, h.voice_line=$voice_line, h.kid_fact=$kid_fact,
    h.personality=$personality, h.source_url=$nssdca_link,
    h.image_emoji = CASE $planet WHEN 'Moon' THEN '🌙' WHEN 'Mars' THEN '🔴' ELSE '✨' END
MERGE (h)-[:LOCATED_ON]->(b)
MERGE (m:Mission {name: $mission_goal})
MERGE (h)-[:LEFT_BY]->(m)
MERGE (f:Feature {name: $superpower})
MERGE (h)-[:HAS_FEATURE]->(f)
MERGE (d:Discovery {title: $discovery})
MERGE (f)-[:MADE_POSSIBLE]->(d)
MERGE (h)-[:LED_TO]->(d)
MERGE (e:EarthBenefit {title: $earth_benefit})
MERGE (d)-[:MATTERS_FOR]->(e)
"""

# Kid-friendly Earth benefits derived from discovery
EARTH = {
 "water": "Helps us find drinking water for future Moon/Mars homes",
 "wet": "Helps us find drinking water for future Moon/Mars homes",
 "ice": "Helps us find drinking water for future Moon/Mars homes",
 "volcano": "Teaches us how planets are born",
 "quake": "Teaches us how to build safe homes that shake less",
 "Marsquake": "Teaches us how to build safe homes that shake less",
 "photo": "Teaches cameras to explore dangerous places for us",
 "flight": "Leads to better drones that help in disasters",
 "planet": "Shows us Earth is special and we must protect it",
 "asteroid": "Helps protect Earth from asteroid hits",
 "Ceres": "Teaches us to use little fuel to travel far",
 "Saturn": "Inspires new engineers and scientists",
 "Jupiter": "Inspires new engineers and scientists",
 "default": "Inspires new engineers and scientists on Earth"
}

def earth_for(discovery: str) -> str:
    for k,v in EARTH.items():
        if k.lower() in discovery.lower():
            return v
    return EARTH["default"]

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--wipe", action="store_true", help="delete all first")
    ap.add_argument("--csv", default="data/hardware.csv")
    args = ap.parse_args()

    with driver.session() as s:
        if args.wipe:
            s.run("MATCH (n) DETACH DELETE n")
            print("wiped")
        with open(args.csv, newline='', encoding='utf-8') as f:
            rows = list(csv.DictReader(f))
        print(f"loading {len(rows)} buddies from {args.csv}")
        for r in rows:
            r["earth_benefit"] = earth_for(r.get("discovery",""))
            r["mission_goal"] = (r.get("mission_goal") or r.get("type") or "Explore").strip()[:120]
            s.run(TRAIL_CYPHER, **r)
        c = s.run("MATCH (h:Hardware) RETURN count(h) AS n").single()["n"]
        print(f"done. Hardware nodes: {c}")
        print("Now run graph/queries.cypher Q2 in Aura for demo trail")

if __name__ == "__main__":
    main()
