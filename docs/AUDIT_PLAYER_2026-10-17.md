# Player audit — 2026-10-17

Read-only audit of v0.1.5 + Book 8 (branch `feat/m28.9-canon-5-43`). No code or data changed.
Question from the user: what works, what needs work, what is missing, and will a book reader feel at home?

How it was checked:
- Played the v0.1.5 web build in a browser: title, new game at Liscor, the gate guard, walk to the inn,
  talk to Erin, work in the kitchen, sleep, the day-9 Goblin Chieftain fight.
- A headless "do nothing" run from day 8 to day 166 (all 8 books). It printed every morning page.
- A headless "inn worker" run (12 jobs a day, accept every offer) for two weeks.
- Counts over all canon data, stages, hooks, talk topics, spells, recipes, looks.

## Verdict in one paragraph
A book reader will see at once that someone read the books with care. Names, classes, places, the order of
events and the morning news are right, and the night System feels like the books. But the world in a reader's
head is made of people who talk, and here the people do not talk. Erin says nothing to you. You hear about the
big moments the next morning, as news. So the reader will respect the game, but feel like a ghost who walks
through a very well researched timeline. The fights of Books 1 – 5 are staged well. The biggest climaxes of
Books 6 – 8 happen off screen, or you can join them but change nothing.

## What works
1. **Canon backbone.** 1,403 events for Books 1 – 8 (about 158 player days). With no input the story runs as
   written (drift 0). The news is in our own words and reads like town talk. The do-nothing run gave 295 news
   lines and 67 rumours.
2. **The System at night.** Classes come from what you do. Offers at night, decline is forever, many small
   classes slow you down (Ryoka's theory), breakthroughs at 10/20/30, hidden XP and a secret total level.
   In the worker run: [Innkeeper] on night 1, then [Maid], [Cook], [Server], [Laborer]; Skills like
   [Basic Cooking] and [Advanced Cooking]. This matches the books well.
3. **Fights in Books 1 – 5.** XCOM-style turns on the same map, with canon allies and wave lines that echo the
   scenes: Relc and Zevara at the gate, Erin with a frying pan, Rags with fire against Skinner. Hooks let you
   change things: help Erin against the Chieftain and she is not stabbed.
4. **A living map.** 103 NPCs on schedules, 51 maps, the inn grows (builders, outhouses, smashed watchtower),
   winter with Frost Faeries, the rains and floods, the magic door, Drake boycott in Book 8.
5. **Freedom.** You can kill anyone. The director patches the story and warns you when canon is no longer safe.
6. **Art.** 150+ own looks. Drakes look like Drakes, Gnolls like Gnolls, Toren is a skeleton, the Goblin
   board says "No Killing Goblins". Doors and shops have signs.

## What hurts the reader most (in order)

### 1. The characters have no voice (biggest problem)
- Every NPC has the same menu: "Talk with a guest", "Persuade someone", "Comfort someone", "Attack". A Watch
  guard at the gate also gets "Talk with a guest". (`rules.npc.talk_actions`, `core/interact.gd:73`)
- A talk gives one greeting by friendship level ("Relc nods at you") and maybe one news line in quotes.
  The same text for every person. (`core/talk_topics.gd`, `rules.standing` bands)
- In play, Erin said **nothing** on the first talk (`s20`).
- `data/talk.json` has 17 topics, mostly Book 1 and shop hints.
- The data already knows who people are: each canon NPC has a good `summary` (Relc: loud, big eater, hates
  "lizard"). The player never sees it.

### 2. You hear the story, you do not see it
- 72 stages in all: 25 fights and 47 "scenes". In a scene NPCs stand still and one line shows. Zel's mourning puts 17
  characters in the inn and shows one sentence (`b6.liscor_mourns_zel`).
- No signposts. Nothing tells you to be at the Liscor gate at dusk on day 39 or on the hill that night. The
  news about Skinner comes the morning after. A book reader knows the order, but not our day numbers.
- The player arrives on day 8, so Erin's first week (Goblins, Rock Crab, Pisces, Relc and Klbkch) is history.

### 3. Nobody cares that you are from Earth
- The welcome page says you are an Earther. After that, no one reacts. Erin, the only other Earther near you,
  does not either. In the books, meeting another Earther is a huge moment.
- No character creation: no name, no look, no Earth background (student, nurse, cook ...).
- No Earth knowledge to use (recipes, games, songs, the things Erin sells and stages).

### 4. The later climaxes are off screen or do not care about you
| Big moment | In the game |
|---|---|
| Skinner and the dead (Book 1) | Two strong fight stages (gate + hill). Best fight in the game. |
| Goblin raid, Klbkch dies (Book 1) | Fight stage. Klbkch dies whatever you do. |
| Esthelm's last battle (Book 3) | Fight stage, XP x3. Good. |
| Regrika kills Ulrien (Book 5) | Fight stage. |
| Zel vs the Goblin Lord, Zel's death (Book 6) | News and rumours only. |
| Rags vs Tremborag, the Goblin road (Book 7) | Off map, news only. |
| Face-eater moths (Book 7) | Fight stage, 7 waves. Good. |
| Raskghar raids (Book 8) | Two fight stages, but **no hooks**: your part changes nothing. |
| Three doors, the Horns bring down Calruz (Book 8) | Fight stage, but Calruz is not in it and the Horns are not your allies. The climax is an event that runs at night. |
- Book 8 has 269 events and 1 hook. Books 1 – 7 have 128 hooks for 1,134 events.

### 5. The System does not sound like the books
- Today: "[Innkeeper] reached level 2." / "Skill gained: [Basic Cooking]." / "You can gain the class X."
- Readers expect the book style: "[Innkeeper Level 2!]", "[Skill – Basic Cooking obtained!]",
  "[Innkeeper Class Obtained!]". A small text change with a big effect. (`core/night.gd:137-140`,
  `ui/system_messages.gd:149`)

### 6. Lore slips a reader will notice
- The HUD calls Erin's inn "The abandoned inn on the hill" in every book (`canon/book1/locations.json`).
  The flag `wandering_inn.named` exists (1.18) but the name never changes.
- The "The Wandering Inn" sign and the "No Killing Goblins" board stand on day 8. The book puts them on
  canon day 14 (`maps/inn_hill.json`: no `when_flags`).
- A "Gnoll patron (wants bread)" eats at the inn on the player's first morning. In Book 1 nobody comes.
- Liscor treats a Human like anyone else. In the books Drakes distrust Humans (Lism's prices, the guards).
  `rules.standing` has no race part.
- Magnolia Reinhart has a brown dress. She is famous for pink (our own news says "pink carriage").
- Moore (half-Giant) is human size. The Antinium (Klbkch, Pawn, Bird) are generic figures, not four-armed ants.
- Under the warm kitchen light Erin's white T-shirt looks like bare skin (`s18`). A coloured shirt or apron fixes it.

### 7. Thin systems for a reader's dreams
- 5 spells in all ([Ice Spike], [Flashfire], [Gust], [Frozen Wind], [Fireball]). No [Light], [Flash Step],
  [Lightning Bolt], [Invisibility], no undead magic, though [Necromancer] is a class.
- 8 recipes. Jobs pay coin but have no story. No personal quest lines with Erin, Pawn, Mrsha, Ceria, Relc.
- Friendship is a number and a greeting. A close friend does nothing new for you.

### 8. Play feel
- In the Chieftain fight the fight sat under the message box at the bottom of the screen (`s27`).
- After the last Book 8 day the world goes quiet. No page says "the story is written up to here".

## Recommended order of work
1. **Voices.** A voice file per main NPC (own words, short): greet, idle, after an event (by flag), at
   friend level. Own talk options: Erin (ask for work, play chess, "I'm from Earth too"), Relc, Pisces,
   Klbkch, Krshia, Selys, Lyonette, Mrsha (signs), Ceria. Start with 10 – 15 NPCs. Needs a schema change: ask.
2. **Signposts and scene beats.** A rumour the day before each fight stage ("The teams go into the ruins
   tomorrow. Some say the dead are restless."). Scenes play 3 – 6 short lines over time, not one.
3. **Book 6 – 8 climaxes.** Calruz as the last foe of the three-door battle with the Horns as allies; hooks on
   the three Book 8 stages; an optional way to stand with Zel (for example through the door).
4. **Quick lore batch.** Inn name by flag, signs by flag, no patrons before the inn opens to guests,
   Human distrust in Liscor, Magnolia in pink, book-style System lines, end-of-story page.
5. **Depth.** More canon spells with teachers (Pisces, Ceria), Earth recipes Erin makes (marked guess),
   2 – 3 personal quest lines.

## Evidence files (scratchpad, not in git)
Screenshots s01 – s27 and `cast.png`; `passive_clean.txt` (all morning pages, days 8 – 166);
`worker.txt` (inn worker, two weeks). The session scratchpad is deleted when the session ends.
