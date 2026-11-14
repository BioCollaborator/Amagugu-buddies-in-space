"""Load data/hardware.csv into Neo4j.

Usage:
    pip install -r requirements.txt
    copy .env.example to .env and fill in your Aura details
    python load.py            # load
    python load.py --wipe     # delete everything first, then load
"""
import csv
import os
import sys
from pathlib import Path

from dotenv import load_dotenv
from neo4j import GraphDatabase

ROOT = Path(__file__).parent
ROW_QUERY = """
MERGE (h:Hardware {name: $name})
SET h.type = $type, h.year = toInteger($year), h.status = $status,
    h.location = $location, h.checked = $checked,
    h.sourceUrl = CASE WHEN $source_url = '' THEN null ELSE $source_url END
MERGE (b:Body {name: $body})
MERGE (h)-[:LOCATED_ON]->(b)
MERGE (m:Mission {name: $mission})
MERGE (h)-[:LEFT_BY]->(m)
MERGE (i:Instrument {name: $instrument})
MERGE (h)-[:CARRIED]->(i)
MERGE (d:Discovery {text: $discovery})
MERGE (h)-[:LED_TO]->(d)
MERGE (f:Feature {text: $how_it_worked})
MERGE (h)-[:HAS_FEATURE]->(f)
MERGE (f)-[:MADE_POSSIBLE]->(d)
MERGE (e:EarthBenefit {text: $earth_benefit})
MERGE (d)-[:MATTERS_FOR]->(e)
MERGE (l:Legacy {name: $paved_the_way_for})
MERGE (h)-[:PAVED_THE_WAY_FOR]->(l)
"""


def statements(path):
    """Split a .cypher file into statements, dropping // comments."""
    text = "\n".join(
        line for line in path.read_text(encoding="utf-8").splitlines()
        if not line.strip().startswith("//")
    )
    return [s.strip() for s in text.split(";") if s.strip()]


def main():
    load_dotenv(ROOT / ".env")
    driver = GraphDatabase.driver(
        os.environ["NEO4J_URI"],
        auth=(os.environ.get("NEO4J_USERNAME", "neo4j"), os.environ["NEO4J_PASSWORD"]),
    )
    with open(ROOT / "data" / "hardware.csv", newline="", encoding="utf-8") as fh:
        rows = list(csv.DictReader(fh))

    with driver.session() as session:
        if "--wipe" in sys.argv:
            session.run("MATCH (n) DETACH DELETE n")
        for stmt in statements(ROOT / "graph" / "schema.cypher"):
            session.run(stmt)
        for row in rows:
            session.run(ROW_QUERY, **row)
        total = session.run("MATCH (h:Hardware) RETURN count(h) AS c").single()["c"]
    driver.close()
    print(f"Loaded {len(rows)} rows. Hardware nodes in graph: {total}")


if __name__ == "__main__":
    main()
