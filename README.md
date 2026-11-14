# Amagugu

**The treasures we left on other worlds.**

A story-driven knowledge graph for the NASA Space Apps 2026 challenge
*Abandoned but not Forgotten*. A young explorer (ages 9–13) picks a machine NASA
left on the Moon, on Mars or in deep space, and follows its trail: how it was
built, what it discovered, and why that matters on Earth today.

> **Status: practice build.** The data in `data/hardware.csv` is a draft and every
> row is marked "To verify". Check each row against a NASA source and fill in
> `source_url` before any of it is shown to judges.

## Why a graph

The challenge asks for a clear link between the engineering of the hardware and
the science it made possible. That link is a path:

```
(Hardware)-[:HAS_FEATURE]->(Feature)-[:MADE_POSSIBLE]->(Discovery)-[:MATTERS_FOR]->(EarthBenefit)
(Hardware)-[:LEFT_BY]->(Mission)
(Hardware)-[:LOCATED_ON]->(Body)
(Hardware)-[:CARRIED]->(Instrument)
(Hardware)-[:LED_TO]->(Discovery)
(Hardware)-[:PAVED_THE_WAY_FOR]->(Legacy)
```

Each trail is narrated by the object itself ("I am Opportunity. I was built for
90 days…"). The graph supplies the facts; the story cards supply the voice.

## Run it

1. Create a free database at https://console.neo4j.io (AuraDB Free).
2. `pip install -r requirements.txt`
3. Copy `.env.example` to `.env` and paste in the URI and password Aura gave you.
4. `python load.py` (add `--wipe` to start clean).
5. Open the Aura Query tab and run the queries in `graph/queries.cypher`.
   Query 2 is the core demo trail.

## Folders

- `data/` hardware list, one row per object, with a source URL per row
- `graph/` schema constraints and demo queries
- `app/` front end (to build): object picker → trail → story cards
- `docs/` challenge notes, demo script, sources

## To do

- [ ] Verify all 20 rows and add NASA source URLs
- [ ] Pick the three demo trails (proposed: Lunar Prospector, Opportunity, Voyager 1)
- [ ] Write first-person story cards for those three
- [ ] Front end: phone-first, light on data, audio narration
- [ ] Stretch: isiZulu version of the three demo trails
