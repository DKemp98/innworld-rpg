# ADR 0039: Talk topics (M25.1)

Status: accepted (2026-10-12).

## Problem
Talking with a canon NPC only gave XP, a relationship point and a greeting line. The world already keeps news
(`gs.world.news`: event and hook `news`, T1 `rumor`), but the player read it only in the journal. M25.1 asks NPCs to
share news, rumours and requests, in short summaries in our own words, from events and flags.

## Decision
`TalkTopics` (`game/core/talk_topics.gd`). On the first talk of the day with an NPC (`NpcSim.note_talk` is true),
`Interact.perform` adds one topic line after the greeting: `rules.talk.line` ("Name: \"text\"").

- **Pool.** News of the last `rules.talk.news_days` days: `own` (an event whose run cast this NPC by name), `town`
  (an event whose location is in the NPC's town), `rumor` (T1 rumours: anyone passes them on). News from another town
  that did not cast the NPC is left out. Plus topics from the new file `game/data/talk.json`: `topic` (kind `news` or
  `rumor`) and `request`.
- **Town.** The nearest settlement at or above a canon location (`Standing.town_of_location`). An NPC's town comes
  from its canon `home`; an NPC without a home tells only own news, rumours and ungated topics.
- **Gate** of a talk.json topic: `who` (`npcs`, `tags`, `towns`: any match; none = anyone), `flags`, `not_flags`,
  `days` [from, to].
- **Pick.** One weighted pick (`rules.talk.weights`) with `gs.rng` (rule 3). An NPC whose regard is under
  `rules.talk.min_regard` (0) says nothing.
- **Requests are hints only** (user choice, 2026-10-12). A `request` topic points at a game feature (request board,
  spellbook shelf, smithy, inn work, hunting). It has no state, no reward and no save change. Real tasks may come with
  the job boards (M25.2).

## Data
`talk.json` (schema_version 1): `topics`: id → {"kind": news | rumor | request, "text", "confidence", "who"?,
"flags"?, "not_flags"?, "days"?, "canon_ref"?, "note"?}. Canon topics carry a `canon_ref` to the chapter of the event
that sets their flag. Request hints are game hints: `confidence: guess`. Validated in `DataDb.load_dir`
(`TalkTopics.validate`). Toy dbs have no `rules.talk` (`ToyData` erases it), so toy worlds have no topics.

## Consequences
- No save change: the topic is not stored. An NPC may say the same topic on two days.
- A talk with a canon NPC now uses one RNG roll when the pool is not empty. Seeded runs that talk change their later
  rolls.
- New books add topics to `talk.json` (data, not code).
