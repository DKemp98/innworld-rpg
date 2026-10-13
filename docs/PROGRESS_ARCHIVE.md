# Progress archive (M0–M9)

Finished milestone detail, moved out of `progress.md` on 2026-09-25 to keep that
file short. This file is read only when you need old detail — not every
session. Current work stays in `progress.md`.

## Roadmap status (M0–M7)
- [x] M0 — Setup (done 2026-09-23, tag `m0-done`)
- [x] M1 — Sim core (done 2026-09-23, PR #2 merged, tag `m1-done`)
  - [x] Schemas: ADR 0002 accepted (outcome_mult yes, tags.json registry yes)
  - [x] Clock, tags, data loader, action log, XP, `Actions.perform` (part 1, PR #1 merged)
  - [x] Part 2: classes (17), skills (47), pools, offers, decline blacklist, levels, dilution, capstones, class loss, consolidation, night pipeline 1–4 + 8, `Commands` facade, debug console, `sim_30_days`, `sim_decline`
- [x] M2 — Canon pipeline (done 2026-09-23, PR #3 merged, tag `m2-done`)
  - [x] `tools/extract_epub.py` + tests. Book 1: 66 chapters, ~448k words, 6 images skipped.
  - [x] Schemas (ADR 0004 accepted) + `tools/validate_data.py` + tests (26 Python tests pass).
  - [x] Events 1.00–1.09 (now in `game/data/canon/book1/`): 26 events, 10 NPCs, 15 locations, all `reviewed`; validator 0 errors.
- [x] M3 — World director (done 2026-09-23, PR #4 merged, tag `m3-done` on merge commit 47412d1)
  - [x] Canon data moved to `game/data/canon/` (user choice).
  - [x] `CanonDb` loader, `WorldState` (save v3), `Director` (night step 5), rules `director` section.
  - [x] `Commands.kill_npc` / `set_flag`; console `kill`, `flag`, `history`, `drift`.
  - [x] Tests: `unit_canon_db`, `unit_director`, `sim_divergence` (3 scenarios), `sim_canon_book1` (real week 1, drift 0).
- [x] M4 — 2D world (done 2026-09-23, PR #9 merged, tags `m4.5-done` and `m4-done` on merge commit 0e2f19a)
  - [x] M4.1 Canon 1.10–1.14 (branch `data/book1-1.10-1.14`, PR #5): 12 events, 5 NPCs, 8 locations, reviewed by user; validator 0 errors, GUT 156/156 (canon runs days 1–9, drift 0). Merged, tag `m4.1-done` pushed.
  - [x] M4.2 World grid core (branch `feat/m4.2-world-grid`): `tiles.json`, 5 maps, `MapDb`, `PlayerState`, `Movement`, `Interact`, `Pathfind`, save v4, console `where/look/go/use`, day-8 start, ADR 0006. GUT 193/193. PR #6 merged, tag `m4.2-done`.
  - [x] M4.3 2D view (branch `feat/m4.3-world-view`): `Session` autoload, `WorldView` (tiles made in code), main scene with WASD/E/Z, use menu, HUD, console overlay (backtick). ADR 0007. GUT 203/203. PR #7 merged, tag `m4.3-done`.
  - [x] M4.4 NPC schedules + utility AI (branch `feat/m4.4-npc-ai`): `npc_behaviour.json` (14 NPCs, off-map places `liscor`/`wilds`), `BehaviourDb`, `UtilityAi`, `NpcRoster`, `NpcSim` (walk in the player's area, jump elsewhere), `Pathfind` avoid + area routes, night step 6, talk to NPCs (+1 relationship a day), `Commands.wait` (Space), save v5 with exact f64 floats (`SaveCodec`). ADR 0008. GUT 243/243. PR #8 merged, tag `m4.4-done`.
  - [x] M4.5 System message UI (branch `feat/m4.5-system-ui`): `SystemMessages` pages (collapse, levels/skills, rumors, drift, offers, morning), `SystemDialog` (Accept / Decline + confirm), sleep in the inn bed (map object `sleep: true`, user choice), character sheet (C), night result sections. ADR 0009. `sim_m4_done` checks the M4 "Done when". GUT 258/258. PR #9 merged.
- [x] M5 — Combat (done 2026-09-23, tag `m5-done`; plan approved 2026-09-23; 3 sub-modules, see ROADMAP and ADR 0010)
  - [x] M5.1 Combat core (branch `feat/m5.1-combat-core`): `enemies.json` (goblin_grunt, rock_crab, razorbeak; spawns empty), `items.json` (chair, rolling_pin, stone, seed_core), rules `combat`, `CombatDb`, `Stats` (stat_mod live), `CombatState`, `Combat` (attack, block, throw, drop, bump attack, fight records at fight end, danger refusals, knock-out with safe wake spot, night heal, bandage heal), `Night.run(..., knocked_out)`, save v6. ADR 0010. GUT 302/302.
  - [x] M5.2 Monsters on the map (branch `feat/m5.2-monsters`): `MonsterSim` (turns by `act_seconds`, spawns, spot/ambush, pack aggro + morale, give up (crab hides, others go home), territorial leash from home, flee to the edge), 4 real spawns, map items (seed cores, stones, rolling pin, chairs) + `Commands.take`, Razorbeak nest zone/object, monster `pack` field. ADR 0010 M5.2 section. GUT 348/348. PR #11 merged, tag `m5.2-done`.
  - [x] M5.3 Combat UI (branch `feat/m5.3-combat-ui`): monster markers (state edge, dark ring, "Goblin 5/8"; hidden crab = rock tile), HUD `HP 14/20 · Held: Chair` (warning colour ≤ 25%), combat text in the log, bump attack once per key press, B/T/X, Take in the E menu, knock-out page (`SystemMessages.KNOCKOUT`), sheet HP + stats, console combat + debug commands, `Combat.nearest_foe`. `sim_m5_done` (seed 2) checks the M5 "Done when". ADR 0010 M5.3 section. GUT 358/358. PR #12 merged, tags `m5.3-done` and `m5-done`.
- [x] M6 — Vertical slice (done 2026-09-24, PR #17 merged, tags `m6.5-done` and `m6-done` on merge commit 666dd90; 5 sub-modules, see ROADMAP and ADR 0011)
  - [x] M6.1 Play loop (branch `feat/m6.1-play-loop`): `SaveSlots` (3 slots + autosave in `user://saves`), `Session` save/load/new game, title menu (main scene), pause menu (Esc: save, load, quit to title), shared slot list, journal (J: focus from class main tags), welcome page with hints, autosave when the System dialog closes / on quit, offer thresholds ÷ 3 (first offer night 3, day 11), GUT pre-run hook (test saves in `user://test_saves`). ADR 0011. GUT 382/382. PR #13 open (waiting on the user).
  - [x] M6.2 Canon 1.15–1.20R (branch `data/book1-1.15-1.20`): 11 events, 7 new NPCs, 4 new locations, reviewed by user 2026-09-24 (my picks: Goblin meal day 12, Ryoka window 13–16, Ryoka rumor kept, Persua/Queen/Izril later). Validator 0 errors. `sim_canon_book1` LAST_DAY 13, drift 0; new test: kill Klbkch → another guard saves Erin. GUT 383/383. PR #14 merged, tag `m6.2-done`.
  - [x] M6.3 Canon 1.21–1.25 (branch `data/book1-1.21-1.25`): 13 events (days 14–19), 5 new NPCs, 3 new locations, reviewed by user 2026-09-24 (my picks: ruins + King news as tier 1 rumors, Worker id `pawn`, canon ends day 19). Validator 0 errors. `sim_canon_book1` LAST_DAY 19, drift 0; new test: kill the Free Queen → no Workers, Goblins still come. GUT 384/384. PR #15 merged, tag `m6.3-done`.
  - [x] M6.4 Player hooks + news (branch `feat/m6.4-hooks-news`): event `news` + `hooks` (cancel / change / mutate, matched on action records), records keep `context`, `world.news`, outcome `changed` (drift 0.25), Local News page, journal (your changes, drift, 7 days of news, PgUp/PgDn), console `news`, save v7, validator hook checks. 3 cases in data (Rock Crab → mutate, cook for the regulars → change, fight Goblins → Rags cancelled) + 13 news lines. ADR 0011 M6.4. GUT 408/408, Python 32, validator 0 errors. PR #16 merged, tag `m6.4-done`.
  - [x] M6.5 Canon fights + `sim_m6_done` (branch `feat/m6.5-canon-fights`): canon event `stage` (the Chieftain comes into the inn on day 9, 09–12, Erin fights with the player; `world.staged`), `NpcReact` (guards and stage allies fight, others step away or stand still; NPCs have no HP), sparing (`spare_foe`, context `killed`; the Rags hook needs a kill), enemy `goblin_chieftain`, `change` hook `player_fought_chieftain`, levels base 40 / growth 1.25, save v8, validator stage checks. `sim_m6_done` (seed 1) checks the M6 "Done when". ADR 0011 M6.5. GUT 440/440 (46 scripts), Python 36, validator 0 errors. PR #17 merged, tags `m6.5-done` and `m6-done`.
- [x] M7 — Rest of Book 1 (done 2026-09-25, tags `m7.4-done` and `m7-done`; 4 canon batches, see ROADMAP and ADR 0012)
  - [x] M7.1 Canon 1.26R–1.34 (branch `data/book1-1.26-1.34`): 19 events (days 15–23), 11 new NPCs, 8 new locations, reviewed by user 2026-09-24. PR #18 merged, tag `m7.1-done`. Review answers applied: guilds in Remendia/Wales/Celum are all correct; Lich run + crushed leg on day 15 ("a week ago"); raiders' grave several hundred feet away. The Goblin raid on day 21 (`b1.klbkch_dies_defending_erin`) is a canon stage in the inn (12–14, raid leader + 5 Goblins, Erin fights) with a `change` hook; Klbkch still dies (user choice). New enemy `goblin_raid_leader`, spawn `crab_hill_unpatrolled` (after the Watch leaves), Pawn visits the inn, Relc stays away. Validator 0 errors. `sim_canon_book1` LAST_DAY 23, drift 0; new `sim_goblin_raid`. GUT 447/447 (47 scripts), Python 36. Checked on screen.
  - [x] M7.B Big battles (plan approved 2026-09-24, branch `feat/m7b-battles`): NPC HP (down, not dead; only the director kills), monsters go for the nearest of player / fighting NPC / helper, helpers (state `ally`), stage waves (`stage.waves`, `max_on_map` 12), allies pulled in from other areas, HP bars, labels without overlap, "Foes left"; raid remade as 40 Goblins in 4 waves (Klbkch wave 2, Rags + 3 helpers wave 3); save v9. ADR 0013. GUT 468/468 (49 scripts), Python 39, validator 0 errors. Checked on screen. PR #20 merged, tag `m7b-done`.
  - [x] M7.2 Canon 1.35R–1.44R (branch `data/book1-1.35-1.44`): 24 events (days 24–33), reviewed by user 2026-09-24. 6 new NPCs (`gazi_pathseeker`, `teriarch`, `ksmvr`, `toren`, `princess_thief`, `theofore`), 4 new locations (incl. `teriarch_cave`), 2 stage-only enemies. Teriarch is not linked to the 1.00 Dragon (user: not confirmed). Stage + `change` hook: three adventurers attack Rags's Goblins in the inn on day 28, 19–21. Engine fix: indoors, fleeing monsters walk to the exit. Validator 0 errors. `sim_canon_book1` LAST_DAY 33, drift 0; new `sim_inn_brawl`. GUT 478/478 (50 scripts), Python 39. Checked on screen. PR #21 merged, tag `m7.2-done`.
  - [x] M7.3 Canon 1.45–1.54 (branch `data/book1-1.45-1.54`): 24 events, reviewed by user 2026-09-24, (days 34–37) in 10 chapter files, 3 new NPCs (`yvlon_byres`, `cervial_dermondy`, `tkrn`), 2 new locations, stage-only enemy `goblin_feathered_chieftain`. Stage + `change` hook: fight beside Rags against the feathered tribe on the Floodplains, day 35, 08–11. The Horns lodge at the inn from night 35; Pawn stays away while judged. Validator 0 errors. `sim_canon_book1` LAST_DAY 37, drift 0; new `sim_goblin_battle`. GUT 486/486 (51 scripts), Python 39. Checked on screen. PR #22 merged, tag `m7.3-done`.
  - [x] M7.4 Canon 1.55R–1.63 (branch `data/book1-1.55-1.63`, PR #24 merged; reviewed by user 2026-09-25): 21 `candidate` events (days 38–41) in 9 chapter files, 3 new NPCs (`bird`, `tekshia`, `hawk`), 7 new enemy types (undead, `skinner`, 2 Antinium helper types). User choices 2026-09-24: new `revive` effect (Klbkch reborn), Calruz/Ceria/Olesm missing (not killed), two stages (east gate + inn hill) with `change` hooks. Engine fix: a stage ally brought in during a long step stays. Validator 0 errors. `sim_canon_book1` LAST_DAY 41, drift 0; new `sim_skinner_night`. GUT 499/499 (52 scripts), Python 40. Checked on screen.

## M7 decisions (user, 2026-09-24)
- M7.4: add a `revive` effect (Klbkch reborn); Calruz, Ceria and Olesm are missing, not dead (the text never shows them die); two playable fights on the night of day 39 (east gate + inn hill).
- Big battles: option 1 (full battle upgrade). An NPC at 0 HP is down, not dead; only the director decides deaths. M7.1 approved.
- Split: 4 canon batches of about 10 chapters (my pick). New systems only when a batch needs them.
- Goblin raid on day 21: `change` hook; Klbkch still dies even if the player fights and wins.

## M6.5 decisions (user, 2026-09-24)
- Chieftain fight = `change` hook (Erin still kills him; no stab/burn; Erin → player +3). Sparing: `spare_foe` record + Rags hook needs a kill. NPCs have no HP. Tune levels (about level 5 by day 21). `stage` schema and save v8 approved.

## M6 decisions (user, 2026-09-23)
- Canon: all chapters 1.15–1.25 (incl. R, A and Interlude – King Edition). Hooks on each canon event (schema change in M6.4, ask for details first). First offer night 2–3. Title menu + 3 slots + autosave.
- Save in a fight is allowed (ROADMAP: "save/load at any point").

## M5 decisions (user, 2026-09-23)
- HP 0 = knocked out (no death). One held improvised item (no inventory). Enemies: Goblin grunt, Rock Crab, Razorbeak. A monster at 0 HP dies. Knock-out wake: nearest safe place (Floodplains / inn hill → inside the inn; Liscor gate / market → the gate; else where you fell). 3 sub-modules.
- Approved schemas: `enemies.json` (+ spawns), `items.json`, rules `combat`, map object `item` field + razorbeak zone/objects (M5.2), save v6.
- Canon goblin NPCs stay non-hostile; canon-event fights and guards who fight are M6. `[Bar Fighting]` / `[Unerring Throw]` need a separate OK.

## M4 decisions (user, 2026-09-23)
- Float saves (2026-09-23, user chose option 2): save floats as exact text. Done in M4.4 (ADR 0008).
- Start: the player arrives with the Great Ritual (night 7) and starts outside the Liscor east gate on day 8 (user choice). New game must run the director for days 1–7 first. Celum start deferred to M7+ (no Celum canon yet; first seen 1.19R).
- Art: placeholder colored tiles made in code; Kenney CC0 later (ask then).
- NPCs: extract 1.10–1.14 first (adds Selys, Krshia, Lism, Belsc, Drassi).
- Map: small linked areas (Liscor gate, market, Floodplains patch, inn hill, inn inside).
- Approved: new schemas `tiles.json`, `maps/<area>.json`, `npc_behaviour.json`; rules `world` + `npc`; `Actions.perform` `minutes` opt; `Session` autoload; save v4 and v5.

## Architectural decisions (ADR 0001–0013)
- ADR 0013 (accepted, M7.B big battles): NPC HP (down, not dead; heal at night), `Combat.monster_target`, helpers (state `ally`), fighters pick reachable foes, `stage.waves` + `combat.stage_run`, `npc_behaviour` `combat` blocks, save v9, HP bars and label de-overlap, HUD foes left. Known limit: the raid is hard to win at 20 HP (balance for play-testing).
- ADR 0012 (accepted, M7 plan + M7.1 raid): 4 canon batches; the raid as a stage in `inn_interior` with a `change` hook; `goblin_raid_leader` only from the stage; the unpatrolled spawn is a Rock Crab stand-in (1.34: no more Goblins came); each event uses the Runners' Guild its chapter names (Remendia / Wales / Celum conflict flagged).
- ADR 0012 M7.2 section (accepted; no schema or save change; Teriarch kept apart from the 1.00 Dragon): timeline guesses days 24–33; the day-28 inn brawl as a stage with a `change` hook; stage-only Human adventurer enemies that run (flee_below); `toren` behaviour; Relc makes peace but does not visit every evening yet; indoor areas (no open edge) make fleeing monsters walk to the nearest exit.
- ADR 0012 M7.3 section (accepted 2026-09-24; no schema or save change): timeline days 34–37; the 1.52R Goblin battle as a stage with a `change` hook; Horns lodger schedules; likely links marked `likely` (thief = [Princess], tiny leader = Rags, lost potion = speed potion); two Book conflicts flagged (Relc's Wing, Sostrom's hair).
- ADR 0012 M7.4 section (accepted 2026-09-25): timeline days 38–41; `effects.revive` (director after kill; CanonDb + validator check ids; no save change); Calruz/Ceria/Olesm missing by flags; gate stage (hook on `crypt_lord` at `liscor_east_gate`) and inn-hill stage (hook on `skinner`); stage-only undead and Antinium helper enemies; NpcSim holds a stage ally whose goal is elsewhere on a jump step; Horns miss dinner on day 39; Tekshia name conflict flagged.
- ADR 0011 (accepted, M6.1): `SaveSlots` (headless, folder as a parameter); Continue = newest readable save; autosave when the System dialog closes, on quit to title and on window close; welcome page only for a new game from the title; hints are UI text (not data); journal focus = class main tags (weight ≥ 0.5); thresholds ÷ 3; GUT pre-run hook sets `Session.save_dir`.
- ADR 0011 M6.4 (accepted 2026-09-24): hooks on canon events (`did` / `days` ≤ 7 days / `then` / `effects` for change / `news`); cancel+mutate hooks before `requires`, change hooks when the event fires; history `by: player` + `hook`; `changed` counts as happened; news kept in `world.news` (new game clears days 1–7); save v7.
- ADR 0011 M6.5 (accepted 2026-09-24): canon event `stage` (area, hours, when/unless flags, foes, allies, line; runs once per event while pending, in its window; requires.flags not checked); fights reach events only through hooks; `NpcReact` (fight tags + stage allies fight, others flee within 4 tiles or stand still; after the monsters; no NPC HP); `Combat.settle_if_over` after NPCs; fight context `killed`; `spare_foe` for spare_tags foes; hook relationship `to: "player"`; save v8.
- ADR 0010 (accepted, M5.1–M5.3): M5.3: presentation only, no schema/save change; bump attack once per key press (lock per direction); T throws at `Combat.nearest_foe` (seen monsters, hostile first, then distance, then id); a knock-out runs `Commands.knock_out` at once after any command and opens the knock-out page; `sim_m5_done` uses a fixed seed (2). M5.2: `MonsterSim.run` from `Combat.sync`; long gaps give no turns unless a monster is hostile (then capped); territorial give-up measured from home; goblins that give up go home (not routed); routed counts when a monster starts to flee; objects may have no actions; `DataDb` loads combat before it validates maps. M5.1: no combat mode (each command is a 6 s turn); `Commands._after` = `Combat.sync` + `NpcSim.sync`; monsters only in the player's area (`gs.combat`, save v6); fight counts → one record per action kind at fight end (minutes 0, risk = foe danger, won/fled/KO → success/partial/fail); improvise = context `weapon: improvised`; danger refuses actions/uses/sleep; knock-out wakes at the normal time at a safe place with 25% HP; `Stats` from base stats + stat_mod.
- ADR 0009 (accepted): night result sections (`collapsed`, `progress`, `world`); `SystemMessages` page order and page shape; offers from `gs.progression.offers`; decline asks once more; no skip; console blocked while the dialog waits; map object `sleep` flag (`Interact.SLEEP` is not an action); character sheet (C).
- ADR 0001: GUT version, RNG state as strings in JSON, `.import` files committed, save load path.
- ADR 0002: data schemas (tags, actions, rules, classes, skills), XP formula, clock as one absolute minute counter, saves use full float precision and keep key order.
- ADR 0003: non-zero-sum class pools, decline freezes the pool, offer order and cap, dilution formula, capstone breakthroughs, skill pick weights, xp_mult applied in XP, class loss, night pipeline, `Commands` facade.
- ADR 0004 (accepted): extractor rules; canon data layout (`npcs.json`, `locations.json`, `chapters/<ch>.json`), event schema changes vs DESIGN §4.3 (window.confidence, optional roles, tag-only roles, on_fail ends in cancel, delay_limit, clear_flags, rumor, tier 1–2), chapter `system` log, validator with 7-word copy check.
- ADR 0005 (accepted): canon data in `game/data/canon/`, `CanonDb`, `WorldState` stores only changes (save v3), director rules (strict `requires.alive`, anonymous monster roles, wait/role/hard failures, propagation after cancel or mutate, effect remap to substitutes), drift weights in `rules.json` `director`.
- ADR 0006 (accepted): day-8 start at the Liscor east gate; tiles/maps schemas; `MapDb` validation; `PlayerState` (save v4); steps cost `step_seconds`, exits run `travel` with scaled intensity; interact context = map location + zone + object context; action context uses canon ids (`wandering_inn`). Known issue: Godot JSON float parse is not exact.
- ADR 0007 (accepted): `Session` autoload; console syncs with it; `WorldView` makes its TileSet from tile colors; main scene input (held keys repeat every 0.14 s, E use menu, Z sleep, backtick console); HUD.
- ADR 0008 (accepted): `npc_behaviour.json` schema (entries per off-map place, goals with hours/days/flags, targets pos/route/off_map); rules `npc`; utility AI (ties → first goal, idle = stay); `NpcRoster` (save v5); `NpcSim` level of detail (walk in the player's area, jump elsewhere, pop in on the way, jump on gaps > 300 s); NPCs pass through each other, block the player; night step 6; talk +1 relationship once a day; floats saved as `"f64:<hex>"`.

## Roadmap status (M8, archived 2026-09-26)
- [x] M8 — Book 2 (Fae and Fare) + Celum (plan approved 2026-09-25; 8 sub-modules, see ROADMAP and ADR 0014)
  - [x] M8.0 Cross-book tooling (on the M8.1 branch): validator knows earlier books' ids, `--all`, `--no-earlier`; Book 2 extracted (56 chapters, 501,634 words); `sim_canon_book1` counts `b1.` only. Python 47 tests.
  - [x] M8.1 Canon Interlude – The Call + 2.00–2.09 (branch `data/book2-call-2.09`, PR #26 merged; reviewed by user 2026-09-25, flip PR #27 merged, tag `m8.1-done` on merge commit bfb71a5): 21 events (days 41–44) in 12 chapter files, 2 new NPCs (`octavia`, `peslas`), 4 new locations. New map `ruins_entrance` (180 min east of the Floodplains). Gazi stage (day 42, 13–17) + `change` hook `player_fought_gazi`; new enemy field `escape` (Gazi cannot die; she leaves by portal). New enemies `gazi_of_reim`, helpers `liscor_guardsman`, `gnoll_hunter`; Ksmvr behaviour entry + combat, Krshia combat. Calruz stays missing (user). Validator 0 errors (`--all`). GUT 508 (54 scripts) at last full run. Checked on screen.
  - [x] M8.W Winter (done 2026-09-25, PR #28 merged, tag `m8w-done` on 78de12f): `Winter` + `WinterState` (save v10), cold (1 HP / 30 min outdoors, floor 1; warm indoors (`indoor` map field), near `warm` objects, clothes x2), Frost Fairies (talk `talk_to_fairy` gives `fae` XP; snow + slow when annoyed or swatted; iron `horseshoe` keeps them away), snow look (`winter_color`), map `overlays` (Toren's snow wall from day 44). GUT 529 (56 scripts). Checked on screen.
  - [x] M8.2 Canon 2.10T–2.18 + Interlude – Mating Rituals Pt. 1 (done 2026-09-25, PR #29 merged, tag `m8.2-done` on merge commit c229bf7; branch `data/book2-2.10T-2.18`, days 43–47): 58 events across 10 chapter files. Toren: sent for firewood, blows up the inn with boom-bark, sent away, falls into the Skinner ruins (`liscor_dungeon`) and fights a headless armored guardian, later bursts out at the distant `death_beyond_death` rift (new location; same dungeon, not walkable from that end yet per user decision) where Rags' tribe sees him. Inn rebuilt in a day near Liscor by the Antinium (Klbkch now Revalantor), hamburgers. Rags: rock crab hunt, tribe discovered/spared by Relc, Ceria's warning, builds crossbows ([Leader]/[Tinkerer]), leads her tribe to death beyond death. Ryoka: tells Garia the Horns died, gets a stench potion from Octavia, crosses the High Passes, renegotiates with Teriarch for a homing stone toward Az'kerash, meets Courier Valceif Godfrey (new NPC) after a bandit ambush on Garia, finds the wrecked guardian's armor (links to Toren's fight), a cursed dreamcatcher restores her memory that Teriarch is a dragon. Erin's iPhone concert built a new engine feature: **stage `kind: "scene"`** (`game/core/stage.gd`, `canon_db.gd`, `combat_db.gd`, `npc_sim.gd`) — a non-combat gathering that moves canon NPCs onto the map with no fight; NPCs held in place for the scene's hours instead of following their normal schedule. New NPCs `valceif_godfrey`, `niers_astoragon` (tier 1, Erin's anonymous chess rival), `culyss`. New locations `boom_tree_forest`, `death_beyond_death`, `gnoll_tavern`. Interlude – Mating Rituals Pt. 1 treated as floating flavor canon per user decision (no depends_on into the main chain; does not clear `toren.missing`). Validator 0 errors (`--all`); `sim_canon_book2` extended to day 47, drift 0; GUT 533/533; Python 51/51.
  - [x] M8.3 Canon 2.19G–2.26 + 1.00C/1.01C (done 2026-09-25, days 47-55; branch `data/book2-2.19G-2.26`, PR #30 open): Rags' tribe takes a mountain dungeon and conquers the Jawbreaker Tribe; Relc beats Rags at the inn, Erin stands between them. Erin's Frost Faerie banquet (new `kind: "scene"` stage) earns [Inn's Aura] and [Wondrous Fare]. A noblewoman, later Lyonette du Marquin, is caught stealing, exiled into the snow, rescued by Erin, and taken in over Krshia's objections. Toren's week-long hunting montage ends with Griffon Hunt "killing" him twice for loot; he returns just as Krshia's kinsman Brunkr leads a Silverfang war party on the inn - the M8.3 combat stage, ended by the Halfseekers, who offer Ceria a team spot. Reim: Gazi reports to Flos's war council as the Empire of Sands sends Drevish's head, starting a war. New interlude 1.00C/1.01C introduces Tom on the distant continent Rhir (real canon per the user, matters later, not flavor-only - see `docs/adr/`). New NPCs: Rockgaw, Lyonette, Brunkr, Griffon Hunt (Halrac/Typhenous/Revi/Ulrien), Halfseekers (Jelaqua/Seborn/Moore), Dreshhi, Mars, Takhatres, Trey, Teresa, Drevish, Tom, Richard, Emily, Wilen. New locations: goblin_mountain_lair, jawbreaker_camp, empire_of_sands, rhir, blighted_lands. New enemy `silverfang_gnoll_warrior`. Validator 0 errors (`--all`); `sim_canon_book2` to day 55; GUT 533/533; Python 51/51.
  - [x] M8.4 Canon 2.27G–2.38 (done 2026-09-25, PR #31 merged, tag `m8.4-done` on merge commit 18d61bc; branch `data/book2-2.27G-2.38`, days 56-67): Rags absorbs the Gold Stone Tribe, survives Garen's week of testing-by-raid, then wins the legendary Red Fang Tribe in a valley duel (Garen submits, warns of a rising Goblin Lord); she and Garen later sneak disguised toward the inn (cliffhanger). Ryoka is nursed by the Stone Spears Gnolls, earns their truce with Earth stories, stumbles into the Zel Shivertail/Ilvriss war, escapes into Az'kerash's hidden castle to deliver Teriarch's letter, then rescues the cub Mrsha from a crevasse only for the Goblin Lord's army to overrun the camp (Chieftain Urksh killed) - a faerie cancels the [Barefoot Runner] class the System offers her; she never gains a level. Erin invents pizza, discovers faerie-gold coins, calms Halrac's grief, and tells Bible stories that earn Pawn Liscor's first Antinium [Acolyte] class (new `kind: "scene"` stage + hook `player_heard_erins_stories`); the Horns of Hammerad reform and fight a goblin raid; Magnolia hosts and briefs Erin on the coming war. New NPCs (11): Garen, Urksh, Mrsha, Zel Shivertail, Ilvriss, Periss, Az'kerash, Reynold, Imani, Joseph, Rose. New locations (4): red_fang_territory, stone_spears_camp, azkerash_castle, magnolia_estate. No new enemies (no fight lands on a player-reachable map this batch). Rags' and Ryoka's remote arcs use placeholder days (precedent: M8.3's 2.22K/2.24T), noted in `canon_ref.note`. Periss's death is only implied on-page - left alive with flag `periss.presumed_dead`, not asserted dead. Ksmvr's second demotion (2.32H) uses a new flag `ksmvr.relieved_of_duty` rather than reusing `ksmvr.deposed`, since `sim_canon_book2` already asserts `ksmvr.deposed` false through `LAST_DAY`. Validator 0 errors (`--all`); `sim_canon_book2` extended to day 67; GUT 533/533; Python 51/51.
  - [x] M8.5 Celum map + Celum start (done 2026-09-25, [PR #32](https://github.com/Daddy-Ousen/innworld-rpg/pull/32) merged, tag `m8.5-done` on merge commit 53e9d9f): `rules.world.start` replaced by `rules.world.starts` list (user-approved schema change; Liscor first = default, Celum second; each has an `intro` line for the welcome page). `Movement.start_of`, `GameState.new_game(seed, db, start_id)`; no save change. Title screen: New game opens a start chooser (+ Back). Console `new [seed] [start]`. 3 design maps: `celum_gate` (start 16,4), `celum_square` (guild door, Rat's Tail + Stitchworks signs, well, stall, braziers), `celum_runners_guild` (indoor). NPC entry place `celum`; `wesle` guards the gate 06-18, `stenei` at the guild counter 08-18. Knock-out in Celum wakes at the Celum start. No Celum-Liscor road yet (M8.6). GUT 544/544 (57 scripts); validator 0 errors; Python 51/51. Checked on screen.
  - [x] M8.6 Economy + travel (done 2026-09-25, [PR #33](https://github.com/Daddy-Ousen/innworld-rpg/pull/33) merged, tag `m8.6-done` on merge commit 1858f9d, ADR 0015): save v11 (`EconomyState`: coins, bag, fed_day, hunger, haggled). New `data/economy.json` (`EconomyDb`: goods, shops, yields, jobs), `rules.economy`, map fields `camp`, object `shop`/`price`/`ride` (user-approved schema changes). `core/economy.gd` (trade = buy_supplies/sell_goods for 5 min, haggle 10% for the day, yields, `deliver_parcel` job 3-6c, eat/drink, hunger night step, wagon ride), `core/rest.gd` (bed full, floor indoors/camp half, outdoors refused; `Rest.ANYWHERE` for debug/tests). Hunger: -10% max HP per hungry night, floor 50%; only a sleep into a new day counts; Erin feeds inn workers. New map `road_camp` (10 h to each gate), wagons at both gates (40c, 8 h, no cold). UI: shop/ride/room lines in the use menu, F = bag, coins + Hungry on the HUD status line, bag on the character sheet, console `bag/buy/sell/eat/ride/give`, `sleep [bed|*]`. GUT 580/580 (61 scripts); validator 0 errors; Python 51/51. Checked on screen.
  - [x] M8.7 Canon Interlude – Quiet Discussions + 2.39–2.48 (done 2026-09-26, branch `data/book2-2.39-2.48`, ADR 0014 M8.7 section): 45 events in 11 chapter files, days 67–71. Erin stranded by Toren (day 70) and at the Frenzied Hare in Celum (day 71, new indoor map `celum_frenzied_hare`, 6c room, bar shop); Toren off the map from day 70; Rags banned from the inn. 4 stages: Snow Golems (floodplains_south), sledding crowd scene (inn_hill), Celum muggers (celum_square), Hare bar fight. Stage-only enemies `snow_golem`, `celum_mugger`, `brilliant_swords_adventurer`, helper `frenzied_hare_regular`. 12 new NPCs, 7 new locations; Niers corrected to a Fraerling, Level 64 [Grandmaster Strategist]. Antinium Wars interludes = history, no events. `sim_canon_book2` LAST_DAY 71; new `sim_erin_in_celum`, `sim_book2_end_stages`. GUT 591/591 (63 scripts); validator 0 errors; Python 51/51. Checked on screen.

## M8 decisions (user, 2026-09-25)
- Scope: Book 2 + Celum; no audio or LLM (Later). 5 canon batches. Celum map + second start (day 8, Celum gate). Travel: paid ride + road with one camp map. Full economy: coins, goods bag, simple hunger (one meal a day; Erin feeds you on a day you work at her inn), paid room in Celum (Erin's bed and the camp bedroll free), earn from odd jobs and selling. Order: batches 1–4, Celum map, travel + economy, batch 5.
- M8.1: Gazi stage on a new Ruins-entrance map (she cannot die, escapes by portal); winter = snow look + cold rules + Frost Fairies on the map (M8.W); Calruz stays missing.
- M8.W: mild cold (1 HP / 30 min, never below 1); warm = indoors, near a fire, winter clothes; fairies = pests you can talk to + `fae` XP; snow look + Toren's snow wall.
- M8.7 (2026-09-26): Erin moves to Celum (the Frenzied Hare) from day 71; the Hare gets an indoor map; 4 stages (Snow Golems, sledding crowd, Celum muggers, Hare bar fight); Toren leaves the map from day 70.

## Architectural decisions (M8)
- ADR 0014 (plan accepted 2026-09-25; M8.1 accepted 2026-09-25): cross-book validator; M8.1 timeline days 41–44; `ruins_entrance` map; enemy `escape` field (Gazi); Gazi stage + `change` hook; Ksmvr behaviour entry.
- ADR 0015 (plan accepted 2026-09-25): M8.6 economy + travel. User: no sleep outdoors except a camp; floor half heal, bed full; hunger lowers max HP; road 2 x 10 h.

## Roadmap status (M9, archived 2026-09-26)
- [x] M9 — Book 3 (Flowers of Esthelm). Plan approved 2026-09-26 (ADR 0016, ROADMAP M9). 4 batches:
  - [x] M9.1 3.00 E – 3.05 L + 1.00 D / 1.01 D — merged ([PR #36](https://github.com/Daddy-Ousen/innworld-rpg/pull/36)), tag `m9.1-done` (4b31284). 39 events, Persua guild fight (stage) + Lyonette reopening (scene), both with hooks.
  - [x] M9.2 3.06 L – 3.14 — merged ([PR #37](https://github.com/Daddy-Ousen/innworld-rpg/pull/37)), tag `m9.2-done` (a07b7fc). 41 events; Ryoka and Fals at the Hare (scene + hook); Corusdeer soup (save v12).
  - [x] M9.3 3.15 – 3.20 T — merged ([PR #38](https://github.com/Daddy-Ousen/innworld-rpg/pull/38)), tag `m9.3-done` (5cced62). 37 events; `esthelm_ruins` map; the Esthelm siege (wave stage) and Erin's play (scene).
  - [x] M9.4 3.21 L – 3.25 — merged ([PR #39](https://github.com/Daddy-Ousen/innworld-rpg/pull/39)), tags `m9.4-done` and `m9-done` (9e8f179). 38 events, Book 3 ends day 87; `bee_cave` map and the dawn bee raid (fight stage + hook); four scenes with hooks (painted Soldiers, Zel at the inn, Frozen, Erin leaves Celum); Zel, Jasi, Yvlon schedules; Albez door as flags only. GUT 629/629 (67 scripts), validator 0 errors (`--all`), Python 51/51. Not checked on screen.

## M9 decisions (user, 2026-09-26)
- Four canon batches, one branch + PR each. Laken and Geneva are events only. Esthelm is a playable map with the siege as a wave stage. Stage and hook choices are asked at the start of each batch.
- M9.4: the dawn bee raid as a fight stage; four scenes (painted Soldiers, Zel at the inn, Frozen, Erin leaves Celum); the Albez door as flags only (portal is Book 4 work).

## Architectural decisions (M9)
- ADR 0016 (plan accepted 2026-09-26): Book 3 batches, placeholder days for far threads, Corusdeer soup warmth (save v12), `esthelm_ruins` and `bee_cave` maps.

## Roadmap status (M10, archived 2026-09-27)
- [x] M10 — Book 4 (Winter Solstice). Plan chosen 2026-09-26 (ADR 0017, ROADMAP M10): the door first, then 5 canon batches; Wistram Days as history only.
  - [x] M10.0 The Albez door — merged ([PR #40](https://github.com/Daddy-Ousen/innworld-rpg/pull/40)), tag `m10.0-done` on merge commit 3284dea. Map objects with `when_flags`/`unless_flags` and `portal`; `rules.portal` (4 trips a day); `core/portal.gd`; save v13; new map `celum_stitchworks`. Flags for the canon batches: `albez_door.anchor_at_stitchworks`, `albez_door.at_wandering_inn`, `erin.magical_grounds`. GUT 640/640 (68 scripts). Checked on screen.
  - [x] M10.1 3.26 G – 3.29 G — merged ([PR #41](https://github.com/Daddy-Ousen/innworld-rpg/pull/41)), tag `m10.1-done` on merge commit ce7d682. 17 events (days 85–90), 6 NPCs, 3 locations, new map `dungeon_rift` + tile `chasm`. Two scenes with hooks: Lyonette searches the snow; the rescuers at the rift. GUT 651/651 (70 scripts). Checked on screen.
  - [x] M10.2 3.30 – 3.31 G + Wistram Days (history) — merged ([PR #42](https://github.com/Daddy-Ousen/innworld-rpg/pull/42)), tag `m10.2-done` on merge commit ccf8743. 12 events (days 89–92), 10 NPCs (8 Wistram, history only), 2 locations. One scene with a hook: Ceria tells Erin of Wistram at the Frenzied Hare (night 89). Door anchor moves to the Stitchworks. GUT 659/659 (71 scripts).
  - [x] M10.3 3.32 – 3.35 — merged ([PR #43](https://github.com/Daddy-Ousen/innworld-rpg/pull/43)), tag `m10.3-done` on merge commit 51fbbae. 22 events (days 90–93), 1 new NPC (Umbral), class `magical_innkeeper` + Erin's two Skills. Two scenes with hooks: Zel scolds Erin (day 91), Erin pitches the Esthelm relief (day 92). Erin is home on day 91, Level 30 that night, the door runs from day 92; from day 92 she is at Esthelm (`erin.at_esthelm`). GUT 670/670 (72 scripts).
  - [x] M10.4 3.36 – 3.39 — merged ([PR #44](https://github.com/Daddy-Ousen/innworld-rpg/pull/44)), tag `m10.4-done` on merge commit 2696cfe. 27 events (all day 93; Erin's ride home is day 92), 4 NPCs (Hedault, Merec, Raisha, Regisand Curle), 2 locations. One scene with a hook: the Rock Crab by the inn road (Erin, Lyonette). Valceif dies on day 93. The slime scene (3.35) moved to day 92. GUT 679/679 (73 scripts).
  - [x] M10.5 3.40 – 3.42 + Winter Solstice — built on branch `data/book4-3.40-solstice` merged ([PR #45](https://github.com/Daddy-Ousen/innworld-rpg/pull/45)), tags `m10.5-done` and `m10-done` on merge commit 25b8d94. 32 events (days 93–96), 2 NPCs (Anabelle, Tamaroth), 3 locations, enemy `liscor_house_thief`. Two scenes with hooks: the Santa thieves in Liscor market (day 94, Relc and Klbkch), Erin in the snow on Christmas night (day 95, comfort her). Ryoka runs to Riverfarm (rests there day 95, user choice) and turns for home on day 96. Book 4 ends on day 96. GUT 689/689 (74 scripts).

## Architectural decisions (M10)
- ADR 0017 (plan chosen 2026-09-26): the Albez door first (save v13, `core/portal.gd`), then 5 canon batches; Wistram Days as history only. Book 4 ends on day 96.

## Roadmap status (M11, archived 2026-09-27)
- [x] M11 — Graphics, characters and animation. Plan accepted 2026-09-27 (ADR 0018, ROADMAP M11). New books paused. User choices: 2D pixel art, 32 px cells; free LPC packs + our edits (credits file); standard animation first.
  - [x] M11.0 Art spike: merged ([PR #46](https://github.com/Daddy-Ousen/innworld-rpg/pull/46)), tag `m11.0-done` on ea93b99. 32 px cells, LPC tiles, baked character sheets, player step glide.
  - [x] M11.1 Tiles and objects: merged ([PR #47](https://github.com/Daddy-Ousen/innworld-rpg/pull/47)), tag `m11.1-done` on 84eab06. All 16 tiles and 67 map objects have art.
  - [x] M11.2 Characters: merged ([PR #48](https://github.com/Daddy-Ousen/innworld-rpg/pull/48)), tag `m11.2-done` on d000380. 43 looks, Antinium edits.
  - [x] M11.3 Animation: merged ([PR #49](https://github.com/Daddy-Ousen/innworld-rpg/pull/49)), tag `m11.3-done` on ebdcbf0. Sheet layout v2 (128 px attack block), `world/anim_diff.gd`, glides, hit flash, damage numbers, falls, swings.
  - [x] M11.4 Monsters: merged ([PR #50](https://github.com/Daddy-Ousen/innworld-rpg/pull/50)), tag `m11.4-done` on b76ff4a. All 36 enemies have a sheet: 30 LPC people looks, 6 creatures from `tools/build_creatures.py` (LPC golem, bee, big worm, eagle recoloured; Rock Crab and snowman Snow Golem drawn). Monsters with a sheet are sprites with a state ring; gone ones fall and fade; a hidden crab is the rock prop. GUT 726/726 (78 scripts), Python 73/73, validator 0 errors.
  - [x] M11.5 Atmosphere: merged ([PR #51](https://github.com/Daddy-Ousen/innworld-rpg/pull/51)), tags `m11.5-done` and `m11-done` on 7bb4656. `world/atmosphere.gd`: sky tint by the clock (room light indoors), fire light from `"light"` in `objects.json` (campfire, brazier, hearth, stove; user OK for the schema change), snow outdoors in winter. GUT 736/736 (79 scripts), Python 73/73, validator 0 errors. The user checked it and merged.

## Architectural decisions (M11)
- ADR 0018 (plan accepted 2026-09-27): 2D pixel art, 32 px cells, LPC packs plus our edits (`CREDITS.md`); art picked by data with square fallbacks; core and saves unchanged; M11.5 `"light"` key in `objects.json`.

## Roadmap status (M12, archived 2026-09-28)
- [x] M12 — Audio (plan accepted 2026-09-27, ADR 0019). Sources: free CC0/CC-BY packs + `tools/build_sfx.py`; music by place and mood plus canon moments.
  - [x] M12.0 Audio spike: merged ([PR #52](https://github.com/Daddy-Ousen/innworld-rpg/pull/52)), tag `m12.0-done` on 65aa03b. The user approved the sound (2026-09-27).
  - [x] M12.1 Audio core + settings: merged ([PR #53](https://github.com/Daddy-Ousen/innworld-rpg/pull/53)), tag `m12.1-done`. The user checked the Options menu (2026-09-27).
  - [x] M12.2 Sound effects: merged ([PR #54](https://github.com/Daddy-Ousen/innworld-rpg/pull/54)), tag `m12.2-done`. The user approved the sounds (2026-09-27).
  - [x] M12.3 Music: merged ([PR #55](https://github.com/Daddy-Ousen/innworld-rpg/pull/55)), tag `m12.3-done` on 081b377. The user approved the music (2026-09-27).
  - [x] M12.4 Ambience: merged ([PR #56](https://github.com/Daddy-Ousen/innworld-rpg/pull/56)), tag `m12.4-done` on bf84ad6. The user approved the ambience (2026-09-27).
  - [x] M12.5 Canon moments: merged ([PR #57](https://github.com/Daddy-Ousen/innworld-rpg/pull/57)), tags `m12.5-done` and `m12-done` on 95fb6c4. 7 CC0 tracks, 9 moments, sad sting on death news. GUT 800/800 (86 scripts), Python 77/77, validator 0 errors. The user approved it (2026-09-28).

## Architectural decisions (M12)
- ADR 0019 (plan accepted 2026-09-27): audio is presentation only (no core or save change); volumes in `user://settings.cfg`; all cues, moods, moments and beds in `data/audio.json`; `"sound"` key in `objects.json` (M12.4); CC0 / CC-BY packs plus `tools/build_sfx.py`; about 60 MB audio at most (56 MB used).

## Roadmap status (M13, archived 2026-09-28)
- [x] M13 — Book 5 (The Last Light). Plan accepted 2026-09-28 (ADR 0020).
  - [x] M13.0 World: gated exits, inn third floor + watchtower, depths + crypt maps, new enemies. Merged ([PR #58](https://github.com/Daddy-Ousen/innworld-rpg/pull/58)), tag `m13.0-done` on 39e94da.
  - [x] M13.T Traps (save v14). Merged ([PR #59](https://github.com/Daddy-Ousen/innworld-rpg/pull/59)), tag `m13.t-done` on 85dd0e9.
  - [x] M13.1 Canon 4.00 K – 4.07 (days 97–100). Merged ([PR #60](https://github.com/Daddy-Ousen/innworld-rpg/pull/60)), tag `m13.1-done` on 67fef71.
  - [x] M13.2 Canon 4.08 T – 4.12 (days 101–102). Merged ([PR #61](https://github.com/Daddy-Ousen/innworld-rpg/pull/61)), tag `m13.2-done` on db1e2dd.
  - [x] M13.3 Canon 4.13 L – 4.17 (days 101–111). Merged ([PR #62](https://github.com/Daddy-Ousen/innworld-rpg/pull/62)), tag `m13.3-done` on 539ff32.
  - [x] M13.4 Canon 1.02 D – 1.06 D (Geneva in Baleros, days 77–90, off-map). Merged ([PR #63](https://github.com/Daddy-Ousen/innworld-rpg/pull/63)), tag `m13.4-done` on 069a265.
  - [x] M13.5 Canon 4.18 – 4.23 E (Liscor days 106–109; Laken days 111–118, off-map). Merged ([PR #64](https://github.com/Daddy-Ousen/innworld-rpg/pull/64)), tag `m13.5-done` on 62806ef.
  - [x] M13.6 Canon 4.24 – 4.27 H (Liscor days 110–111; Niers and Magnolia off-map to 113; Creler cave map). Merged ([PR #65](https://github.com/Daddy-Ousen/innworld-rpg/pull/65)), tag `m13.6-done` on 9c37803.
  - [x] M13.7 Canon 4.28 – 4.31 (days 111–114). 32 events, Imenet merged into Ijvani, Regrika fight + feast and pyre scenes. Merged ([PR #66](https://github.com/Daddy-Ousen/innworld-rpg/pull/66)), tags `m13.7-done` and `m13-done` on 17b6bab. GUT 914 tests (98 scripts), Python 78 OK, validator 0 errors.

## Architectural decisions (M13)
- ADR 0020 (plan accepted 2026-09-28): one branch + PR per sub-milestone; world and traps first, then 7 canon batches; 4.00 K – 4.06 K are history notes only; stage and hook choices asked at the start of each canon batch; traps in save v14.

## Roadmap status (M14, archived 2026-09-29)
- [x] M14 — Engine works (plan accepted 2026-09-28, ADR 0021; plan file `C:\Users\rhasa\.claude\plans\start-engine-works-plan-bright-patterson.md`).
  User choices: all four areas (inn play, living world, UI skin + portraits, balance); attack NPCs with a fate
  warning; guests = patrons + canon NPCs; free pixel font (ask before the download).
  - [x] M14.0 Bag screen — merged ([PR #67](https://github.com/Daddy-Ousen/innworld-rpg/pull/67)), tag `m14.0-done` on merge commit 801e382.
  - [x] M14.1 Cooking recipes — merged ([PR #68](https://github.com/Daddy-Ousen/innworld-rpg/pull/68)), tag `m14.1-done` on merge commit 7c31db7.
  - [x] M14.2 Guests and serving (save v15) — merged ([PR #69](https://github.com/Daddy-Ousen/innworld-rpg/pull/69)), tag `m14.2-done` on merge commit 12c4ddd.
  - [x] M14.3 Standing (save v16) — merged ([PR #70](https://github.com/Daddy-Ousen/innworld-rpg/pull/70)), tag `m14.3-done` on merge commit 8365ae8.
  - [x] M14.4 NPC schedules (data only) — merged ([PR #71](https://github.com/Daddy-Ousen/innworld-rpg/pull/71)), tag `m14.4-done` on merge commit 6c8bd55. 13 NPCs got schedules, looks and sheets.
  - [x] M14.5 Attack NPCs (save v17) — merged ([PR #72](https://github.com/Daddy-Ousen/innworld-rpg/pull/72)), tag `m14.5-done` on merge commit 5f0a5a3.
  - [x] M14.6 UI skin — merged ([PR #73](https://github.com/Daddy-Ousen/innworld-rpg/pull/73)), tag `m14.6-done` on merge commit 0f094ad.
  - [x] M14.7 Portraits — merged ([PR #74](https://github.com/Daddy-Ousen/innworld-rpg/pull/74)), tag `m14.7-done` on merge commit 290d4f2.
  - [x] M14.8 Balance — merged ([PR #75](https://github.com/Daddy-Ousen/innworld-rpg/pull/75)), tags `m14.8-done` and `m14-done` on merge commit a08c23a: `rules.combat.hp_per_level` = 3 (`Stats.max_hp`), three probes `sim_balance_progress|money|fights`, ADR 0021 M14.8 section. Probes pass; full suite (109 scripts, 1019 tests) passes after one test fix (`unit_console` no longer reads a fight leaked into `Session` by `unit_brawl`). User decision 2026-09-29: leave the Rock Crab and the day-21 raid as they are (too hard for one player; a knock-out keeps canon).

## Roadmap status (M15, archived 2026-09-29)
- [x] M15 — Readability and lore fixes (plan 2026-09-29, ADR 0022). The four sub-milestones were one stacked branch chain and merged as one PR ([PR #77](https://github.com/Daddy-Ousen/innworld-rpg/pull/77), merge commit b93e2df).
  - [x] M15.0 Font: Pixel Operator (CC0), 16 px grid, "Large text" option (`ui/text_settings.gd`, `user://settings.cfg`).
  - [x] M15.1 The player's day: `Clock.player_day` (arrival = Day 1) on every screen; core and saves keep the canon day.
  - [x] M15.2 HUD log: 3 lines, bottom left, fades; L = message history, H = help page (`ui/text_page.*`).
  - [x] M15.3 No XP numbers and no total level on player screens; the debug console keeps the numbers.
  - Full suite after M15.3: 111 scripts, 1039 tests pass; Python tool tests 77 pass.

## Roadmap status (M16, archived 2026-09-29)
- [x] M16 — Maps, art and cities (plan 2026-09-29, ADR 0023 audit, 0024 Liscor, 0025 Celum, 0026 other maps). Six sub-milestones on one stacked branch chain, merged as one PR ([PR #78](https://github.com/Daddy-Ousen/innworld-rpg/pull/78), merge commit 98a3b08). No `game/core/` change, no save change.
  - [x] M16.0 Art audit: 25 problems mapped to M16.1-M16.6 (ADR 0023).
  - [x] M16.1 Nature art: cliffs, rocks, boulders, ford; `GroundArt.edge_pieces` / `mix`, `tools/build_cliffs.py`.
  - [x] M16.2 Buildings: house tiles (`tile.house`, `tools/build_houses.py`), stone / brick / plain / ruin styles, snow roofs.
  - [x] M16.3 Doors and signs: object or exit field `sign`, `SignArt`, `tools/build_signs.py`, `plaque` objects; the yellow exit tint is gone.
  - [x] M16.4 Liscor districts: 6 street maps, guild / Watch / tavern rooms, `Crowd` walkers (`world/crowd.gd`), NPC schedules moved to the rooms.
  - [x] M16.5 Celum districts: gate, square, main street, Stitchworks street, Hare street, poor quarter; guild plaques.
  - [x] M16.6 Other maps: gate towers and gatehouses, inn goblin board, Esthelm shacks, ruins ditch and Watch tents, road camp signs, `wood_window` tile in 11 rooms, cave cobwebs / bones / mushrooms.
  - Full suite (subagent) at M16.6: 118 scripts, 1101 tests pass; Python tool tests 95 pass; validator 0 errors.

## Roadmap status (M17, archived 2026-10-01)
- [x] M17 — Tactical combat, XCOM-style (plan 2026-09-30, ADR 0027; the user's AP rules in ADR 0022). Nine sub-milestones,
  one PR each. Save v17 → v20. The user has not yet played M17.6–M17.8 fights (`godot --path game`; no display in the cloud).
  - [x] M17.0 Spike: `rules.combat.tactical`, `unit_tactical_rules`, paper fights; ADR 0027 approved. Tag `m17.0-done`.
  - [x] M17.1 Core encounter: `core/encounter.gd`, save v18 ([PR #79](https://github.com/Daddy-Ousen/innworld-rpg/pull/79), a175d2a). Tag `m17.1-done`.
  - [x] M17.2 Old fight parts on AP (block, throw, take, drop, bag, brawl, fairy swat), NPC fighters in the turn order,
    combat mode ON ([PR #80](https://github.com/Daddy-Ousen/innworld-rpg/pull/80), 07f19a3). Tag `m17.2-done`.
  - [x] M17.3 Combat screen: turn order faces, AP pips, move range, hit chance, replay of others' turns
    ([PR #81](https://github.com/Daddy-Ousen/innworld-rpg/pull/81), d470158). Tag `m17.3-done`.
  - [x] M17.4 Skills in combat: `core/combat_skills.gd`, `combat_action`, cooldowns, NPC ally Skills, Skill bar, save v19
    ([PR #82](https://github.com/Daddy-Ousen/innworld-rpg/pull/82), 79490a6). Tag `m17.4-done`.
  - [x] M17.5 Mana and spells: `core/mana.gd`, `core/spells.gd`, `core/spell_db.gd`, `data/spells.json`, [Mage], NPC casters,
    save v20 ([PR #83](https://github.com/Daddy-Ousen/innworld-rpg/pull/83), 68f5f38). Tag `m17.5-done`. Full suite then: 128 scripts, 1339 tests.
  - [x] M17.6 Cover and position: `core/cover.gd`, half -15 / full -30, pincer +15, walls block sight; no save change
    ([PR #85](https://github.com/Daddy-Ousen/innworld-rpg/pull/85), e54e2c5; first cloud task). Last full suite: 132 scripts, all pass.
  - [x] M17.7 Enemy abilities and balance: cost by total level, hidden cap 100, `hp_scale` 2.0, `core/monster_abilities.gd`
    (`shooter`, `leap`), NPC Agility ([PR #86](https://github.com/Daddy-Ousen/innworld-rpg/pull/86), ff7d757).
  - [x] M17.8 Hidden XP: `Xp.duress_mult` (x0.5 – x2.0 on the worst HP drop in a fight), `core/xp_window.gd` (`xp_window` on a
    canon event; the Skinner night is x2); fighters level about 2x faster than the inn worker, curve not changed
    ([PR #87](https://github.com/Daddy-Ousen/innworld-rpg/pull/87), a7a5e37).
  - Tags pending (the cloud proxy refuses tag pushes, HTTP 403): `m17.6-done` on e54e2c5, `m17.7-done` on ff7d757,
    `m17.8-done` and `m17-done` on a7a5e37. Push them from a local session:
    `git tag m17.6-done e54e2c5; git tag m17.7-done ff7d757; git tag m17.8-done a7a5e37; git tag m17-done a7a5e37; git push origin --tags`.
  - Open after M17: the user plays fights with Skills, spells and cover. Optional M17.9 (duress for non-fighters, more XP windows).

## Cloud setup (archived 2026-10-01)
- [x] Private repo `Daddy-Ousen/innworld-canon-raw` (Book 6 and 7 text only), release `tools-godot-4.7.2`, SessionStart hook
  `tools/cloud/setup.sh`, `tools/run_tests.sh`, `docs/CLOUD.md` ([PR #84](https://github.com/Daddy-Ousen/innworld-rpg/pull/84), e82a9b1).
- [x] Real cloud VM: the hook works (Godot, Pillow, import). The hook cannot see the private repo when only `innworld-rpg` is
  attached. Fix (2026-10-01): attach `innworld-canon-raw` in the session (add_repo), clone it to `/home/user/innworld-canon-raw`,
  and link `canon/raw/book6` and `book7` to it. Tag pushes are refused (HTTP 403).

## Old handoff notes (moved 2026-10-01)
Session notes from M13 – M17.8, moved out of `handoff.md`. Headings are one level down.

### Just done (2026-09-30, M17.8 hidden XP, cloud session)
- M17.7 merged (PR #86). Branch `claude/kind-feynman-y4x1mm` restarted from main ff7d757; the M17.8 PR is open (the user merges it).
  Plan: `docs/plans/m17.8.md`. Detail: ADR 0027 "M17.8".
- User answers: curve 1 point = 0.01 (x0.5 at 0% lost, x1.0 at 10%, cap x2.0); duress and window multiply; window data on the canon event; no save
  version change ("I don't care about old saves"); other classes' duress later.
- Core: `Xp.duress_mult`, `Xp.boost_mult`, `Xp.compute(..., duress, window)`; `Actions.perform` opts `duress` / `window` (default `XpWindow.mult`), both in the
  record; `Combat.damage_player(from_foe)` writes `fight.peak` / `fight.low` (per mille, -1 = none), `Combat.fight_lost`, `end_fight` passes `duress` to every
  record; traps pass `false`; `core/xp_window.gd` + `CanonDb.windows` + `_validate_xp_window` + `XpWindow.validate`; `tools/validate_data.py` `check_xp_window`.
- Data: `rules.xp.duress` and `rules.xp.boosts`; `xp_window {boost 2, hours [18, 6]}` on `b1.skinner_leads_the_dead_into_liscor` (1.60) and `b1.rags_kills_skinner` (1.62).
  Toy dbs drop `rules.xp.duress` (`ToyData.with_duress` adds it back).
- Tests: new `unit_fight_duress` 10, `unit_xp_window` 12, `sim_balance_fighter` (probe); `unit_xp` 17; Python 97 OK; validator 0 errors. NO full suite (user rule).
- **Finding:** `sim_balance_fighter` (two Goblin fights a day) gives level 5 on night 6-7; the inn worker (`sim_balance_progress`) night 14. The curve was not changed:
  `base_xp` 52 (measured once, reverted) gives fighter night 7-9 and worker night 18, the same 2:1. The fix is XP sources for non-fighters, not the curve.
- **User rule (2026-09-30, in CLAUDE.md "Test scope"): run only the minimum tests that touch the change; NO full suite unless the user asks.**
- Open: every duress, boost and ability number is a guess; only the Skinner night has a window; clean wins pay half, which fights the cover rules of M17.6
  (the floor is data); the user has not played any M17.6-M17.8 fight (`godot --path game`; no display in the cloud).

### Next
1. The user merges the M17.8 PR; then tags `m17.6-done`, `m17.7-done`, `m17.8-done` and `m17-done` on the right merge commits (tag pending: the cloud may not push tags).
2. Optional M17.9 (plan first, ask first): duress for non-fight actions so cooks, runners and healers close the gap (crowd size in a meal, winter cold, a badly hurt
   patient, acting hungry), more windows for other big nights of Books 1-5 (two lines of data each). Or move on.
3. M18.P (Book 6 plan, ADR 0028; needs the book text: add repo `Daddy-Ousen/innworld-canon-raw` to the session), M18 batches, M19.P (Book 7, ADR 0029), M19 batches.

### Earlier (2026-09-30, M17.5 Mana and spells)
- Branch `feat/m17.5-spells` (from main 79490a6). Merged as PR #83 (68f5f38), tag `m17.5-done`. 5 commits: core MP (save v20),
  spell data and learning, casting and NPC casters, UI, docs. Plan: `C:/Users/rhasa/.claude/plans/encapsulated-orbiting-lollipop.md`.
  Detail: ADR 0027 "M17.5".
- User answers: max MP = Intellect + total level; teacher talk option + spellbook good; NPC casters now; line stops at
  walls, foes only.
- Core: `core/mana.gd` (`current/set_mp/spend/tick/refill`), `core/spells.gd` (learning, `cells`, `why_not`, `use`, NPC
  `npc_pick/npc_use`), `core/spell_db.gd` (`data/spells.json`), `Stats.max_mp`, `PlayerState.mp/mp_minutes`,
  `Progression.spells`, `Commands.cast/learn_spell/grant_spell`, `Movement._spend_seconds(gs, db, s)`,
  `CombatSkills.start_cooldown` (public now), cooldown key `spell:<id>`, fight record `cast_spell`.
- Data: 4 spells (ice_spike, flashfire, frozen_wind, fireball), `spellbook_fireball` good (no shop sells it: `give 0 spellbook_fireball`),
  [Mage] class + [Mana Sense] / [Steady Casting], action `study_spell` / `cast_spell`, tag `magic`, rules `tactical.mp`
  (`base 0, per_intellect 2, per_level 1`), base stat `intellect: 3`, Ceria and Pisces `combat.mp` / `combat.spells`.
- UI: spells in `ui/skill_bar.gd` (id `spell:<id>`, node name with `_`), MP label in `ui/combat_bar.gd`, HUD line, sheet "Spells:",
  `world/main.gd` (`pick_spell`, `cast_spell`, `_show_spell_plan`), `CombatOverlay.preview/burst`, teacher "Learn" rows in
  `ui/interact_menu.gd`, "Read" for spellbooks in the bag, console `spell <id>` / `cast <id> [x y]`.
- Tests: new `unit_mana` 17, `unit_spell_learning` 16, `unit_spells` 31, `unit_spell_ui` 13. Full suite (subagent): 128 scripts, 1339 tests, all pass (a single full run crashed once in unit_winter, a Godot crash; every script passes alone, so run the suite script by script). Validator 0 errors, Python 95 OK.
- Open lore flags: every spell number and teacher is a guess; check the Book for who could teach the player; a spellbook
  source (shop or loot) is missing; [Light] / [Flare] / [Water Spray] are Ryoka's and were left out.
- Next: the user plays a fight with a spell (`godot --path game`, then ` for the console: `spell ice_spike`, `spell fireball`,
  `give 0 spellbook_fireball`, `spawn goblin_grunt`, keys 1-9). Then M17.6 (cover and position, plan mode first).
- Gotchas: a multi-line Python patch must use the file's exact tab count (a wrong count fails the assert, nothing is written);
  the working copy has mixed line endings (`git ls-files --eol`), so patch with a helper that detects CRLF. New `class_name`
  scripts need one `--import`; it makes `.uid` files for new scripts (commit them). `-gselect=unit_combat` matches five
  scripts (substring) and Godot may hang at exit after them.
- Test runner: scratchpad `run_targets.sh [-t secs] <script>...` (gone next session).

### Earlier (2026-09-30, M17.4 Skills in combat)
- Merged as PR #82 (merge commit 79490a6), tag `m17.4-done` pushed. This note lives on branch
  `feat/m17.5-spells` (from main 79490a6; not pushed). Plan: `C:/Users/rhasa/.claude/plans/vast-foraging-rabbit.md`.
  Detail: ADR 0027 "M17.4".
- User answers: cooldown in rounds; the [Runner] CLASS gives the move cap (classes.json `combat.move_ap_mod_q`);
  kinds strike / area / self; NPC allies use Skills now (monsters in M17.7).
- Core: `core/combat_skills.gd`; `Commands.use_skill` (via `_encounter_act_q`, cost in q); `Combat.strike_at`,
  `throw_at(mods)`, `_strike(mods)`, `player_hit_chance(extra)`; `NpcReact._hit(mods)`; `Encounter` reads
  `CombatSkills.ap_bonus_q` / `move_cap_q`, ticks cooldowns at a round's start, NPC fighters try `npc_pick`
  first. Save v19 (`cool`, `move_bonus_q` in the encounter). DataDb checks `ap_mod`, `combat_action`, class
  `combat`; BehaviourDb checks NPC `combat.skills` (skill ids and canon event ids).
- Data: 9 new skills + [Power Strike] turned into an action; [Runner] `move_ap_mod_q: 4`; Erin / Relc / Toren
  `combat.skills` with `after_event` / `until_event`.
- UI: `ui/skill_bar.gd` (row in the combat bar, built in code), keys 1-9 in `world/main.gd` (`pick_skill`,
  `use_skill`, `disarm`, `armed_skill`), `CombatOverlay.marks` (gold frames), help line in `SystemMessages.KEYS`.
- Tests: full suite (subagent) 124 scripts, 1185 tests, all pass, no parse errors. Validator 0 errors, Python 95 OK.
- Open lore flag: [Tavern Brawling] is [Bar Fighting] in the Book (1.14); no "greater stamina" name found.
- Debug: console `skill <id>` (`Commands.grant_skill`, class "" level 0; the character sheet lists it without a
  class) and `useskill <id> [monster]`. Test in `unit_console`.
- Next: the user plays a fight with a Skill (`godot --path game`, then ` for the console, `skill power_strike`);
  then M17.5 (mana and spells, plan mode first) on `feat/m17.5-spells`. Line and blast shapes were
  left for M17.5 spells.
- Gotchas: a sure hit still rolls `randf` (keeps the random stream). The Bash safety check failed now and then
  this session; Edit / Grep still worked. `--import` segfaulted once but imported.
- Test runner: scratchpad `run_targets.sh [-t secs] <script>...` (gone next session).

### Earlier (2026-09-30, M17.3 combat screen)
- PR #80 merged (07f19a3); tag `m17.2-done` set and pushed. Branch `feat/m17.3-screen` from main, 3 commits
  (core, ui, docs). Merged as PR #81 (d470158), tag `m17.3-done` pushed. This note lives on branch
  `feat/m17.4-skills` (from main d470158; not pushed).
  Plan: `C:/Users/rhasa/.claude/plans/eventual-enchanting-teacup.md`. Detail: ADR 0027 "M17.3" section.
- User answers: the camera replays each fighter's turn; a click on a far foe walks up and hits; mouse in fights only.
- Core: `Movement.can_enter`, `Encounter.reach` / `plan_to` / `log_*` / `hp_of`, `Combat.player_hit_chance`,
  `CombatState.turns` (transient, NOT saved, no save version change), `Commands._encounter_act(prefix)`.
- UI: `ui/combat_bar.gd/.tscn` (in main.tscn HudLayer), `world/combat_overlay.gd` (node in world_view.tscn),
  `WorldView.replay / skip_replay / cell_at / refresh(replayed)`, `main.gd` (mouse, click walk, replay,
  `replay_turns` off headless, `end_turn`), help page lines in `SystemMessages.KEYS`.
- Tests: new `unit_combat_preview` (15), `unit_combat_screen` (11, real data on `ruins_entrance`). Full suite
  (subagent): 122 scripts, 1159 tests, all pass, no parse errors. Validator 0 errors, Python 95 OK.
- Screenshot for the user: `The Wandering Inn Books 1-17 Pirateaba/Temp/m17.3_fight.png` (gitignored).
- Next: the user plays a fight (`godot --path game`); M17.4 (Skills in combat, plan mode first) on `feat/m17.4-skills`.
- Gotchas: a replay only runs when a display exists; a main-scene test that wants it sets `main.replay_turns = true`.
  A non-headless Godot run rewrites every asset `.import`: `git ls-files -m game/assets | xargs -r git checkout --`.
  Main-scene tests leave GUT "orphans" (warnings only; old tests do the same).
- Test runner: scratchpad `run_targets.sh [-t secs] <script>...` (gone next session).

### Earlier (2026-09-30, M17.2 port the old fight parts)
- Tags `m17.0-done` (a24db19) and `m17.1-done` (a175d2a) set and pushed. Branch `feat/m17.2-port` pushed as
  PR #80 (https://github.com/Daddy-Ousen/innworld-rpg/pull/80). After the merge: tag `m17.2-done` on the merge commit. Plan: `C:/Users/rhasa/.claude/plans/agile-shimmying-duckling.md`.
- User answers: auto end turn when AP pays for nothing; one NPC Agility default (3) until M17.7; no new UI.
- Combat mode is ON in `rules.json`. Detail: ADR 0027 "M17.2" section.
- Core: `encounter.gd` (NPC fighters `"npc:<id>"`, `_npc_turn`, brawl starts an encounter, `_over`,
  `maybe_end_turn`, guard drops at the player's turn, optional `monster.ap_q`), `commands.gd`
  (`_encounter_act` / `_encounter_do`: AP for block, throw, take, drop, bag, attack_npc, fairy swat; wait -1
  when knocked out), `movement.gd` (`spend_turn` no-op in a fight), `combat.gd` (guard kept in a fight,
  `player_attack` without `spend`), `npc_sim.gd` (NPC fighters skip world-time acts).
- Tests: new `test_support/fight_bot.gd` (`FightBot.act/move/attack/throw/block/attack_npc/wait_seconds`);
  `ToyData` turns combat mode off for toy dbs; `ToyCombat.freeze` sets `monster.ap_q` 0; `ToyMaps.walk_to`
  uses FightBot. 20 real-data sims use FightBot for fight commands. `unit_encounter` 25, `unit_winter` +1.
- Balance seen (for M17.7): level 5 vs 2-3 Goblins now wins 1-2 of 3 seeds; `sim_balance_fights` asserts
  single foes only.
- Full suite (subagent): 120 scripts, 1133 tests, all pass, no parse errors. Validator 0 errors, Python 95 OK.
- Next: the user merges PR #80, then M17.3 (combat screen,
  plan mode first). The user should try a fight in the game: Space ends the turn.
- Test runner: scratchpad `run_targets.sh [-t secs] <script>...` (gone next session): one script per Godot
  run with a time limit, one summary line each. Much safer than the full suite when a sim may hang.

### Earlier (2026-09-30, M17.1 core encounter)
- Merged to main as PR #79 (a175d2a), with the M16 archive and M17.0. Tagged in M17.2.
- ADR 0027 approved by the user; M17.1 notes at its end. Save v18.
- New `game/core/encounter.gd`; changed `combat.gd` (`player_attack(spend)`, encounter cleared in `end_fight`,
  `night`, area change), `combat_state.gd` (`encounter`), `monster_sim.gd` (`_hostile_checks`,
  `_nearest_hostile`, carry dropped in combat mode), `movement.gd` (`step(spend)`), `commands.gd`
  (`_encounter_move`, `_encounter_attack`, `end_turn`, wait = end turn, `_after` ends with `Encounter.sync`),
  `save_migrations.gd` 17→18, `combat_db.gd` (`agility`), console `end`.
- Combat mode is OFF in `rules.json` (`combat.tactical.enabled: false`). `ToyCombat.tactical(d)` turns it on.
- Tests: `unit_encounter` 21/21, `unit_tactical_rules` 6/6, unit_combat/monster_sim/stage/combat_db/traps/brawl pass.
- Next: M17.2 (plan mode first): block/throw/take/drop on AP, brawl and react NPCs and stage allies in the
  order, flee, knock-out, fight records; port the 44 fight test files; set `enabled: true`; full suite.
- Test runner: scratchpad `run_targets.sh <script>...` (gone next session).

### Earlier (2026-09-30, M17.0 spike)
- Branch `feat/m17.0-spike` (stacked on `docs/archive-m16`, neither pushed). Ask the user before push / PR.
- User answers: Agility = `speed` stat; keep AP rules, raise HP ~x2 in M17.7; MP 1 per 10 min, sleep refills;
  a fight covers the whole map, late arrivals join next round. All in `docs/adr/0027-m17-tactical-combat.md`.
- `game/data/rules.json` `combat.tactical` (nothing reads it yet). Test `game/tests/unit_tactical_rules.gd`.
- Paper fights: scratchpad `paper_fights.py` (gone next session). Results table in ADR 0027.
- Tests run: unit_tactical_rules 5/5, unit_combat_db 14/14, unit_stats 6/6, validator 0 errors, Python 95 OK.
- Next: user approves ADR 0027, then M17.1 (plan in ADR 0027 "M17.1 plan"; save v18; full suite in a subagent).
- JSON numbers load as floats in GDScript: compare arrays after `map(int)`.

### Earlier (2026-09-29, M16 merged and archived)
- M16 (M16.0-M16.6) merged as PR #78 (main 98a3b08). M16 archived in `docs/PROGRESS_ARCHIVE.md`; `progress.md` marks M16 done.
  Branch `docs/archive-m16` holds this docs step (not pushed; ask before push / PR).
- Still waiting on the user: walk the changed maps in the game (`godot --path game`).
- Next: M17 (tactical combat). M17.0 = spike + ADR, plan mode first. Rules in `docs/ROADMAP.md` "M17" and ADR 0022.
  M17.1 changes the save format (v17 -> v18, migration in `core/save_migrations.gd`), so it needs the full suite in a subagent.
- Map / art gotchas kept from M16:
  - Keep props out of a stage map's fight lanes (ADR 0026 lesson: `sim_esthelm_siege`).
  - Map JSON is tab-indented CRLF, one object per line; `json.dumps` does not round-trip it, edit by lines.
  - A door plaque needs a `sign`; every enterable house door needs a sign (`unit_sign_art` lists the maps it checks).
  - `ToyMaps.walk_to_area` is ONE hop. A wide exit shifts `arrive` per cell: `arrive` must be free floor for every cell.
  - New map: a mood in `audio.json`; sim tests that wait in a room park the player away from doorways.
  - After `--import`, do NOT `git checkout` every modified asset blindly (it reverts a rebuilt `edits.png`).
  - Screenshot scene recipe: SubViewport + `WorldView` (see "Screenshot recipe" below); `game/_scratch` is deleted before commit.
  - Art tools: `tools/build_cliffs.py`, `build_houses.py`, `build_signs.py`, `build_windows.py`, `build_objects.py`.

### Earlier (2026-09-29)
- The user played M14 and sent 8 problems (screenshots in `The Wandering Inn Books 1-17 Pirateaba/Temp/`, not in git).
- Plan written: M15 (readability, lore), M16 (maps, art, cities), M17 (XCOM-style combat) in `docs/ROADMAP.md`;
  decisions and the user's AP rules in `docs/adr/0022-m15-m17-play-report.md`; DESIGN §1 updated.
  Branch `docs/m15-m17-plan` (from main d75adfa). Docs only, no code.
- Earlier: M14 merged (PR #75, tags `m14-done`), archived (PR #76). Rock Crab and day-21 raid stay as they are.

### Next steps
1. Answered 2026-09-29: order M15 → M16 → M17 OK; extra AP uses the TOTAL level (secret: never shown, AP gains
   silent; M15.3 removes "Total level" from the character sheet); level cost by total level + hidden cap 100
   goes in M17.7. All in ADR 0022.
2. M15.0 done on branch `feat/m15.0-font` (stacked on `docs/m15-m17-plan`): Pixel Operator, Large text box in
   Options (`ui/text_settings.gd`, `Session.set_large_text`). Not pushed yet; ask the user before push / PR.
   Screenshot helper: `game/_scratch/shot.gd` (deleted before commit) + `--write-movie`; window size is ignored.
   Test runner: `scratchpad/run_targets.sh <script>...` (gone next session).
3. M15.1: done (see above).
4. M15.2: `ui/hud.tscn` (Bottom panel, Log label, Hint label), `ui/hud.gd` (`LOG_LINES` = 6).
5. M15.3: `world/main.gd:308` (XP line), `ui/character_sheet.gd:56-59`, `ui/system_messages.gd:41-42`,
   `ui/journal.gd:134`. Keep `ui/console_commands.gd` numbers.

### Probe notes (M14.8)
- A test that skips days with `ToyCanon.sleep_through` piles up hunger (max HP x0.5): set `gs.economy.hunger = 0`.
- `unit_bag` and `unit_brawl` leave state in `Session.gs`; a test that reads `Session.gs` should set its own game.
- The wave rule (`Stage.tick`): a wave waits while `here >= max_on_map` (12) and, if `here > 0`, until
  `after_seconds` has passed or `here <= left_at_most`. One player turn = 6 s.

### M14.7 notes
- Journal news stays text only (one Label). A face per news line would need a rebuilt journal.
- `Import` may rewrite `game/assets/fonts/*.import` line endings: `git checkout` them before committing.
- A menu test can feed `InteractMenu.open` hand-made option dicts (needs `id`, `name`, `npc`, `actions`, `sleep`,
  `item`, `price`, `trades`, `ride`); `Session.gs` may be null.

### M14.6 notes
- Theme covers Button, ItemList, PanelContainer, LineEdit, HSlider, Label, CheckBox, RichTextLabel. The System dialog
  keeps its own blue panel and `[Title]` headings stay blue on purpose (System voice).
- Font `.import` is edited by hand: antialiasing=0, hinting=0, subpixel_positioning=0. A reimport keeps it.
- Font (M15.0) is Pixel Operator on a 16 px grid: use 16 or 32 only (`unit_ui_theme` checks the scenes).

### M14.5 notes
- Major NPC = a pending, non-mutate-target canon event names them in a role `prefer` or `requires.alive`
  (`Brawl.is_major`). Warned ids live in `gs.flags["fate_warned.<id>"]`.
- Hostile lasts until the day number changes (`hostile_day == clock.day()`), not until sleep. A long gap heals
  the NPC's hp (old `NpcSim` rule) but not the hostility.
- A test that kills an NPC through `Commands.attack_npc` must keep the player up (`Combat.set_hp(gs, db, 9999)`
  each turn): the hostile NPC hits back after every command.
- `Combat.in_danger` is now also true for a hostile NPC: NPCs near it stand still (NpcReact) and patrons leave.
- `Import` of the project segfaults sometimes (known); GUT runs fine after it anyway.

### M14.4 notes
- Who gets a schedule: canon NPCs with a place on one of our maps. Left out (no map): terbore, tekshia, peslas,
  timbor_parithad, ulia_ovena, theofore, termin, ressa, magnolia_reinhart, esthelm_florist. `princess_thief` is the
  Book 1 placeholder for Lyonette: not linked (confirmed-links-only rule).
- Grev is a `teen` body: the sprite tool cannot read LPC child hair (single `child/<colour>.png`, no walk/ folder).
- The LPC clone is in this session's scratchpad (`.../4654847b-.../scratchpad/ulpc`; gone next session).
- The test-run helper `scratchpad/run_targets.sh` (gone next session) ran one GUT script per Godot call and grepped
  the summary. Monitor with an `until grep -q DONE` loop.

### M14.3 notes
- Town = nearest `settlement` above a map's location (`Standing.town_of`): liscor, celum, esthelm. The inn area
  has no town. Faction = the NPC's canon `faction`.
- A relationship fades only with the player ("player" key) and only after 7 days with no contact
  (`WorldState.contact`). No contact record: the clock starts that night.
- Shop prices use the town of the PLAYER's area, so a price read with the player elsewhere shows no shift.
- Friends (regard >= 10) fight like `rules.npc.react.ally`. A test that talks to one NPC on 10 days will now see
  them fight in a monster fight.
- `Standing.add_reputation(gs, db, key, delta)` is the one writer; M14.5 uses it for witnesses.

### M14.2 notes
- Patron rolls use `Rng.new(seed ^ meal_key * 2654435761)`, not `gs.rng`: the main stream stays the same.
- Patrons roll only at the first command in a meal while the player is in `inn_interior`. Tests that stand in the
  inn at 7-10, 12-14 or 18-22 now get patrons; a patron on a seat blocks the player (not NPCs or monsters).
- Cooking takes 45-120 min; cooking during a meal makes patrons give up (-2 each while the player is in the room).
- `sim_inn_service` cooks between meals for that reason.

### Waiting on the user
- Look at M14.6 and M14.7 in the game (`godot --path game`) and say if colours, sizes or the face crop need changes.
- Delete old remote branches `data/book4-*` (optional).

### Book 5 canon notes (M13.7)
- A fight stage with helpers who come at once lets them box the foe in on all four sides; the player never gets a
  hit and the hook never fires. Delay the helper wave (M13.7 uses 30 s). Klbkch joins inn fights 18-21.
- Ryoka dies and is revived in two same-night events (`kill`, then `revive`); nothing between them in id order may
  need her alive.
- 4.31 clears `izril.winter` on day 114: winter rules and snow end there.
- The LPC clone for M13.7 is in this session's scratchpad (`.../47ef78fc-.../scratchpad/ulpc`, only Regrika's parts;
  gone next session).
- The auto-mode safety check failed for a long stretch this session (Bash, PowerShell and Agent all blocked). Read,
  Grep, Write and Edit still worked, so chapter reading and data prep went on by hand.

### Book 5 canon notes (M13.6)
- Test trap: a test that waits on `inn_hill` on the morning of day 110 is attacked by the Razorbeak stage and
  knocked out; `Commands.wait` then returns -1 forever. An unbounded `while _hour(gs) < N` loop spews 800k lines.
  Wait indoors and bound every wait loop (`sim_book5_creler_nest._wait_indoors_until`).
- "Regrika" at Liscor is Venitra (4.27 H): no NPC for Regrika; never place Venitra in a scene before 4.27 H (the name
  would spoil it). Imenet is its own NPC (not linked to Ijvani).
- The LPC clone for M13.6 is in this session's scratchpad (`.../854c7124-.../scratchpad/ulpc`; gone next session).
- The Bash tool's safety check sometimes stalls on long Godot runs in subagents; PowerShell works.

### Active files
- M13.7: `game/data/canon/book5/chapters/4.28.json` ... `4.31.json`, `4.24.json`, `4.27H.json`, `book5/npcs.json`,
  `book3/npcs.json` (Ijvani), `game/data/enemies.json`, `appearance.json`, `audio.json`, `npc_behaviour.json`,
  `game/assets/characters/regrika_blackpaw.png`, `game/tests/sim_book5_last_light.gd`, `sim_canon_book5.gd`,
  `docs/adr/0020-m13-book5.md`.
- M13.6: `game/data/canon/book5/chapters/4.24.json` ... `4.27H.json`, `game/data/maps/esthelm_creler_cave.json`,
  `game/data/maps/esthelm_ruins.json`, `game/data/enemies.json`, `game/data/appearance.json`, `game/data/audio.json`,
  `game/data/rules.json`, `game/data/npc_behaviour.json`, `game/tests/sim_book5_creler_nest.gd`,
  `game/tests/sim_canon_book5.gd`, `docs/adr/0020-m13-book5.md`.
- M13.5: `game/data/canon/book5/chapters/4.18.json` ... `4.23E.json`, `game/data/canon/book5/npcs.json`,
  `locations.json`, `game/data/npc_behaviour.json`, `game/data/appearance.json`, `game/tests/sim_book5_rift_undead.gd`,
  `game/tests/sim_canon_book5.gd`, `docs/adr/0020-m13-book5.md`.
- M13.4: `game/data/canon/book5/chapters/1.02D.json` ... `1.06D.json`, `game/data/canon/book5/npcs.json`,
  `game/tests/sim_book5_geneva.gd`, `game/tests/sim_canon_book5.gd`, `docs/adr/0020-m13-book5.md`.
- M13.3: `game/data/canon/book5/chapters/4.13L.json` ... `4.17.json`, `game/data/canon/book5/npcs.json`,
  `locations.json`, `game/data/npc_behaviour.json`, `game/data/appearance.json`, `game/tests/sim_book5_pawns_faith.gd`,
  `game/tests/sim_canon_book5.gd`, `docs/adr/0020-m13-book5.md`.
- M13.0: `game/core/map_db.gd`, `game/data/maps/liscor_depths.json`, `game/data/maps/liscor_crypt.json`,
  `game/data/maps/inn_upper_floor.json`, `game/data/maps/inn_watchtower.json`, `game/data/enemies.json`,
  `game/tests/unit_gated_exits.gd`, `game/tests/sim_liscor_depths.gd`, `game/tests/sim_inn_third_floor.gd`, `docs/adr/0020-m13-book5.md`.

### Book 5 canon notes (M13.1)
- Event ids carry a letter after `b5.` (`b5.a_...`) so same-day siblings sort in story order.
- Scene NPC talks: `ToyMaps.walk_next_to` works on objects only. For an NPC, walk to its four side squares with
  `ToyMaps.walk_to(gs, db, sides)` (`sim_book5_soups._do_with`).
- Canon notes and summaries are capped at 300 characters by the validator; put long reasoning in the ADR.
- Every chapter file needs `"system": []` even with no level-ups.
- Every NPC in `npc_behaviour.json` needs its OWN look in `appearance.json` (`unit_art`), so placing a new NPC in a
  scene means a new sheet: `python tools/build_sprites.py --ulpc <clone> --only <id>`, then `--import` and
  `git checkout -- game/assets/characters` (import noise; the new png/import are untracked so they stay).
- Chapter data for M13.2 came from a generator script (scratchpad, gone next session). New NPCs appended to
  `book5/npcs.json` by `json.dumps(indent="	")` keep the file format.

### Book 5 canon notes (M13.3)
- 4.12's `ryoka.plans_to_visit_garias_farm` is set by an event that needs Pawn AND Bird alive; do not require it.
  The farm trip requires `ryoka.home_at_the_wandering_inn` instead.
- `--import` also rewrites every audio/character `.import` with LF: `git checkout -- game/assets/audio game/assets/objects game/assets/tiles`
  and `git ls-files -m game/assets/characters | xargs -r git checkout --` (keeps new untracked sheets).
- The LPC clone for M13.3 is in this session's scratchpad (`.../5c0f7f5b-.../scratchpad/ulpc`; gone next session).

### Book 5 canon notes (M13.4)
- Off-map arcs on days before Book 5's FIRST_DAY (97) still count in `sim_canon_book5` (it sleeps to 96 in
  before_all and checks every b5 event up to LAST_DAY). Kill tests for them need their own file that starts earlier
  (`sim_book5_geneva` sleeps to day 76).
- A chapter generator script was in the scratchpad (gone next session).

### Book 5 canon notes (M13.5)
- The LPC clone for M13.5 is in this session's scratchpad (`.../c8921a2b-.../scratchpad/ulpc`; gone next session).
- The chapter generator was `scratchpad/gen_m135.py` (gone next session). DataDb checks that stage foe tiles are
  walkable; the Python validator does not, so run the new sim test once before the full suite.
- `sim_book5_geneva.gd.uid` was missing from the M13.4 commit; added in M13.5.
- Laken's events need only Laken alive and chain on flags. The Laken kill test is in `sim_canon_book5`.
- Never pass text with backticks through an unquoted bash heredoc (`<<EOF`): bash runs them as commands. Write
  Python patch scripts to the scratchpad with the Write tool.

## Moved from progress.md and handoff.md (M21.2, 2026-10-09)

### M18 Book 6 detail
- [ ] M18 — Book 6 (The General of Izril). Plan: ADR 0028, steps M18.0 – M18.7 in `docs/ROADMAP.md`. Text in the private repo.
  - [x] M18.P plan (branch `claude/kind-feynman-y4x1mm`, 2026-10-01, cloud): six reading agents (summaries only), ADR 0028, roadmap steps.
    User answers: chapter `order` number (M18.0 engine step), maps Wirclaw's village + crypt ossuary + inn basement, Esthelm attack as a
    night wave stage. Laken's calendar (changed the same day): game day = his journal day + 45 in every book, no squeeze; tying his
    first snow to Liscor's winter (day 42) breaks Book 4 and Zel's death (ADR 0028 "Laken's calendar"). Book 6 Liscor days move to
    115 – 130 (Zel dies on 130). PR waits for the user to merge (merging = plan approved).
  - [x] M18.0 canon timing (branch `claude/kind-feynman-y4x1mm`, 2026-10-01, cloud): optional chapter key `order` in
    `CanonDb` and the validator (same day: book, chapter order, place in the file; Books 1 – 5 order unchanged); Laken's
    Book 3 events on days 46 – 91 and Book 5 events on days 100 – 115 (his Day + 45). Tests run: `unit_event_order` (new),
    `unit_canon_db`, `sim_canon_book2` – `sim_canon_book5`, `sim_book4_christmas`, `sim_book4_homecoming`,
    `sim_book4_relief_home`, Python tool tests (100), validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M18.0 merged ([PR #89](https://github.com/Daddy-Ousen/innworld-rpg/pull/89), merge commit 5d0930e).
  - [x] M18.1 world (branch `claude/nice-albattani-wj8hw6`, 2026-10-01, cloud): maps `wirclaw_village`, `inn_basement`
    (trapdoor opens with `wandering_inn.expansion_begun`), `liscor_ruins_hall` and `liscor_ruins_ossuary` (the text puts
    the ossuary in the Ruins of Liscor: illusion wall until `liscor_ruins.hidden_chute_found`, one-way chute, corridor
    with a trap to `liscor_crypt`); the Eater Goat (`leap`, drawn art); 10 looks; 38 Book 6 NPC records, no events.
    Tests run: `sim_book6_world` (new) and 18 scripts the change touches, Python tool tests (102), validator. All pass.
    Full suite not run. [PR #90](https://github.com/Daddy-Ousen/innworld-rpg/pull/90) waits for the user to merge.
  - [x] M18.1 merged ([PR #90](https://github.com/Daddy-Ousen/innworld-rpg/pull/90), merge commit 440a0dd).
  - [x] M18.2 canon 4.32 G, 1.02 C – 1.05 C (branch `claude/sleepy-feynman-txet0j`, 2026-10-01, cloud): 17 events (days 114 – 121),
    the march as a scene stage with a talk hook, Rags's raid as news, Tom's Paranfer weeks off-map, `paranfer` location.
    Tests run: `sim_canon_book6` (new), `sim_book6_goblin_march` (new), `sim_book6_world`, `unit_canon_db`,
    `unit_event_order`, `sim_canon_book5`, Python tool tests (102), validator. All pass. Full suite not run. PR waits for the user.
  - [x] M18.2 merged ([PR #91](https://github.com/Daddy-Ousen/innworld-rpg/pull/91), merge commit f5cc08b).
  - [x] M18.3 canon 4.33 – 4.34 (branch `claude/sleepy-feynman-txet0j`, 2026-10-01, cloud): 14 events (day 115; the goats' night is 114).
    The Eater Goat attack is a fight stage with waves at `wirclaw_village`; the feast is a scene stage in the inn; both have hooks.
    Bugear dies by event effect. New behaviour entries for Wirclaw and the five Redfang (basement from day 116). Bugear's tag is
    sword. Tests run: `sim_book6_eater_goats` (new, 7), `sim_canon_book6`, `sim_book6_goblin_march`, `sim_book6_world`,
    `unit_canon_db`, `unit_event_order`, `sim_canon_book3`, `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`, Python tool
    tests (102), validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M18.3 merged ([PR #92](https://github.com/Daddy-Ousen/innworld-rpg/pull/92), merge commit 6120ef3).
  - [x] M18.4 canon 4.35 E – 4.38 B (branch `claude/sleepy-feynman-txet0j`, 2026-10-01, cloud): 28 events (days 117 – 127), Laken off-map,
    Olesm's day 126 with the crypt search as a scene stage and hook, Esthelm as news only, Zel leaves through the door, Magnolia.
    Tests run: `sim_canon_book6`, `sim_book6_crypt_search` (new), `sim_canon_book5` (fixed a stale M18.3 assert), the touched Book 6 sims,
    Zel and behaviour scripts, Python tool tests (102), validator. All pass. Full suite not run. PR waits for the user.
  - [x] M18.5 canon 4.39 G – 4.42 L (branch `claude/sleepy-feynman-txet0j`, 2026-10-01, cloud): 20 events (days 126 – 129). The party is a scene stage
    in the inn with a talk hook; the Rose Knights fights and the Hive front are events only. Greydath is a flag on `greybeard`; Purple Smile
    is [Sergeant] by flag on day 129. Tests run: `sim_book6_goblin_party` (new, 4), `sim_canon_book6`, the touched Book 6 sims, `sim_canon_book5`,
    `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`, Python tool tests (102), validator. All pass.
    Full suite not run. PR waits for the user to merge.
  - [x] M18.5 merged ([PR #94](https://github.com/Daddy-Ousen/innworld-rpg/pull/94), merge commit c1f3904).
  - [x] M18.6 canon 4.43 – 4.47 (branch `claude/sleepy-feynman-txet0j`, 2026-10-01, cloud): 23 events (days 128 – 129). The Silver Swords arrive at
    the inn as a scene stage with a talk hook; Zel's speech is T1 news with an Ilvriss hook on the council; Erin is level 33. 4.44 M is day 128.
    Tests run: `sim_book6_silver_swords` (new, 6), `sim_canon_book6`, the touched Book 6 sims, `sim_canon_book5`, `unit_canon_db`, `unit_event_order`,
    `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`, Python tool tests (102), validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M18.6 merged ([PR #95](https://github.com/Daddy-Ousen/innworld-rpg/pull/95), merge commit 639fd45).
  - [x] M18.7 canon Antinium Wars Pt. 3 – 5, 4.48, 4.49 (branch `claude/sleepy-feynman-txet0j`, 2026-10-01, cloud): 31 events (days 129 – 130).
    Zel dies on day 130 and names the Goblin Lord Reiss (`goblin_lord.named_reiss`). The mourning is a scene stage in the inn with a talk hook
    with Erin. Chosen records and the 4.31 scroll flag fixed. Tests run: `sim_book6_zel_dies` (new, 7), `sim_canon_book6`, `sim_canon_book5`, the
    touched Book 6 sims, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`, Python tool tests (102),
    validator. All pass. Full suite not run. PR waits for the user to merge. After the merge M18 is done except the user's play check.
  - [x] M18.7 merged ([PR #96](https://github.com/Daddy-Ousen/innworld-rpg/pull/96), merge commit 6a9e8b8).
  - [ ] The user plays Book 6 (`godot --path game`).

### M19 Book 7 detail
- [ ] M19 — Book 7 (The Rains of Liscor). Plan: ADR 0030, steps M19.0 – M19.8 in `docs/ROADMAP.md`.
  - [x] M19.P plan (branch `docs/m19-plan`, 2026-10-07, local): Book 7 cut from the epub to `canon/raw/book7/` (gitignored);
    seven reading agents (summaries only); ADR 0030, roadmap steps, `docs/CLOUD.md` queue. User answers: rain + flood (door is
    the way to Liscor), door with several links + small Pallass map (portal schema change approved), moth attack = wave stage
    with `xp_window` x3, dungeon dive = events only. Days 133 – about 143. No code, no tests run. PR waits for the user to merge.

  - [x] M19.0 engine (branch `feat/m19.0-door-links-rains`, 2026-10-07, local): door `links` (pick the stone; flags, hours, power per
    link; one shared trip count), `rules.rains` (season and flood flags), rain on screen and in the sound (`amb_rain.ogg` made by
    `tools/build_rain.py`). User answers: no rain duress; rain sound by tool. No save change. Detail: ADR 0030 "M19.0 as built".
    Tests run: `unit_portal_links` (new), `unit_rains` (new), 16 touched scripts, Python tool tests (105), validator. All pass.
    Full suite not run. PR waits for the user to merge.
  - [x] M19.0 merged ([PR #112](https://github.com/Daddy-Ousen/innworld-rpg/pull/112), merge commit fef7f44).
  - [x] M19.1 world (branch `feat/m19.1-world`, 2026-10-07, local): door with 3 links (Celum, Pallass `pallass_door_street`, Liscor west wall on
    `liscor_watch`), flood overlays (flag `izril.flood`) on 4 maps and 3 gated exits, Grand Theatre and smashed-tower flags, moth enemies + sheets,
    Book 7 records (33 NPCs, 14 places, no events). Detail: ADR 0030 "M19.1 as built". Tests run: `sim_book7_world` (new, 11), `unit_portal_links`,
    `unit_map_db`, `unit_combat_db`, `unit_monster_art`, `unit_sound_cues`, `unit_gated_exits`, `unit_world_view`, `unit_canon_db`, `unit_liscor_map`,
    `unit_audio_data`, `unit_ambience`, `sim_winter` (narrowed to the snow-wall overlay), `sim_book4_homecoming`, `sim_book6_world`, Python tool tests (105),
    validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.1 merged ([PR #113](https://github.com/Daddy-Ousen/innworld-rpg/pull/113), merge commit 00767ce).
  - [x] M19.2 canon 5.00 – 5.03 (branch `feat/m19.2-canon-5-00`, 2026-10-07, local): 23 events (days 133 – 135). Stages: the lunch (day 133) and the Venim
    deal (day 134, sets `izril.rains`), both scenes in the inn with a talk hook. No Pallass walk, no Riefel death. Venim has a behaviour entry.
    Tests run: `sim_book7_pallass_crisis` (new, 6), `sim_book7_world`, `sim_canon_book6`, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`,
    `unit_npc_sim`, Python tool tests (105), validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.2 merged ([PR #114](https://github.com/Daddy-Ousen/innworld-rpg/pull/114), merge commit f9552eb).
  - [x] M19.3 canon 5.04 – 5.06 M (branch `feat/m19.3-canon-5-04`, 2026-10-07, local): 19 events (days 135 – 136). One scene stage: the Players' play night
    (day 135) with a Wesle hook. No dinner stage, no xp_window. Erin level 34 by `system` record. Records fixed: Toren, Wesle, Halrac, Mrsha.
    Tests run: `sim_book7_players_and_toren` (new, 5), `sim_book7_pallass_crisis`, `sim_book7_world`, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`,
    `unit_npc_sim`, `sim_canon_book2`, `sim_canon_book3`, `sim_canon_book6`, Python tool tests (105), validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.4 canon 5.07, 5.08, Interlude - Flos (branch `feat/m19.4-canon-5-07`, 2026-10-07, local): 28 events (days 137 - 138). The moths are a 6-wave fight stage on
    `inn_hill` with `xp_window` x3 and a fight hook; a scene in the inn that night with a talk hook. Pallass lifts the embargo and the Pallass door link opens. Flos notes are tier 1.
    Tests run: `sim_book7_moths` (new, 6), `sim_winter`, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`, `unit_npc_sim`, `unit_xp_window`, `unit_map_db`, `sim_book7_world`,
    `sim_book7_pallass_crisis`, `sim_book7_players_and_toren`, `sim_canon_book6`, Python tool tests (105), validator. All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.5 canon 5.09 E - 5.11 E (branch `feat/m19.5-canon-5-09`, 2026-10-08, local): 26 events (days 130 - 142, Laken's Day + 45). New map `riverfarm`; the banquet (day 142) is a scene stage with two hooks (Ivolethe, the poisoned cup). No road: the first `celum_gate` link was removed (Riverfarm is SW of Invrisil); no exits until an Invrisil map exists. Detail: ADR 0030 "M19.5 as built".
    Tests run: `sim_book7_riverfarm` (new, 7), `unit_map_db`, `unit_behaviour_db`, `unit_npc_sim`, `unit_canon_db`, `unit_event_order`, `unit_gated_exits`, `unit_audio_data`, `unit_ambience`, `unit_world_view`, `unit_ground_art`, `sim_book7_world`, `sim_book7_moths`, `sim_book7_pallass_crisis`, `sim_book7_players_and_toren`, `sim_canon_book6`, `sim_winter`, `unit_liscor_map`, Python tool tests, validator. All pass (Python tool tests 105, validator 0 errors; first run of `unit_ground_art` failed on a tree hiding a wall, fixed). Full suite not run. PR waits for the user to merge.
  - [x] M19.6 canon 5.12 – 5.15 (branch `feat/m19.6-canon-5-12`, 2026-10-08, local): 44 events (days 137 – 140). The flood starts (`izril.flood`, set on day 137 so it shows on 138);
    the door gets its Liscor west-wall end on day 138 (Pallass and Celum ends stay). Three scene stages in the inn, each with one talk hook, no `xp_window`: the Soldiers' dinner
    (day 138, Klbkch), the victory party (day 139, Relc), the Vuliel Drae confession (day 140, Revi). Parade, play, Embria's fight, Tyrion and the whole dungeon dive are events.
    Olesm is [Strategist] 30 and Erin level 35 by `system` records. 8 NPCs got behaviour entries. Tests run: `sim_book7_flood_and_parade` (new, 6), `sim_book7_world`, `sim_book7_moths`,
    `sim_book7_pallass_crisis`, `sim_book7_players_and_toren`, `sim_winter`, `sim_canon_book6`, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`,
    `unit_data_db`, Python tool tests (105), validator (0 errors). All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.7 canon 5.16 S – 5.18 S (branch `feat/m19.7-canon-5-16`, 2026-10-08, local): 33 events (days 140 – 143). Two scene stages with one talk hook each, no `xp_window`: Zel's funeral in `liscor_plaza` (day 142, hook Zevara) and the lease haggle in the inn (day 143, hook Selys). Selys is [Heiress] 4 then 6, [Receptionist] 19. New places `liscor_city_hall`, `liscor_sewers`, `pallass_archive`; Seborn has a behaviour entry. Detail: ADR 0030 "M19.7 as built".
    Tests run: `sim_book7_zel_and_selys` (new, 4), `sim_book7_flood_and_parade`, `sim_book7_world`, `sim_book7_moths`, `sim_book7_riverfarm`, `sim_book7_pallass_crisis`, `sim_book7_players_and_toren`, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`, `unit_data_db`, `sim_winter`, `sim_canon_book6`, Python tool tests (105), validator (0 errors). All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.8 canon 5.19 G, 5.20 G (branch `feat/m19.8-canon-5-19`, 2026-10-08, local): 21 events (days 141 – 143), all off-map; no stage, no hook, no `xp_window`. Rags gets `system` records ([Chieftain] 20 on day 143). New places `northern_swamp`, `northern_high_road`. Detail: ADR 0030 "M19.8 as built".
    Tests run: `sim_book7_goblin_road` (new, 4), `sim_book7_zel_and_selys`, `sim_book7_flood_and_parade`, `sim_book7_world`, `sim_canon_book6`, `unit_canon_db`, `unit_event_order`, `unit_behaviour_db`, `unit_npc_sim`, `unit_map_db`, `sim_winter`, Python tool tests (105), validator (0 errors). All pass. Full suite not run. PR waits for the user to merge.
  - [x] M19.9 `sim_canon_book7` (branch `feat/m19.9-sim-canon-book7`, 2026-10-08, local): days 130 – 143, 191 events, drift 0, no named deaths, 11 stages, one `xp_window`. Test run: `sim_canon_book7` (new, 5). All pass. Full suite not run. After the merge M19 is done except the user's play check.
  - [ ] The user looks at the rain (`flag izril.rains` in the console, then walk outside) and hears it.


### Releases v0.1.0 – v0.1.2, README rewrite, web build
- [x] v0.1.2-alpha (branch `release/v0.1.2`, 2026-10-06, local): version bump, README and ITCH.md text (touch is no longer "next release"). Three zips built and
  smoke-tested (898 events, 38 maps, 0 problems). Tests run: smoke only. Full suite not run. PR waits for the user to merge.
  - [x] Merged ([PR #108](https://github.com/Daddy-Ousen/innworld-rpg/pull/108), merge commit e9ad2e2). Tag `v0.1.2-alpha` pushed. Pre-release published 2026-10-06 with three zips: https://github.com/Daddy-Ousen/innworld-rpg/releases/tag/v0.1.2-alpha. Pages deploy run succeeded.
  - [x] The user uploaded the v0.1.2 web zip to itch.io (said 2026-10-07).
- [x] v0.1.0-alpha (branch `release/v0.1.0`, 2026-10-01, local): `game/export_presets.cfg` (Windows, Linux; `*.json` packed; tests and GUT
  left out), `config/version` and a version label on the title screen, `tools/release.ps1` + `tools/release/smoke.gd` + player
  `README-PLAYERS.txt`. Built and smoke-tested both zips (898 events, 38 maps, 0 problems; 5 nights run from the pack). The Windows
  exe opens and closes clean. Tests run: `unit_play_loop` (16 pass). Full suite not run.
  - [x] Merged ([PR #97](https://github.com/Daddy-Ousen/innworld-rpg/pull/97), merge commit 548f0f5). Tag `v0.1.0-alpha` pushed.
    Pre-release published 2026-10-01: https://github.com/Daddy-Ousen/innworld-rpg/releases/tag/v0.1.0-alpha (two zips).
  - [ ] Android: skipped (user, 2026-10-01). Needs touch controls first (roadmap "Releases").
- [x] README rewrite for players first, developers second (branch `docs/readme-rewrite`, 2026-10-01, local). Counts checked:
  898 events, 261 NPCs, 103 places, 38 maps, 147 GUT scripts (~1,419 tests), 102 Python tests. Merged ([PR #99](https://github.com/Daddy-Ousen/innworld-rpg/pull/99)).
- [ ] Web build (ADR 0031; user, 2026-10-01: itch.io + GitHub Pages, GitHub URL first, own subdomain later).
  - [x] Branch `feat/web-build` (from `docs/readme-rewrite`): "Web" preset, web zip in `tools/release.ps1`, web-only
    stretch in `project.godot`, Quit hidden in a browser, `.github/workflows/pages.yml`, README "Play in your browser".
    All three zips built and smoke-tested (898 events, 38 maps, 0 problems). Checked in Chrome: play, save, reload, night 0.3 s.
    Tests run: `unit_play_loop` (17 pass). Full suite not run. Merged ([PR #100](https://github.com/Daddy-Ousen/innworld-rpg/pull/100), d565a3b).
  - [x] GitHub Pages on, source "GitHub Actions" (user, 2026-10-02).
  - [x] v0.1.1-alpha (user, 2026-10-02) on branch `release/v0.1.1`: version bump, README download link. Three zips built and
    smoke-tested (898 events, 38 maps, 0 problems). Tests run: `unit_play_loop` (17 pass). Full suite not run.
  - [x] Merged ([PR #101](https://github.com/Daddy-Ousen/innworld-rpg/pull/101), merge commit 429583e). Tag `v0.1.1-alpha` pushed.
    Pre-release published 2026-10-02 with three zips: https://github.com/Daddy-Ousen/innworld-rpg/releases/tag/v0.1.1-alpha
  - [x] Live: https://daddy-ousen.github.io/innworld-rpg/ (title screen v0.1.1-alpha, no errors; wasm served gzip, 10 MB).
    The release-event run failed: the `github-pages` environment allows only `main`, not tags. Deployed by hand with
    `gh workflow run pages.yml --ref main -f tag=v0.1.1-alpha` (success).
  - [x] Tag rule `v*` added to the `github-pages` environment (user, 2026-10-02). The re-run of the release-event run
    succeeded, so a published release now deploys by itself.
  - [x] itch.io: the page is live with the web zip (user, 2026-10-02).
  - [ ] Later: own subdomain (CNAME + Settings → Pages → Custom domain).


### handoff.md: older "Just done" entries (2026-10-07 – 2026-10-08)
## Just done (2026-10-08, local): Magnolia estate NPCs (branch `feat/magnolia-npcs`)
- `npc_behaviour.json`: `magnolia_reinhart`, `ressa`, `reynold`, two golems, place `magnolia_estate`; golem records in `canon/book2/npcs.json`. Test: `unit_north_road`.
- Gotcha: Magnolia is placed at the estate by day for every day: a guess. Canon has her in Celum (Book 1) and on the road. Watch for odd scenes and fix with `when_flags` / `unless_flags`.
- Next: user picks Book 8 plan or more wiki classes.

## Just done (2026-10-08, local): Magnolia's estate (branch `feat/magnolia-estate`)
- Maps `magnolia_estate_grounds`, `magnolia_estate_hall`; east exit on `invrisil_gate`; moods in `audio.json`. Test: `unit_north_road`. No NPCs, no events.
- Next: user picks Book 8 plan, more wiki classes, or Magnolia/Butler NPCs. Gotcha: patch map JSON as text/bytes (CRLF).

## Just done (2026-10-08, local): Invrisil staff (branch `feat/invrisil-staff`)
- `game/data/npc_behaviour.json`: `merec`, `raisha`, place `invrisil`. Test: `unit_north_road`. No art, no events.
- Next: user picks Magnolia's estate map, Book 8 plan, or more wiki classes. No canon Runners' Guild staff in Invrisil exists in the data: do not invent one.

## Just done (2026-10-08, local): later-list + keystore check (branch `docs/later-and-keystore`)
- Marked for later in `progress.md`: Magnolia's estate map; Invrisil staff NPCs + Runners jobs. Keystore and icon were already done (v0.1.3 shipped the signed apk); only the user's keystore backup is open.
- Next: the user picks (Book 8 plan, more wiki classes, the later items) or plays and reports.

## Just done (2026-10-08, local): Invrisil city (branch `feat/invrisil-city`, from main after PR 132)
- New maps `invrisil_main_street`, `invrisil_runners_guild`, `invrisil_crag_pig`, `invrisil_merchants_guild`; square got a north exit and a stall; shops in `economy.json`; moods in `audio.json`. Test: `unit_north_road` (7).
- No NPCs, no events. Hedault's house is a closed plaque (canon `hedault_house`, enchanter, 3.36). Next ideas: Magnolia's estate map (outside the city), Invrisil Runners jobs, staff NPCs, then release keystore + icon check (needs the user).
- Gotcha: a tree hides a wall 4 rows above it (`unit_ground_art`). Map data is plain JSON; patch `economy.json` / `audio.json` as text (CRLF).

## Just done (2026-10-08, local): north road (branch `feat/invrisil-road`)
- New maps `celum_north_gate`, `road_to_invrisil` (camp), `invrisil_gate`, `invrisil_square`; exits added to `celum_main_street` (top, x 15-16) and `riverfarm` (east edge to the Invrisil gate west edge). Audio moods in `audio.json`. Test: `unit_north_road`.
- Invrisil has only a gate and a square (no shops, no NPCs, no canon moved). Next ideas: Invrisil shops/Runners' Guild, Magnolia's mansion, put Laken/Riverfarm travel to use, then release keystore + icon.
- Gotchas: a tree hides a wall 4 rows above it (`unit_ground_art`). Generator script was in the scratchpad (gone later); maps are plain JSON now.

## Just done (2026-10-08, local): long road confirm + walk scene (branch `feat/long-road-confirm`)
- `game/ui/travel_prompt.gd` (TravelPrompt, built in code, added to `$SystemLayer` by `main.gd`): question panel (Travel / Stay, Esc = Stay), then a 1.8 s walker-on-a-track scene; `arrived` makes the real step. `main.gd`: `_ask_travel`, `confirm_travel` (false headless), `is_busy` includes `travel.visible`.
- Rule: exits with `minutes >= TravelPrompt.LONG_MINUTES` (300). Today: Celum gate <-> road camp <-> Liscor gate. Not the wagon rides, not Esthelm (180).
- Next: the user looks at it. If the look is wrong, tune `_layout` in `travel_prompt.gd`. No render was checked by eye.
- Test: `unit_travel_prompt`.

## Just done (2026-10-08, local): phone UI bigger + see-through (branch `feat/mobile-ui-bigger`)
- `game/ui/ui_scale.gd`: `MOBILE` = 2.5 (Auto on Android/iOS/web-on-phone, any dpi), `MOBILE_ALPHA` = 0.78, `set_box_alpha(theme, alpha)`. `game/ui/session.gd` applies both in `apply_ui_scale`. Test: `unit_ui_scale`.
- Next: the user checks it on the phone. If still small, raise `UiScale.MOBILE`; the interact menu is a fixed 440 x 220 box (no keep_fit), so above about 2.6 it may overflow in portrait.
- Gotcha: a fixed Options mode (100/150/200 %) still wins over Auto on a phone.



## Just done (2026-10-08, local): release v0.1.3-alpha prepared (branch `release/v0.1.3`)
- Files in `export/`: `InnworldRPG-v0.1.3-alpha-{windows,linux,web}.zip` and `-android.apk`. Next: after the PR merge, tag `v0.1.3-alpha` on main, `git push origin v0.1.3-alpha`, `gh release create` as pre-release with the four files. RULE: every release uploads the apk.

## Just done (2026-10-08, local): M20.2 Android build (branch `feat/m20.2-android-build`, from main)
- Added preset `Android` (`game/export_presets.cfg`), `window/handheld/orientation=6` and ETC2/ASTC import in `game/project.godot`. ADR 0034 has the build and install commands.
- Debug APK: `export/android/InnworldRPG-debug.apk` (gitignored). Signed with the Godot debug keystore. No phone was plugged in, so no install test.
- Also done: icon (`game/icon.png`, `tools/build_icon.py`) and a signed release APK `export/android/InnworldRPG-v0.1.2-alpha.apk`. Keystore + password file are in `%USERPROFILE%\.android\` (NOT in git; env vars at export, see ADR 0034). The user must back them up.
- Next: the user plugs in a phone (USB debugging on) and runs the `adb install -r` line from ADR 0034, then plays. Then: release keystore (user makes it), project icon (needs art), more wiki classes, or Book 8 plan.
- Gotchas: the export rewrites `.import` files: run `git checkout -- game/assets` after. Stray `game/tests/sim_book7_goblin_road.gd.uid` is untracked (from M19.8, not part of this branch).

## Just done (2026-10-08, local): M19.9 `sim_canon_book7` (branch `feat/m19.9-sim-canon-book7`, from main after PR 125)
- `game/tests/sim_canon_book7.gd` (5 tests): Book 7 runs days 130 - 143 with drift 0, 191 events, no kills, stages and order checked. Passes.
- Next: the user merges the PR; M19 is then done except the play check (rain, flood, door, Book 7 stages). Then pick: M20.2 Android, more wiki classes, or Book 8 plan.

## Just done (2026-10-08, local): M19.8 canon 5.19 G - 5.20 G (branch `feat/m19.8-canon-5-19`, from main 08451c7)
- `game/data/canon/book7/chapters/5.19G.json`, `5.20G.json` (orders 50 - 51): 21 events, days 141 - 143, all off-map. Test: `sim_book7_goblin_road` (new, 4). Detail: ADR 0030 "M19.8 as built".
- No stage, hook or xp_window. Pyrite's lunch with the Knights is a possible later scene (place `northern_swamp` has no map). Open: Tremborag's refusal of Velan is "likely"; places for Knights/Welca/Kerrig are guesses.
- Next: the user merges the PR. Then `sim_canon_book7` (run to the last Book 7 day, drift 0) closes M19.

## Just done (2026-10-08, local): M19.7 canon 5.16 S - 5.18 S (branch `feat/m19.7-canon-5-16`, from main 67287ff)
- `game/data/canon/book7/chapters/5.16S.json` - `5.18S.json` (orders 47 - 49): 33 events, days 140 - 143. Test: `sim_book7_zel_and_selys` (new, 4). Detail: ADR 0030 "M19.7 as built".
- Stages: `b7.zel_funeral_in_the_plaza` (liscor_plaza, 10 - 13, day 142, hook Zevara) and `b7.selys_haggles_with_jelaqua_at_the_inn` (inn_interior, 18 - 22, day 143, hook Selys). No xp_window.
- Gotchas: the validator allows tier 1 or 2 only (no tier 3 in data). Scene NPCs need a behaviour entry (added Seborn). `npc_behaviour.json` must be patched as text: a JSON dump reformats the whole file.
- Next: the user merges the PR. Then M19.8 (5.19 G, 5.20 G: Rags, Garen, Tremborag, road battle; off-map), then `sim_canon_book7` (done-when in the roadmap).

## Just done (2026-10-08, local): M19.6 canon 5.12 – 5.15 (branch `feat/m19.6-canon-5-12`)
- `game/data/canon/book7/chapters/5.12.json` – `5.15.json` (orders 43 – 46): 44 events, days 137 – 140. Tests: `sim_book7_flood_and_parade` (new, 6). Detail: ADR 0030 "M19.6 as built".
- Flood flag is set on day 137 (flags show a day late). Door west-wall flag `albez_door.anchor_at_liscor_wall` on day 138. Pallass link stays open.
- Stages (inn_interior, scenes): `b7.klbkch_and_relc_visit_the_rebuilt_inn` (138, 18 – 22), `b7.victory_party_at_the_inn` (139, 19 – 23), `b7.vuliel_drae_confess_the_eggs` (140, 9 – 13).
- Gotchas: in a crowded stage a seated guest can block `ToyMaps.walk_to` (seed-dependent); the new test places the player next to the NPC instead.
  The day-139 play (Battle of Liscor) is an event, not a stage. No records for Halliss, Euriss, Raskghar hunters, the head collector: the events use existing NPCs only.
- Next: the user merges the PR. Then M19.7 (5.16 S – 5.18 S), M19.8 (5.19 G, 5.20 G).

## Just done (2026-10-08, local): floating touch stick (branch `feat/touch-stick`, PR open)
- `game/ui/touch_controls.gd`: stick on the left half replaces the D-pad; Wait stays. `main.gd` passes `tapping` (fight turn) to `sync`.
- Files: `game/ui/touch_controls.gd`, `game/world/main.gd`, `game/ui/system_messages.gd`, `game/tests/unit_touch_controls.gd`, ADR 0032.
- Tests run: `unit_touch_controls`, `unit_ui_scale`, `unit_input_actions`. All pass.
- Next: commit these files on their own branch (not with the 5.12 canon files), PR, user tries it on a phone.
- Gotcha: a real touch also makes an emulated mouse tap; the stick is off in a fight turn so cell taps still work.

## Just done (2026-10-08, local): world wireframe (branch `docs/world-wireframe`)
- `docs/WORLD_WIREFRAME.md` + `docs/world_wireframe.svg`: continents, Izril spine, Celum - Invrisil - Riverfarm rules, open questions.
- Rule to keep: Riverfarm lies 50 - 80 mi SOUTH-WEST of Invrisil (not on the Celum road). Pallass is 400 mi south of the inn (Book 7). Invrisil 430 mi is a pick (books say 400 / 600).
- Next: the user checks the open questions (Drath, Zeres/Salazsar/Manus sides). Read this doc before any new road or map.
- Note: M19.5 (Riverfarm map) is merged. Check its place against section 4 of the doc: Riverfarm is SW of Invrisil.

## Just done (2026-10-08, local): M19.5 canon 5.09 E - 5.11 E (branch `feat/m19.5-canon-5-09`, from main fdfec5e)
- `game/data/canon/book7/chapters/5.09E.json`, `5.10E.json`, `5.11E.json` (orders 40 - 42): 26 events, days 130 - 142 (Laken's Day + 45).
- New map `game/data/maps/riverfarm.json`. Banquet = scene stage `b7.laken_feasts_the_nobles_and_the_spring_court` (day 142, 18 - 24 h) with hooks: Ivolethe talk, poisoned cup (Rie / Bethal).
- No road yet (user: the open world comes bit by bit). The `celum_gate` link was removed (Riverfarm is SW of Invrisil, see wireframe); `riverfarm` has no exits until an Invrisil map exists.
- Behaviour: off-map place `north_izril`; 15 new `npc_behaviour` entries. No character sheets (square markers).
- Test: `sim_book7_riverfarm` (7). Detail: ADR 0030 "M19.5 as built".
- Next: user merges the PR. Then M19.6 canon 5.12 - 5.15 (flood, door to the west wall, Embria, parade, dive). The flood overlays are already drawn (M19.1).
- Gotchas: a scene stage needs a `npc_behaviour` entry for every placed NPC. Pattin, Melbore, Geram, Wellim and Horst have no NPC records. Wiki not checked against the ebook for 5.09 E - 5.11 E.

## Before that (2026-10-07, local): wiki class tree, step 2 (merged)
- Added 4 tags, 4 actions (with sounds), 4 map objects, 8 classes (2 consolidations), 8 Skills. See `progress.md`.
- Test: `unit_class_tree_step2`. Objects: `inn_hill` `garden_bed`, `celum_gate` `hitching_post` + `stable_yard`, `celum_square` `wayside_shrine`.
- Next: the user merges the PR, then picks: M19.5 canon 5.09 E, M20.2 Android, or more wiki classes.
- Gotchas: a map object must not stand under an overlay rect (`toren_snow_wall` on inn_hill, `flood` on liscor_gate; `unit_data_db` checks it).
  `liscor_gate` is almost all flood overlay. No new object art: kinds `herbs`, `nest`, `horseshoe`, `plaque` are reused.
  The wiki lines are simplified (Priest side branches skipped). Wiki follows the web serial: not checked against the ebook.

## Before that (M19.4)
## Just done (2026-10-07, local): M19.4 canon 5.07, 5.08, Interlude - Flos (branch `feat/m19.4-canon-5-07`)
- `game/data/canon/book7/chapters/5.07.json`, `5.08.json`, `interlude_flos.json` (orders 37 - 39): 28 events, days 137 - 138.
- Moth fight stage `b7.face_eater_moths_attack_the_inn_and_liscor` (inn_hill, 7 waves, `xp_window` x3, fight hook). Scene `b7.the_inn_after_the_moths` (talk hook).
- Door: day 137 sets `albez_door.anchor_at_pallass` and `pallass.embargo_lifted`. Flags set: windows_broken, watchtower_smashed, jelaqua.body_broken, izril.rains.
- Test: `sim_book7_moths` (new, 6). Detail: ADR 0030 "M19.4 as built".
- Gotchas for M19.5+: wave `from` must not be an exit tile. Bird's broken bow, Numbtongue's arm are flags only. Seborn, Olesm, Selys, Octavia have no combat entry. Flos threads are off-map.
- Next: M19.5 canon 5.09 E - 5.11 E (Laken, banquet, fae; off-map). User merges the M19.4 PR first.

## Before that (2026-10-07, local): M19.0 engine (door links + the rains)
- Branch `feat/m19.0-door-links-rains` (from main 663e702; the M19.P plan PR #111 is merged). Detail: ADR 0030 "M19.0 as built".
- Door: `portal.links` (`core/portal.gd`, `Interact.portal_action`, menu one line per open link, console `portal <object> [link]`,
  `rules.portal.shut_line`). Old single form still works. Rains: `core/rains.gd`, `rules.rains` (flags `izril.rains`, `izril.flood`),
  `Atmosphere.rain`, `WorldView.setup(..., rain_flag)`, bed variant `rain` -> cue `amb_rain` (`tools/build_rain.py` + ffmpeg).
- The flood is overlays (tile `water`, `when_flags: ["izril.flood"]`): M19.1 draws them. No save change.
- Not checked by eye: the rain look. The user runs `flag izril.rains` in the console and walks outside.
- Tests run: `unit_portal_links`, `unit_rains` (new) + 16 touched scripts, Python tool tests (105), validator. All pass. Full suite not run.


### handoff.md: old "Next" block (M19.0 era)
## Next (the user picks one)
1. The user merges the M19.0 PR.
2. M19.2 Canon 5.00 – 5.03 (local or cloud).
3. M20.2 Android build (local: Android SDK, JDK 17, keystore).
- Open data gaps: Seborn, Zevara, Relc and Lyonette have no combat entries for stages; Jelaqua's new body; the 4.26 M golem
  count (three, text shows two) waits for a local check; Laken's Day 85 (day 130) has no event (4.49 omits him; 5.09 E covers it: M19.5).
- M19.1 note: a door link `pos` must be a walkable tile on the far map; the flood rects must not cover the door, the inn hill,
  an exit or an object, and a player or NPC standing on a tile that floods is not moved (check the spots when you draw the rects).

## Archived 2026-10-13 (cleanup)

### handoff.md: old 'Just done' entries (M25.4 back to the 2026-10-08 audit)
## Just done (2026-10-12, local): M25.4 Magnolia's whereabouts (branch `feat/m25.4-magnolia-whereabouts`)
- Data only, existing behaviour schema (`when_flags` / `unless_flags`). No save change, no engine change, no ADR.
- `game/data/npc_behaviour.json`: Magnolia and Ressa get base-5 goals that beat the estate goals:
  `@celum` until `magnolia.gone_north` (1.63); `@north_izril` (the road) until `magnolia.watches_the_inn` (2.06);
  the estate after; `@north_izril` again (away) from `magnolia.gone_to_first_landing` (3.14) until
  `magnolia.sends_gold_to_esthelm` (4.38B). No map exists for her Celum house or First Landing, so those are off map.
- New behaviour for the Earthers Rose (hall 5,7), Imani (hall 14,7), Joseph (grounds 22,12): seen by day from
  `magnolia.hides_other_earthers` (2.23, day 49), else inside the estate (off map). Spots and hours are guesses.
  They use the generic human look (no own sprite).
- Tests: `unit_m25_whereabouts` (new, 5) + the list in `progress.md`. All pass. Full suite not run.
- M25 is all ticked: moved to Done in `docs/ROADMAP.md`. Next: user merges the PR. Then M26.0 split `main.gd` **[Opus · medium]**.
- Gotchas: on the road an NPC walking between off-map places shows up on a map along the way if the player is there
  (normal NpcSim). The user has not seen this in play. Own looks for the 3 Earthers would need `tools/build_sprites.py`.

## Just done (2026-10-12, local): M25.3 NPC sheets (branch `feat/m25.3-npc-sheets`)
- User pick: sheets need the Skill [Appraisal]. New `core/npc_sheet.gd` (`NpcSheet.can_read`, `NpcSheet.lines`): name, race,
  classes with level (`?` when canon level is null), never a total. Works for every canon NPC (Merec, Raisha, Ressa, Reynold, Magnolia, golems incl.).
- `Interact.options` NPC rows get `"appraise"`; `Interact.APPRAISE`; menu row "Appraise" (`ui/interact_menu.gd`);
  `main.use` opens `CharacterSheet.open_lines`. New rule `rules.npc.appraisal_skill: "appraisal"` (additive). No save change, no time cost.
- [Appraisal] is an uncommon merchant Skill (class pool level 4 - 15), so a player must be a merchant to get it.
- Tests: `unit_npc_sheet` (new, 6), plus the list in `progress.md`. Full suite not run.
- Next: user merges the PR. Then M25.4 Magnolia's whereabouts **[Opus · medium]**.
- Gotchas: `WorldState.is_alive(canon, npc)` takes the canon db. New `class_name` needs `--import`. The user has not tried the row in play (needs `skill appraisal` or a merchant).

## Just done (2026-10-12, local): M25.2 job boards (branch `feat/m25.2-job-boards`)
- Data only. Actions `take_guild_job` (120 min, pay 6-12), `tally_ledgers` (60 min, 4-8), `haul_goods` (60 min, 3-5) in
  `actions.json`, `economy.json` jobs, `audio.json` (sound `coins`). Pay and tags are guesses.
- Boards: `liscor_adventurers_guild/job_board` (take_guild_job), `invrisil_merchants_guild/contract_board` (new, tally_ledgers),
  `invrisil_square/invrisil_notice` and `celum_square/celum_job_board` (new, haul_goods). Celum has no Merchants' Guild map, so its board is on the square.
- New test `unit_m25_job_boards` (3). Other tests: see `progress.md` M25 line. Validator 0 errors. Full suite not run.
- Next: user merges the PR. Then M25.3 character sheets **[Sonnet · medium]**.
- Gotchas: patch CRLF data files with Python on bytes. The user has not walked to the new boards.

## Just done (2026-10-12, local): M25.1 talk topics (branch `feat/m25.1-talk-topics`)
- User picked "hints only": requests are hint lines, no state, no reward, no save change. ADR 0039.
- New `game/core/talk_topics.gd` (`TalkTopics`). `Interact.perform` adds one line after the greeting on the first
  talk of the day (`NpcSim.note_talk` true): `rules.talk.line` = `Name: "text"`.
- Pool: news of the last `news_days` (5) days: `own` (event cast the NPC), `town` (event location in the NPC's town,
  from canon `home`), T1 `rumor`; plus `game/data/talk.json` topics (`news`/`rumor` → "topic", `request`). Weighted
  pick with `gs.rng` (weights own 4, town 3, rumor 2, topic 2, request 1). Regard under `min_regard` (0) = no line.
- `talk.json` schema v1: id → {kind, text, confidence, who {npcs, tags, towns}?, flags?, not_flags?, days?,
  canon_ref?, note?}. 11 canon topics (Books 1 - 2; chapter refs from the event that sets the flag) and 6 request
  hints (`confidence: guess`). Loaded and validated in `DataDb.load_dir`; `db.talk`.
- `Standing.town_of_location(db, loc)` split out of `town_of`.
- `ToyData.db()` erases `rules.talk` (toy rules copy the real ones; otherwise toy talks would roll RNG).
- Tests (all pass): `unit_talk_topics` (new, 6), `unit_standing`, `unit_data_db`, `unit_npc_sim`, and the 27 sims
  that talk through Interact (sim_book3_* … sim_book7_*, sim_esthelm_siege, sim_npc_day, sim_balance_progress);
  validator book1 0 errors; Python 116 OK. Full suite not run.
- Next: user merges the PR. Then M25.2 job boards **[Sonnet · medium]** (real requests could join there).
- Gotchas: a talk with a canon NPC now uses one RNG roll when its pool is not empty. Topics can repeat on later
  days (no state). Books 3+ have event news but no talk.json topics yet. `rules.json`, `standing.gd`,
  `interact.gd`, `data_db.gd` are CRLF: patch with Python, keep CRLF.

## Just done (2026-10-12, local): roadmap tidy
- `docs/ROADMAP.md`: M24 (all ticked) moved from Next up to the top of Done; order line now M25 → M26;
  outside PR #164 noted under Later. Docs only, no tests run.

## Just done (2026-10-12, local): M25.0 NPC levels (branch `feat/m25.0-npc-levels`)
- ADR 0038. New `game/core/npc_levels.gd` (`NpcLevels`). `Director.run` calls `NpcLevels.grow(gs, db, day)` after each
  day's events (also the days before the player arrives).
- Each living canon NPC with classes gets `rules.npc.levels.daily_xp` (12) a day, plus `event_xp` (50) on a day a
  canon event that happened cast them by name. XP is split evenly between the NPC's classes. Cost = the player's
  curve on the NPC's total level (`Levels.xp_to_next`), total cap holds. Capstones need a key: being cast in an
  event one level under a capstone gives it. Canon `null` level = `unknown_level` (12), shown as `known: false`.
- NPCs with no class never grow (Ryoka, Dragon, Erin). A later-book NPC starts on its book's first day
  (`CanonDb.book_start` / `first_day_of`, from event rank + window).
- State: `gs.world.npc_levels` npc → {class name → {gain, xp, key?}}. Save v21; migration adds `{}`.
- Debug console: `npclevels <npc>`. No UI yet (M25.3 sheets read `NpcLevels.classes_of`).
- Probe over Books 1 - 6 (day 129): 119 NPCs tracked, 73 grew, top +12 (Pawn, Laken). Relc never grows (total 57).
- Tests run (all pass): `unit_npc_levels` (new, 12), `sim_npc_levels` (new, 6), `unit_game_state`, `unit_mana`
  (removed the `SAVE_VERSION == 20` pin), `unit_director`, `unit_canon_db`, `unit_console`, `unit_save_slots`,
  `sim_canon_book1`; validator book1 0 errors. Full suite not run.
- Next: user merges the PR. Then M25.1 talk topics **[Opus · medium]**.
- Gotchas: a new `class_name` needs `godot --headless --path game --import` before a `-s` script sees it. The import
  touches ~290 `.import` files (stat only): `git update-index -q --refresh` clears them. Not done: NPCs gain no new
  classes (needs an event effect = schema change, ask first); NPC levels do not change fight stats.

## Just done (2026-10-12, local): review of outside PR #164 (DKemp98, "Expanded Skills, Classes and Sundry")
- Review only. No code changed, nothing committed, no comment posted on the PR.
- Findings: PR is based on main before M23.5 (23 commits behind) and conflicts. `classes.json` and `skills.json`
  are rewritten flat (no `schema_version`, no `classes`/`skills` wrapper), so `DataDb` loads 0 classes and 0 skills.
  One-item lists became strings (`excludes` null, `neglect_tags`, `tags`, trial `action`/`outcome`). Number
  ranges (`heal` [8,15], yields [1,3], `base_stats` [2,4]) break `int()` reads in economy.gd, monster_sim.gd, spells.gd
  and have no RNG code. `grill_meat`/`make_pastry` have no recipe, so they make no food. It drops 4 skills
  (`steady_seat`, `keen_draw`, `forge_arms`, `patient_voice`) and would wipe the 63 M24.3 rare skills. 210 of 216 new
  skills have no effect. No tests.
- User picked option 1 (ask for changes). Reply text drafted in chat; the user posts it. Next: wait for the rebased, split PRs.

## Just done (2026-10-11, local): Google Play prep (branch `feat/play-store-prep`)
- User asked to prepare a Google Play release. User picks: build now, upload only after pirateaba says yes in
  writing; Gradle template gitignored. ADR 0037, guide `docs/PLAY_STORE.md`, `PRIVACY.md`.
- Preset `Android Play` (preset.4): Gradle, AAB, target SDK 36, arm64. `tools/release.ps1` builds
  `export/InnworldRPG-v<version>-play.aab` after the apk; `-PlayOnly` builds only the aab.
- `python tools/build_store_art.py` makes `export/play/` (feature graphic, 32-bit icon, 2x screenshots) from `export/itch/`.
- Checked: AAB 88 MB, jarsigner ok, release-key SHA256 1A:13:D3..., merged manifest versionCode 3, min 29,
  target 36, no permissions. Python tests 116 OK. No GUT run (no game code changed). Full suite not run.
- Next: user merges the PR; user asks pirateaba; user makes the Play account. Then internal test. Then M25.0.
- Gotchas:
  - Gradle needs `GRADLE_OPTS='-Xmx2g -Dorg.gradle.daemon=false -Dorg.gradle.jvmargs=-Xmx2g'` (set by release.ps1).
    The template's 4.5 GB daemon crashed (out of memory, 16 GB PC); a daemon also keeps Godot's output open, so
    the script never ends; with no daemon the build runs in the 64 MB client unless `-Xmx2g`.
  - PowerShell: `$x = if (...) { @('a') } else { @() }` unrolls to a string; splatting `@x` then drops it.
  - Godot's headless import crashes at random on `PixelOperator-Bold.ttf` (0xC0000005). Run `--import` again.
  - Godot 4.7 writes `screenOrientation="fullUser"` in the manifest (apk too) and sets landscape at run time.
  - API 36 ignores the landscape lock on screens 600 dp and up: tablet check is open.
  - An export rewrites `game/project.godot` and `game/icon.png.import` (order only): `git checkout --` them.

## Just done (2026-10-11, local): M24.3 skills (branch `feat/m24.3-skills`)
- Data only. 63 rare Skills appended to `game/data/skills.json`: every class in `classes.json` now has a rare Skill for its level 10 capstone (pool 10 - 30) and a second for level 20 (pool 20 - 30). Capstone levels always pick a rare Skill first (`SkillSystem.grant_random(..., prefer_rare)`), so no class falls back to a common one at 10 or 20. Four are combat actions: `crushing_blow` (veteran_warrior), `lance_strike` (knight), `backstab` (assassin), `trampling_charge` (dragoon, area). The rest are passive `stat_mod` / `xp_mult`. Names and numbers are guesses (`confidence: guess`).
- Level 30 is not covered for every class (only the 10 - 30 skill and the 20 - 30 skill exist; level 30 falls back to any Skill).
- Tests run (pass): `unit_m24_skills` (new, 3), `unit_data_db`, `unit_class_tree_step2`, `unit_skill_system`, `unit_combat_skills`, `unit_class_system`, `unit_levels`, `unit_stats`, `unit_night`, `unit_breakthrough`, `unit_mana`, `unit_journal`, `unit_class_tree_step3`; validator 0 errors. Full suite not run.
- M24 is done. Next: M25.0 NPC levels **[Opus · high]** (DESIGN section 4.5; save change + migration).
- Gotchas: the patch script (`scratchpad/gen_m243.py`) is gone next session. `skills.json` is CRLF with one-line sub-objects; new entries were appended on bytes before the final `}` `}`. Never `sed -i` a CRLF file (it did strip `docs/ROADMAP.md`; restored with Python).

## Just done (2026-10-11, local): M24.2 spells (branch `feat/m24.2-spells`)
- Data only. New spell `gust` (line, Pisces teaches after `b1.pisces_saves_erin_from_flies`). Spellbooks `spellbook_gust`, `_ice_spike`, `_flashfire`, `_frozen_wind` (each spell's `learn.book`), `spellbook_fireball` now costs 320. Shop `liscor_mages_guild` on object `spell_shelf` ([10,2], liscor_mages_guild). Pisces' NPC spell list: `frozen_wind` first, then `gust` (the NPC picks the first ready spell). Prices are guesses.
- Not added: [Ice Wall], [Barrier of Air], [Mend], [Light] are canon but the spell shapes are attack-only (`one`, `line`, `blast`, `around`). They need an engine step (utility / defence shapes).
- Tests run (pass): `unit_m24_spells` (new, 4), `unit_spell_learning`, `unit_spells`, `unit_spell_ui`, `unit_economy`, `unit_map_db`, `unit_ground_art`, `unit_data_db`, `unit_behaviour_db`, `unit_npc_sim`; validator 0 errors. Full suite not run.
- Next: M24.3 skills **[Sonnet · high]**.

## Just done (2026-10-11, local): M24.1 recipes and goods (branch `feat/m24.1-recipes-goods`)
- Data only. Recipes `pizza` (flour+vegetables+meat -> 2, stove, confidence likely: pizza is in 2.31), `roast_meat`, `vegetable_soup` (stove or campfire); actions `bake_pizza`, `roast_meat`, `cook_vegetable_soup` (sound `cook`); goods and items `wooden_club`, `iron_dagger`, `hand_axe`; shop `liscor_smith` on object `smith_counter` (liscor_market [3,8]). Inn stove and road camp campfire got the new actions; the three are in `rules.json` `inn_work_actions`. All numbers are guesses.
- Tests run (pass): `unit_m24_goods` (new, 3), `unit_cooking` (recipe count 7), `unit_world_view` (stove menu now 8 entries), and the list in `progress.md`. Full suite not run.
- Next: M24.2 spells **[Sonnet · medium]**.
- Gotchas: a new stove action lengthens the use menu; `unit_world_view` counts it. `GameState.new_game` needs `(seed, db, start)`.

## Just done (2026-10-11, local): M24.0 class actions (branch `feat/m24.0-class-actions`)
- Data only. Actions `hunt`, `shoot_bow`, `brew_potion`, `forge_tool`, `teach_lesson` in `game/data/actions.json` (tags copy each class's weights; `hunt` has cold duress). Sounds in `audio.json` reuse `pick_up`, `swing`, `water`, `hammer`, `book`.
- Map objects on existing art: `hunting_blind` (floodplains_south [9,23], kind reeds), `archery_target` (inn_hill [28,14], dead_tree), `brewing_cauldron` (liscor_mages_guild [3,6], brazier), `smiths_forge` (liscor_market [4,9], hearth), `lesson_slate` (inn_interior [2,8], papers). Positions and numbers are guesses.
- New test `unit_class_actions` (3). Tests run (pass): that, `unit_class_tree_step2`, `_step3`, `unit_actions`, `unit_tags`, `unit_audio_data`, `unit_sound_cues`, `unit_map_db`, `unit_ground_art`, `unit_world_view`, `unit_gated_exits`; validator 0 errors; Python 114 OK. Full suite not run.
- Roadmap: M23 moved to Done; At a glance now starts with M24.
- Next: M24.1 recipes and goods **[Sonnet · medium]**.
- Gotchas: a map object must not sit under a map overlay (the `flood` overlay on floodplains_south covers most free grass: the only free grass is (9,23), (8,23), (31,11), (31,12)). `map_db` logs "covers an exit or an object" for it. The user has not walked to the new objects yet.

## Just done (2026-10-11, local): M23.7 drift warning
- Journal drift line and one-time warning page already existed. Added `SystemMessages.DRIFT_REMINDER` on the Morning page every day while drift >= `unreliable_at`.
- Tests run (pass): `unit_system_messages` (18), `unit_journal`, `unit_director`. Full suite not run.
- Next: M24.0 **[Sonnet · medium]**. M23 is done.

## Just done (2026-10-11, local): M23.6 Book 7 canon bends (branch `feat/m23.6-book7-bends`)
- ADR 0036 "Book 7" lists every change. Data only (21 Book 7 chapter files), no engine change.
- Book 7 had almost no `depends_on` and no flag checks, so most scenes ran with their cause gone (Pallass soldiers
  crossed a door that was never set, Pisces saved Selys from a kidnap that never happened, Magnolia's letter came
  from a dead Magnolia, the Redfang five stayed at the inn after a Book 6 alt sent them north). They now wait on
  real-cause flags. The rain (`izril.rains`) and flood (`izril.flood`) no longer need Erin.
- Book 7 lost on a day-130 death: Erin 38 → 51, Selys 18 → 25 (more: real causes), Zevara 17 → 5 (3 stand-ins,
  optional in 8 scenes), Laken 26, Rags 14, Magnolia 0 → 12, Kerrig 5 → 3. Erin dead on day 114: Book 7 38 → 64.
  The user has not seen this trade yet: say it plainly in the PR.
- New `game/tests/sim_kill_book7.gd` (10): kills Erin, Laken, Selys, Zevara, Rags, Magnolia, Kerrig on day 130;
  hook-per-day (14 days); sweeping at the inn broom on day 136 changes the fire scene.
- Changed old tests: `sim_book7_goblin_road` (alt events left out of the 5.19G – 5.20G count), `sim_player_hooks` (128).
- Tests run (all pass): `sim_kill_book7`, `sim_kill_book2..6`, `sim_canon_book7`, `sim_book7_*` (8), `sim_player_hooks`,
  `unit_rains`, `unit_canon_db`, `unit_event_order`, `sim_divergence`; validator 0 / 0 on Books 1 – 7; Python 114 OK.
  Full suite not run. `docs/divergence/report.md` regenerated.
- Next: M23.7 drift warning **[Sonnet · medium]** (journal + morning page say canon knowledge is unreliable at high
  drift, DESIGN §4.1). Then M24.
- Gotchas: Book 7 chapter files round-trip exactly (`json.dumps(indent="	", ensure_ascii=False)` + "
", CRLF).
  The patch script was `scratchpad/patch_m236.py` (helpers `req_flags`, `optional`, `required`, `substitute`,
  `mutate`, `set_dep`, `add_sets`, `add_alt`, `add_hook`); gone next session. Probe: `game/_scratch/probe.gd`
  (`extends SceneTree`; env BOOK, KILL_DAY, END_DAY, VICTIMS comma list with `+`, LIST=1, FRESH=1 rebuilds the
  cached base in `user://probe_base_<day>.json`); deleted, rebuild it. A substitute never picks an NPC who is
  already cast in the same event (an optional role counts): Tekshia cannot stand in for Zevara at the funeral
  because she is already there, so there Zevara is optional instead. The older kill sims stop at their book's
  last day, so later-book losses do not show in their drift. Open: a Zel killed in Book 6 still gets the Book 7
  casket with the Heartflame on him.

## Just done (2026-10-11, local): M23.5 Book 6 canon bends (branch `feat/m23.5-book6-bends`)
- ADR 0036 "Book 6" lists every change. Data only (15 Book 6 chapter files + 3 object actions on `maps/riverfarm.json`),
  no engine change.
- Book 6 had scenes with no link to their cause: the Battle of Invrisil ran with Zel dead, the trap ran with no
  battle, the Redfang moved into the inn with Erin dead. They now wait on real-cause flags. So Zel / Magnolia /
  Goblin Lord / Erin deaths lose MORE events than before (25 → 35, 17 → 36, 16 → 27, 14 → 22); Olesm 13 → 7, Oom 9 → 1.
  The user has not seen this trade yet: say it plainly in the PR.
- New `game/tests/sim_kill_book6.gd` (9): kills Zel, Magnolia, the Goblin Lord, Erin, Olesm, Oom + Venitra on day 114;
  hook-per-day (15 days); chopping wood at the Riverfarm trebuchet frame on day 118 changes that day. Copy it for Book 7.
- Changed old tests: `sim_kill_book5` (Erin's drift ceiling 31 → 33.5: her Book 6 days 114 – 115 now need her),
  `sim_player_hooks` count 123, `sim_book6_world` (stale assert: Dasha has her own look since 4dce883; was red on main).
- Tests run (all pass): `sim_kill_book6`, `sim_kill_book5`, `sim_canon_book6`, `sim_canon_book7`, `sim_book6_*` (7),
  `sim_player_hooks`, `unit_canon_db`, `sim_divergence`, `unit_event_order`, `unit_map_db`, `unit_north_road`,
  `sim_book7_riverfarm`; validator 0 / 0 on Books 1 – 7; Python 114 OK. Full suite not run.
  `docs/divergence/report.md` regenerated.
- Next: M23.6 Book 7 **[Opus · high]**. Picks: Erin, Laken, Selys, Zevara, Rags; key events in `docs/divergence/picks.md`.
- Gotchas: Book 6 chapter files round-trip exactly through `json.load` / `json.dumps(indent="	", ensure_ascii=False)`
  + "
", written with CRLF, so a plain load-edit-dump patch is safe (check Book 7 the same way first). The patch
  script was `scratchpad/patch_m235.py` (helpers `req_flags`, `req_alive`, `required`, `optional`, `on_fail`,
  `set_dep`, `add_alt`, `add_hook`); gone next session. Probe: `game/_scratch/probe.gd` (`extends SceneTree`, env
  BOOK, KILL_DAY, END_DAY, VICTIMS comma list with `+`, LIST=1; `Director.run` to KILL_DAY - 1, `set_alive`, run to
  END_DAY, print lost / alts / substitutes); 10 victims in ~30 s; deleted, rebuild it. Look for the OPPOSITE problem
  too: scenes whose roles are all optional, or that never check a flag, run with their cause gone. Map objects with
  `"actions": []` mean only NPC talk works there: a hook there needs `talk_with_guest` / `comfort_someone` / `persuade`.
  `riverfarm.json` has one-line exits: edit the action lists by text, not by a JSON dump.

## Just done (2026-10-11): ROADMAP.md reorganised (branch `docs/roadmap-reorg`)
- Order now: At a glance → Next up (M23 – M26) → Waits on the user (M20 touch-screen PC, keystore backup, ask
  pirateaba) → Later → Releases (v0.1.0 – v0.1.4) → Done (M21 at the top, then M22, M19 … M0).
- M20 phone check ticked from the M21.6 play pass. Nothing lost (old file: 170 ticked / 15 open; new: 173 / 17).
- Next: M23.5 Book 6 **[Opus · high]**. Picks in `docs/divergence/picks.md`.

## Just done (2026-10-11, local): M23.4 Book 5 canon bends (branch `feat/m23.4-book5-bends`)
- ADR 0036 "Book 5" lists every change. Data only (13 Book 5 chapter files), no engine change.
- New `game/tests/sim_kill_book5.gd` (10): kills Ryoka, Erin, Laken, Venitra, Lyonette on day 97 and Ken, Quallet
  on day 78 (second base save for the Baleros thread); hook-per-day (16 days); washing up on day 103 changes the
  new staff's first day. Copy it for Book 6.
- Changed old tests: `sim_canon_book5` (no Ryoka: Erin pays for the build; no Venitra: the Word of Death still
  falls), `sim_book5_geneva` (alt events left out of the arc list; no Ken: the Red Cross is still founded),
  `sim_player_hooks` count 114.
- Tests run (all pass): `sim_kill_book5`, `sim_canon_book5..7`, `sim_book5_*` (7 scripts), `sim_player_hooks`,
  `unit_canon_db`, `sim_divergence`, `sim_kill_book4`; validator 0 / 0 on Books 1 – 7; Python 114 OK. Full suite
  not run. `docs/divergence/report.md` regenerated.
- Next: M23.5 Book 6 **[Opus · high]**. Picks in `docs/divergence/picks.md`.
- Gotchas: Book 5 chapter files are fully expanded JSON (tab indent, CRLF), but 4.06KM and 4.07 mix in one-line
  objects. The patch helper kept each untouched event's original text and dumped only changed events (split on
  `		"b5.<id>": {` ... `
		}`). The M23.0 report counts `depends_on` only; Book 5 chains run on flags, so
  measure with a director run: a scratch `extends SceneTree` script (`GameState.new_game`, `Director.run` to the
  day before, `gs.world.set_alive(npc, false)`, `Director.run` to the end, count `b<N>.` events that are not
  happened and not alt-only). A script error in a `-s` script hangs Godot (no quit): kill it by command line.
  An alt event that replaces a revival needs the `revive` effect too.

## Just done (2026-10-11): M21.6 closed, journal focus picker removed (branch `fix/journal-no-focus-picker`)
- The user played every open check: all fine. M21.6 and M21 are ticked.
- Journal: the Focus list, its hint line and the "Focus:" line are gone (`ui/journal.gd`, `journal.tscn`, `main.gd`). `focus_choices`, `focus_name`, `main_tags` stay (character sheet, console, tests). Focus still works through the console `focus` command.
- Tests run (pass): `unit_journal` (7), `unit_touch_controls` (18; the tap test now uses its own ItemList), `unit_character_sheet`. Full suite not run.
- Next: M23.4 Book 5 **[Opus · high]**. Optional: console `skip <days>` command (offered to the user, no answer yet).

## Just done (2026-10-10): ROADMAP.md reorganised
- `docs/ROADMAP.md`: added an "At a glance" table. Open work is first (M21, M23 – M26). M20 and Releases sit under "Waits on a user check". M22 (all ticked) moved to the top of Done. No content lost. Not committed yet.

## Just done (2026-10-10): release v0.1.4-alpha
- Built from branch `feat/m23.3-book4-bends` (version bump commit, tag `v0.1.4-alpha` pushed). Pre-release with 4 files (win, linux, web zips + signed apk): https://github.com/Daddy-Ousen/innworld-rpg/releases/tag/v0.1.4-alpha
- Not done: the M23.3 PR is not merged yet. The itch.io / GitHub Pages web build is not re-uploaded.

## Just done (2026-10-10, local): M23.3 Book 4 canon bends (branch `feat/m23.3-book4-bends`)
- ADR 0036 "Book 4" lists every change. Data only (15 Book 4 chapter files), no engine change.
- Patch scripts were in the session scratchpad (`patch_m233*.py`: text edits per event block, keep CRLF; helpers
  `set_field`, `requires`, `optional`, `on_fail`, `add_alt`, `add_hook`). Gone next session; rebuild if needed.
- New `game/tests/sim_kill_book4.gd` (10): kills Erin, Zel, Ceria, Teriarch, Klbkch, Lyonette, Pisces on day 85;
  hook-per-day (9 days); cooking at the inn stove on day 96 changes the solstice dawn. Copy it for Book 5.
- `sim_kill_book3`: the Ceria and Pisces tests now see Erin home on day 91 (Book 4 hand-off), not still on the wagon.
- Tests run (all pass): `sim_kill_book4`, `sim_kill_book3`, `sim_kill_book2`, `sim_player_hooks` (110), `unit_canon_db`,
  `sim_divergence`, `sim_canon_book3..7`, `sim_book4_christmas`, `_homecoming`, `_mrsha`, `_relief_home`, `_wistram`;
  validator 0 / 0; Python 114 OK. Full suite not run. `docs/divergence/report.md` regenerated.
- Next: M23.4 Book 5 **[Opus · high]**. Picks: Ryoka, Erin, Laken, Venitra, Lyonette; key events in `docs/divergence/picks.md`
  (small chains: 5 dependents at most). Book 5 days 97 – 115.
- Gotchas: `horns_of_hammerad.bound_for_liscor` is set in Book 1 (1.47R) and never cleared until Book 4: use
  `horns_of_hammerad.left_celum` to test that the Horns left Celum. Cutting links reorders a day: watch a flag that
  one event sets and another clears on the same day (`ryoka.heading_home_to_liscor` broke `sim_book4_christmas` until
  Laken's request waited for Ryoka's replies). Chapter files have more top-level keys after `events` (insert alts
  before the first `
	}` after `"events": {`). The probe (`game/_scratch/probe.gd`, `extends SceneTree`, env BOOK,
  KILL_DAY, END_DAY, VICTIMS (comma, `+` for several, `none`), LIST=1) runs `Director.run` only: 11 victims in ~20 s.
  It is deleted; rebuild from `GameState.new_game` + `Director.run` + `Director.player_kill`.

## Earlier (2026-10-10): M23.2 Book 3 (merged, PR #156)
- `Director._wait_until`: a dependent waits while a dependency is delayed. `sim_kill_book3` is the model for the kill sims.

## Earlier (2026-10-10): M23.0 divergence report
- `tools/divergence_report.py`; rerun `python tools/divergence_report.py game/data/canon --out docs/divergence/report.md`
  after data changes (done for M23.1). "Pinned" = fails if that one NPC dies; "Lost" adds the same-book cascade.

## Just done (2026-10-10, local): M22.4 probe sim (branch `feat/m22.4-probe-sim`)
- New `game/tests/sim_breakthrough_probe.gd` (2 tests, ~3 min of sim): busy inn worker, quiet inn worker, fighter, days 1 – 87,
  3 seeds. Busy inn passes level 10 on night 31 – 32; quiet inn waits for its key until night 73; fighter level 10 on
  night 17 – 22. Table and decision in ADR 0035 "Probe result". No bar number changed. No code or data changed.
- Tests run: `sim_breakthrough_probe` (2 pass). Full suite not run. M22.3's state-file notes are committed here too.
- M22 is complete. Next: the user picks M23 (canon bends, **[Opus · high]** per book) or M21.6 (play pass). Start M23.0
  (`tools/divergence_report.py`, **[Sonnet · medium]**) first; it needs the user to pick key NPCs.
- Gotchas: a GutTest method named `_summary` makes a parse error ("Member is not a function"): the probe uses `_describe`
  and `_log_lines`. `BALANCE_LOG=<file>` writes every night row. 11 merged local branches (M21 / M22) can be cleaned up.

## Just done (2026-10-10, local): M22.3 consolidation (branch `feat/m22.3-consolidation`)
- Cherry-picked 565bc9b onto main (code + tests + DESIGN). Fixed the `rules.json` conflict by hand (kept
  `levels.breakthrough`, added `offers.consolidation_min_level: 10`). Old state-file edits from 565bc9b dropped.
- `unit_class_tree_step3` now calls `make_offers(gs, db, budget)` (no `kind`). New test in `unit_class_tree_step2`:
  consolidation waits for the source class's level 10 breakthrough; keys do not carry over.
- ADR 0035 "Steps" has the M22.3 build note. ROADMAP ticked.
- Tests run (all pass): `unit_class_system`, `unit_class_tree_step2`, `unit_class_tree_step3`, `unit_night`,
  `unit_system_messages`, `unit_journal`, `unit_game_state`, `unit_data_db`, `unit_breakthrough`, `sim_decline`;
  Python 107 OK; validator 0 errors. Full suite not run.
- PR #152 merged. Local branches `feat/class-tree-wiki` and `feat/m22.3-consolidation` deleted (user OK).
  Remote `origin/feat/class-tree-wiki` still exists. This note and the `progress.md` line are NOT committed yet:
  commit them on the M22.4 branch.
- Next: M22.4 probe sim **[Sonnet · high]**. 11 merged local branches (M21 / M22) can be cleaned up later.
- Gotchas: a source class that gets its canon key in night step 5b reaches level 10 there, so it consolidates on
  the NEXT night (step 4 runs before 5b). The Python test run prints validator ERROR lines from its fixtures: read
  only the `Ran` / `OK` lines.

## Just done (2026-10-10, local): M22.2 breakthrough data (branch `feat/m22.2-breakthrough-data`)
- `game/data/classes.json`: `breakthrough` {hint, trials} on innkeeper, cook, warrior, runner, mage, scout, priest, carpenter.
- Six `boon` hooks (tags effect) in `1.21`, `1.29`, `1.60`, `2.26`, `2.31`, `3.20T`. `sim_player_hooks` count is 74 now.
- Tests run (all pass): `unit_breakthrough` (17), `unit_data_db`, `unit_canon_db`, `unit_director`, `unit_player_hooks`,
  `sim_player_hooks`, `sim_canon_book1..3`; Python 107 OK; validator 0 errors. Full suite not run.
- Next: M22.3 consolidation **[Opus · medium]** (start from `git show 565bc9b`), then M22.4 probe sim **[Sonnet · high]**
  (tunes the bar numbers; they are guesses).
- Gotchas: all these data files are CRLF in the working copy: patch on bytes (scratchpad script), not `sed -i`.

## Just done (2026-10-10, local): M22.1 breakthrough engine (branch `feat/m22.1-breakthrough-engine`)
- New `game/core/breakthrough.gd` (sources 1 – 3, hint, key line, `validate`). `Night.resolve_xp` checks a waiting
  class before `level_up`; new `Night.level_lines` and `Night.resolve_canon_keys` (step 5b). `Director._fire` runs
  `boon` hooks (outcome stays, history `"boons"`, no `"by"`); `_player_hook` skips them. `_record_matches` is now
  public `Director.record_matches` (trials use it). `_apply_effects` takes `db` now.
- `rules.json` `levels.breakthrough` added (ADR numbers). No class has a `breakthrough` block yet; no canon hook
  uses `boon` yet. That is M22.2.
- Tests run (all pass): `unit_breakthrough` (new, 16), `unit_levels`, `unit_class_system`, `unit_night`,
  `unit_director`, `unit_canon_db`, `unit_player_hooks`, `unit_data_db`, `sim_canon_book1`; Python 107 OK;
  validator 0 errors. Full suite not run.
- Next: M22.2 data **[Sonnet · medium]**: trials + hints in `game/data/classes.json` for inn, cook, warrior, runner,
  mage, scout, priest, crafter; a few `boon` hooks (Books 1 – 3). Run `unit_breakthrough` (real-data test),
  `unit_data_db`, the validator, Python tests and `sim_canon_book1..3`.
- Gotchas: the Python validator only checks the `breakthrough` shape; class and tag ids are checked by
  `Breakthrough.validate` (in `DataDb.load_dir`). Toy capstone is 3, so toy classes wait at level 2.
  A heredoc `\` + newline lost the backslash in a Python patch: use the Edit tool for GDScript line breaks.

## Just done (2026-10-09, local): M22.0 breakthrough design (branch `docs/m22.0-breakthrough-design`)
- ADR `docs/adr/0035-breakthroughs.md`. User picks: all three sources (hard moment, class trial, canon `boon` hook),
  a moment counts only at level 9 / 19 / 29 (key kept until XP fills), a vague hint line. Docs only, no tests run.
- Schema changes the user approved (build them in M22.1): `rules.json` `levels.breakthrough`; optional `classes.json`
  `breakthrough` {hint, default, trials}; hook `"then": "boon"` (event runs as canon, no drift, hook effects apply);
  hook effect `breakthrough` {tags | class}. No save change.
- Next: M22.1 engine **[Opus · medium]**. Files: new `core/breakthrough.gd`, `core/night.gd` (step 2 check, step 5b
  level again), `core/director.gd` + `core/canon_db.gd` (boon), `core/data_db.gd` + `tools/validate_data.py` (checks).
- Gotchas: the director runs AFTER `resolve_xp`, so a canon key needs the step-5b `level_up`. A `change` hook adds
  0.25 drift; that is why `boon` is a new hook result. Records already store `risk`, `duress`, `window`.

## Just done (2026-10-09, local): M21.4 NPC art (branch `feat/m21.4-npc-art`)
- 35 new looks at the end of `game/data/appearance.json` (all Book 6 – 7 NPCs with a schedule that had none) and their sheets in `game/assets/characters/`. Portraits are cut from the sheets. `unit_art` and `unit_portrait` pass. Most looks are guesses (noted per look). The LPC clone was in the scratchpad (gone later). CREDITS.md was rewritten by the builder.
- Next: M21.6 play pass (user), then M22.0 (user picks how a breakthrough is earned).

## Just done (2026-10-09, local): M21.4 full suite (branch `fix/m21.4-red-tests`)
- Full run: 166 scripts, 6 red. Fixed 4: `sim_player_hooks` (68), `unit_cover` (bones half cover; estate plaque not solid), `unit_sign_art` (plaque sign), `unit_portal` (links form). Still red: `unit_art`, `unit_portrait` (35 NPCs have no sheet, 10 or so no portrait; list in the test output). User chose to make the art (option 2).
- Next: build the missing character sheets and portraits (needs the LPC clone, about 240 MB: ask the user first).

## Just done (2026-10-09, local): M21.5 (branch `docs/m21.5-legal`)
- Read https://wanderinginn.com/fanworks-permissions/ . Result in `docs/DESIGN.md` §7 and `docs/ITCH.md` ("Policy check"). Docs only.
- Open for the user: the policy bans book titles in marketing material; ask pirateaba or reword the itch.io and README text.

## Just done (2026-10-09, local): M21.3 (branch `chore/m21.3-export-cleanup`)
- Deleted local v0.1.0 – v0.1.2 builds in `export/` (still on GitHub releases). v0.1.3 files, `android/` and `itch/` kept. Docs only.
- Next: M21.4 (full suite; user asks), M21.5 (legal), M21.6 (play pass).

## Just done (2026-10-09, local): M21.2 (branch `chore/m21.2-docs`)
- README counts fixed (1,089 events, 296 NPCs, 122 places, 50 maps, 166 GUT scripts, 105 Python tests). Old detail from `progress.md` and `handoff.md` moved to `docs/PROGRESS_ARCHIVE.md`. Gotchas were not deduped.
- Next: M21.3 (delete old builds in `export/`; user confirms), M21.4 (full suite; user asks), M21.5 (legal, user).

## Just done (2026-10-09, local): M21.1 (branch `chore/m21.1-consolidation-decision`)
- Decision: 565bc9b is not merged now. Redo it in M22.3. Branch `feat/class-tree-wiki` stays as the source. Docs only.
- Next: M21.2 (docs cleanup).

## Just done (2026-10-09, local): M21.0 (branch `chore/m21.0-housekeeping`)
- Committed the stray `.uid`; deleted 39 merged local branches. Only `main` and `feat/class-tree-wiki` (unmerged, M21.1) remain. No tests needed (no code).
- Next: M21.1 (user decides on 565bc9b), then M21.2 docs. M22.0 needs a user design pick.

## Just done (2026-10-08, local): full project audit (read-only, branch `feat/magnolia-npcs`, PR 137 already merged)
- Findings are in `progress.md` "Audit". No code or data changed. Memory `targeted-tests` updated to match CLAUDE.md.
- Biggest bug: capstone level 10 is unreachable in play (no breakthrough source except the debug console). Check: `grep -rn grant_breakthrough game --include=*.gd`.
- Biggest vision gap: Books 2–7 events only `cancel` on failure; few hooks. The director cannot patch the story after Book 1.
- 2026-10-09: on `main`, pulled (at 1a94073). Findings are now modules M21 – M26 in `docs/ROADMAP.md` "Audit work".
  These ROADMAP / progress / handoff edits are NOT committed yet: commit them on a branch (`docs/audit-modules`) with M21.0.
- Next: start M21.0 (stray .uid, merged branches), then M22.0 (user picks how a breakthrough is earned).
- 2026-10-09: PR 138 merged. Each roadmap step M21 – M26 now ends with `[Model · effort]` (branch `docs/roadmap-model-tags`).
  The user runs Sonnet · medium by default; tell them to switch when a step says Opus or another effort.
- 2026-10-09: `docs/ROADMAP.md` reordered (branch `docs/roadmap-open-first`): "Next up" (M21 – M26) first, then "Open: waits on a user
  check" (M20, Releases), Later, then "Done (newest first)" M19 … M0. No line text changed. When a milestone is fully ticked, move it to the top of Done.


### progress.md: class tree, north road, Invrisil, estate (2026-10-07/08)
- [ ] Class tree from the wiki (branch `feat/class-tree-wiki`, 2026-10-07, local). Step 1 done: 6 advancement classes on today's tags
  (`veteran_warrior`, `exemplar_warrior`, `scout`, `veteran_scout`, `elementalist`, `cryomancer`) + 7 passive Skills. Advancements use
  `prereqs.classes` (no schema change; the base class stays). Tests run: `unit_data_db`, `unit_class_system`, `unit_skill_system`,
  `unit_levels`, `unit_journal`, `unit_system_messages`, `sim_decline`, validator, Python tool tests (105). All pass. Full suite not run.
  - [x] Step 2 (2026-10-07, local): tags `riding`, `animals`, `gardening`, `faith`; actions `ride_horse`, `tend_animals`, `tend_garden`, `pray`
    (sounds reuse `creak`, `pick_up`, `chime`); map objects on existing art: `garden_bed` (inn_hill), `hitching_post` and `stable_yard` (celum_gate),
    `wayside_shrine` (celum_square); classes `rider`, `gardener`, `beast_tamer`, `acolyte`, `priest`, `bishop`, consolidations `dragoon`
    (warrior+rider, cost 2) and `druid` (gardener+beast_tamer+mage, cost 3); 8 passive Skills. Tests run: `unit_class_tree_step2` (new, 4),
    `unit_data_db`, `unit_tags`, `unit_actions`, `unit_audio_data`, `unit_sound_cues`, `unit_map_db`, `unit_ground_art`, `unit_class_system`,
    `unit_skill_system`, `unit_world_view`, `sim_winter`, validator, Python tool tests (105). All pass. Full suite not run.
  - [x] Step 3 (2026-10-08, local; branch `feat/class-tree-step3`): classes `hunter`, `archer`, `alchemist`, `blacksmith`, `teacher`, advancements `knight` (after `exemplar_warrior`) and `assassin` (after `rogue`); 8 passive Skills. Existing tags only, no new actions or objects. Tests run: `unit_class_tree_step3` (new, 3), `unit_class_tree_step2`, `unit_data_db`, `unit_class_system`, `unit_skill_system`, `unit_levels`, `unit_journal`, validator. All pass. Full suite not run.
  - [ ] The user plays: do the new objects feel right? Later steps could add NPC users of these classes.
  - Skipped on purpose: Erin/NPC-unique classes (Rocksoup Cook, Wandering Innkeeper, Goblinfriend Innkeeper), Skeleton, Bandit, Necromancer lines.
- [x] North road (2026-10-08, local; branch `feat/invrisil-road`): maps `celum_north_gate`, `road_to_invrisil` (camp), `invrisil_gate`, `invrisil_square`; `celum_main_street` got a north exit; `riverfarm` got its road to the Invrisil gate (west edge). Times 1500 / 3100 / 900 min (guess). Data only. Tests run: `unit_north_road` (new, 5), `unit_map_db`, `unit_audio_data`, `unit_ambience`, `unit_ground_art`, `unit_world_view`, `unit_gated_exits`, `unit_other_maps`, `unit_travel`, `unit_travel_prompt`, `sim_book7_riverfarm` (updated), validator, Python tool tests (105). All pass. Full suite not run. The user walks it (`godot --path game`, Celum main street north).
- [x] Invrisil city (2026-10-08, local; branch `feat/invrisil-city`): `invrisil_main_street` (north of the square) with `invrisil_runners_guild` (parcel board), `invrisil_crag_pig` (inn, bed 10, shop `crag_pig`), `invrisil_merchants_guild` (shop `invrisil_merchants`, truth-stone plaque); square stall `invrisil_stall`. Hedault's house is a closed plaque. Data only; layouts, prices and stock are guesses. Tests run: `unit_north_road` (now 7), `unit_map_db`, `unit_economy`, `unit_audio_data`, `unit_ambience`, `unit_ground_art`, `unit_world_view`, `unit_other_maps`, `unit_data_db`, `sim_celum_trip`, validator, Python tool tests (105). All pass. Full suite not run. The user walks it.
- [x] Invrisil staff (2026-10-08, local; branch `feat/invrisil-staff`): behaviour for canon NPCs `merec` (Merchants' Guild, 8-18) and `raisha` (gnoll guard, `invrisil_gate`, 6-20); off-map place `invrisil`. Posts are guesses; no art (square markers). The Invrisil Runners' board already had `deliver_parcel`. Tests run: `unit_north_road` (now 8), `unit_behaviour_db`, `unit_npc_sim`, validator. All pass. Full suite not run.
- [x] Magnolia's estate (2026-10-08, local; branch `feat/magnolia-estate`): maps `magnolia_estate_grounds` and `magnolia_estate_hall` (chess table, hearth); `invrisil_gate` got an east exit (20 min, guess). Layout and direction are guesses; no golems, no NPCs, no events. Tests run: `unit_north_road` (9), `unit_map_db`, `unit_audio_data`, `unit_ambience`, `unit_ground_art`, `unit_world_view`, `unit_other_maps`, `unit_gated_exits`, `unit_data_db`, `unit_travel`, validator, Python tool tests (105). All pass. Full suite not run.
- [x] Estate NPCs (2026-10-08, local; branch `feat/magnolia-npcs`): behaviour for `magnolia_reinhart` (hall 10-20), `ressa`, `reynold` (hall 6-22), new canon records `reinhart_golem_west` / `_east` (book2, confidence likely; guard posts on the grounds, always). Off-map place `magnolia_estate`. Magnolia's whereabouts in other books (Celum, road) are not tracked: the sim shows her at the estate by day, a guess. No art (square markers). Tests run: `unit_north_road` (10), `unit_behaviour_db`, `unit_npc_sim`, `unit_canon_db`, `sim_canon_book1` - `3`, `sim_book6_world`, validator, Python tool tests (105). All pass. Full suite not run.

### progress.md: M21 - M26 test lists
- [x] M21 Housekeeping (M21.0 – M21.6 done 2026-10-11) · [x] M22 Breakthroughs (M22.0 – M22.4 done) · [x] M23 Canon bends (M23.0 – M23.7 done; M23.7: morning reminder line at high drift, `SystemMessages.DRIFT_REMINDER`; tests `unit_system_messages` 18, `unit_journal`, `unit_director` pass; full suite not run) · [x] M24 Level by living (M24.3 done 2026-10-11: 63 rare Skills in `skills.json`, every class has a rare one for level 10 (pool 10 – 30) and a second for level 20 (pool 20 – 30); 4 are combat actions (`crushing_blow`, `lance_strike`, `backstab`, `trampling_charge`), the rest are passive stat / XP bonuses; data only; tests `unit_m24_skills` (new, 3), `unit_data_db`, `unit_class_tree_step2`, `unit_skill_system`, `unit_combat_skills`, `unit_class_system`, `unit_levels`, `unit_stats`, `unit_night`, `unit_breakthrough`, `unit_mana`, `unit_journal`, `unit_class_tree_step3`, validator 0 errors; full suite not run. M24.2 done 2026-10-11: spell `gust`, 4 spellbooks on sale at the Mages' Guild shelf; data only; tests `unit_m24_spells` (new, 4), `unit_spell_learning`, `unit_spells`, `unit_spell_ui`, `unit_economy`, `unit_map_db`, `unit_ground_art`, `unit_data_db`, `unit_behaviour_db`, `unit_npc_sim`, validator 0 errors; full suite not run. M24.1 done 2026-10-11: recipes `pizza`, `roast_meat`, `vegetable_soup`; shop `liscor_smith` with 3 held weapons; data only; tests `unit_m24_goods` (new, 3), `unit_cooking`, `unit_world_view` (stove menu 8), `unit_economy`, `unit_class_actions`, `unit_audio_data`, `unit_sound_cues`, `unit_map_db`, `unit_ground_art`, `unit_bag`, `unit_combat_db`, `unit_data_db`, `unit_tags`, `unit_actions`, validator 0 errors, Python 114 OK; full suite not run. M24.0 done 2026-10-11: actions `hunt`, `shoot_bow`, `brew_potion`, `forge_tool`, `teach_lesson` + 5 map objects + sounds; data only; tests `unit_class_actions` (new, 3), `unit_class_tree_step2`, `unit_class_tree_step3`, `unit_actions`, `unit_tags`, `unit_audio_data`, `unit_sound_cues`, `unit_map_db`, `unit_ground_art`, `unit_world_view`, `unit_gated_exits`, validator 0 errors, Python 114 OK; full suite not run) · [x] M25 NPC life (M25.0 done 2026-10-12: canon NPCs level once a day through the player's curve, `core/npc_levels.gd`, ADR 0038; `world.npc_levels`, save v21 + migration; rules `npc.levels` unknown_level 12, daily_xp 12, event_xp 50 (guesses); a canon event gives the capstone key; later-book NPCs start on their book's first day (`CanonDb.book_start`); debug console `npclevels <npc>`; tests `unit_npc_levels` (new, 12), `sim_npc_levels` (new, 6), `unit_game_state`, `unit_mana`, `unit_director`, `unit_canon_db`, `unit_console`, `unit_save_slots`, `sim_canon_book1`, validator book1 0 errors; full suite not run. M25.1 done 2026-10-12: talk topics, `core/talk_topics.gd`, ADR 0039; on the first talk of the day an NPC says one topic: own / town news of the last 5 days, T1 rumours, or a `data/talk.json` topic (11 canon news/rumours for Books 1 - 2, 6 request hints); request hints only, no save change; `rules.talk`; toy dbs have no talk; tests `unit_talk_topics` (new, 6), `unit_standing`, `unit_data_db`, `unit_npc_sim`, the 27 sims that talk through Interact (all pass), validator book1 0 errors, Python 116 OK; full suite not run. M25.2 done 2026-10-12: 3 paid job actions (`take_guild_job` 6-12, `tally_ledgers` 4-8, `haul_goods` 3-5, all guesses) on 4 boards: Liscor Adventurers' Guild, Invrisil Merchants' Guild (new `contract_board`), Invrisil square, Celum square (new `celum_job_board`); data only; tests `unit_m25_job_boards` (new, 3), see handoff; full suite not run. M25.3 done 2026-10-12: NPC character sheets, `core/npc_sheet.gd`; an "Appraise" row on an NPC (needs the Skill [Appraisal], `rules.npc.appraisal_skill`); classes + levels, `?` if unknown, no total; tests `unit_npc_sheet` (new, 6) + list in handoff; full suite not run. M25.4 done 2026-10-12: Magnolia's whereabouts by canon flags, data only (`npc_behaviour.json`): Magnolia + Ressa off map in Celum until `magnolia.gone_north`, road (@north_izril) until `magnolia.watches_the_inn`, estate, away (@north_izril) from `magnolia.gone_to_first_landing` until `magnolia.sends_gold_to_esthelm`; Rose, Imani, Joseph on the estate maps by day from `magnolia.hides_other_earthers`; tests `unit_m25_whereabouts` (new, 5), `unit_north_road`, `unit_behaviour_db`, `unit_npc_sim`, `sim_book3_stages`, `sim_book4_homecoming`, `sim_book6_silver_swords`, `sim_book6_zel_dies`, `sim_book7_riverfarm`, `sim_canon_book1`, `sim_canon_book3`, `sim_npc_levels`, `unit_talk_topics`, validator book1 0 errors; full suite not run) · [x] M26 Code health (M26.1 done 2026-10-13: `world_view.gd` split, 1285 -> 335 lines; static `ViewArt` + RefCounted `ViewMap`, `ViewMarkers`, `ViewEffects` in `game/world/`; public names stay on WorldView as pass-ons; `GroundArt`, `SignArt`, `CombatOverlay` now name `ViewArt` (script cycle); ADR 0041; no behaviour change, no test change; tests `unit_world_view`, `unit_anim`, `unit_atmosphere`, `unit_ambience`, `unit_audio`, `unit_combat_screen`, `unit_cover_ui`, `unit_crowd`, `unit_gated_exits`, `unit_ground_art`, `unit_guests`, `unit_monster_art`, `unit_rains`, `unit_sign_art`, `unit_skill_bar`, `unit_spell_ui`, `unit_touch_controls`, `unit_traps`, `unit_ui_scale`, `unit_brawl`, `unit_play_loop`, `sim_m4_done`, `sim_m5_done`, `sim_m6_done` pass; `unit_art` had 1 old fail (Imani, Joseph, Rose had no own look), fixed 2026-10-13 with own sheets (`appearance.json` guesses + built art; `unit_art` 11/11); full suite not run. M26.0 done 2026-10-13: `main.gd` split, 967 -> 499 lines; `class_name MainScreen` keeps commands + replay; new RefCounted helpers `MainInput`, `MainAim`, `MainTravel`, `MainPanels` in `game/world/`; every member tests use stays on MainScreen as a pass-on call; ADR 0040; no behaviour change, no test change; tests `sim_m4_done`, `sim_m5_done`, `sim_m6_done`, `unit_bag`, `unit_brawl`, `unit_combat_screen`, `unit_cover_ui`, `unit_hud_log`, `unit_input_actions`, `unit_music_pick`, `unit_no_xp_shown`, `unit_play_loop`, `unit_skill_bar`, `unit_spell_ui`, `unit_system_messages`, `unit_touch_controls`, `unit_travel_prompt`, `unit_ui_scale`, `unit_world_view`, `unit_console` all pass; full suite not run)

### progress.md: M22 / M23 test lists
- [ ] Divergence is thin: Books 2–7 have 0 `substitute` / `delay` / `mutate` fallbacks (all 838 events are `cancel` only); 67 of 1089 events have hooks (Book 2: 3 of 207).
  - [x] M23.0 (2026-10-10, branch `feat/m23.0-divergence-report`): tool + picks. `tools/divergence_report.py` + `test_divergence_report` (7); report in `docs/divergence/report.md`. Python 114 OK. Finding: Books 2 – 4 hang on one long `depends_on` chain (one Horns event in Book 2 has 113 dependents); Erin's death loses 140 of 207 Book 2 events. User rule: top 5 NPCs + top 3 events per book (`docs/divergence/picks.md`). Next: M23.1 Book 2.
  - [x] M23.1 Book 2 (2026-10-10, branch `feat/m23.1-book2-bends`, ADR 0036): story-order `depends_on` cut, substitutes (Klbkch rescue, Relc warning), 3 alt events (Horns short-handed, Goblin Lord army, Erin winters in Liscor), flag hand-off + delay, 19 `change` hooks (all 22 on-map days hooked). Director: an alt reached by propagation waits for its own day. Book 2 lost on a day-41 death: Erin 140 → 109, Ryoka 76 → 64, Toren 77 → 57, Rags 42 → 27, Ceria 42 → 25, Pisces 30 → 13, Yvlon 7 → 4. Tests: `sim_kill_book2` (new, 10), `unit_director` (26), `sim_divergence`, `sim_canon_book1`, `sim_canon_book2`, `sim_canon_book3`, `sim_book2_end_stages`, `sim_player_hooks` (count 93), `unit_canon_db`, validator 0 errors / 0 warnings, Python 114 OK. Full suite not run.
  - [x] M23.2 Book 3 (2026-10-10, branch `feat/m23.2-book3-bends`, ADR 0036 "Book 3"): story-order links cut, real-cause flags (Remendia, Ocre bank, Klbkch's praise, street battle), 1 substitute (Ceria digs up the Albez door), 9 alt events, flag hand-offs + delay, 13 `change` hooks (all 23 on-map days hooked). Director: a dependent waits while its dependency is delayed (`_wait_until`). Book 2 Goblin raid no longer needs Ksmvr (day-41 death: Book 3 lost 40 → 1). Book 3 lost on a day-72 death: Erin 52 → 27, Octavia 49 → 4, Ceria 40 → 30, Pisces 39 → 9, Lyonette 34 → 19, Yvlon 33 → 3, Ksmvr 31 → 1. Tests: `sim_kill_book3` (new, 11), `unit_director` (27), `unit_canon_db`, `sim_player_hooks` (106), `sim_canon_book1..4`, `sim_book3_finale`, `sim_book3_stages`, `sim_book4_relief_home`, `sim_esthelm_siege`, `sim_divergence`, `sim_book2_end_stages`, `sim_kill_book2`, validator 0 / 0, Python 114 OK. Full suite not run.
  - [x] M23.3 Book 4 (2026-10-10, branch `feat/m23.3-book4-bends`, ADR 0036 "Book 4"): data only, no engine change. Trip, homecoming, party and relief links cut (hand-offs on `erin.on_wagon_south`, `horns_of_hammerad.left_celum`, `erin.home_at_the_inn`, `erin.level_30`), real-cause flags (Antinium at Esthelm, the door for Celum trips), 5 alt events (Pawn leads Mrsha out of the Hive, the wagon / the Horns hide from the Goblin army, home without the door, Liscor-only relief wagons), 2 delay hand-offs, 4 hooks (all 9 on-map days hooked). Book 4 lost on a day-85 death: Erin 85 → 55, Zel 83 → 14, Ceria 85 → 15, Teriarch 83 → 2, Klbkch 77 → 6, Lyonette 79 → 5, Pisces 85 → 11. Tests: `sim_kill_book4` (new, 10), `sim_kill_book3` (2 asserts now check the Book 4 hand-off), `sim_kill_book2`, `sim_player_hooks` (110), `unit_canon_db`, `sim_divergence`, `sim_canon_book3..7`, `sim_book4_christmas`, `sim_book4_homecoming`, `sim_book4_mrsha`, `sim_book4_relief_home`, `sim_book4_wistram`, validator 0 / 0, Python 114 OK. Full suite not run.
  - [x] M23.4 Book 5 (2026-10-11, branch `feat/m23.4-book5-bends`, ADR 0036 "Book 5"): data only, no engine change. Hand-off flags (`earthers.joined_the_last_light`, `bird.to_guard_the_inn`, `azkerash.servants_in_liscor`, `ryoka.seized_by_the_necromancers_servants`), 2 substitutes (Etretta for Quallet at the valley, Ijvani for Venitra in the Word of Death), 9 alt events, Lyonette optional in 3 inn scenes, 4 hooks (all 16 on-map days hooked). Book 5 lost on a day-97 death: Ryoka 34 → 31, Erin 30 → 30, Laken 15 → 15, Venitra 30 → 20, Lyonette 12 → 8; day 78: Ken 7 → 3, Quallet 6 → 0. Tests: `sim_kill_book5` (new, 10), `sim_canon_book5` (2 tests changed), `sim_book5_geneva` (1 test changed, alts left out of the arc list), `sim_player_hooks` (114), `sim_book5_creler_nest`, `_last_light`, `_pawns_faith`, `_rift_undead`, `_ryoka_home`, `_soups`, `unit_canon_db`, `sim_divergence`, `sim_canon_book6`, `sim_canon_book7`, `sim_kill_book4`, validator 0 / 0 (Books 1 – 7), Python 114 OK. Full suite not run.
  - [x] M23.5 Book 6 (2026-10-11, branch `feat/m23.5-book6-bends`, ADR 0036 "Book 6"): data only, no engine change. Real-cause flags: the Battle of Invrisil and the trap wait on the alliance, the speech, the attack order and each other; the Redfang move into the inn only if they met Erin. 1 substitute (Zevara signs the rat contract), 9 alt events, the five Chosen optional in the trap, Oom no longer gates Zel's end, 9 hooks (all 15 on-map days hooked), 3 Riverfarm map objects got actions. Book 6 lost on a day-114 death: Zel 25 → 35, Magnolia 17 → 36, Goblin Lord 16 → 27, Erin 14 → 22 (those scenes ran without their cause before), Olesm 13 → 7, Oom 9 → 1. Tests: `sim_kill_book6` (new, 9), `sim_kill_book5` (Erin drift ceiling 31 → 33.5), `sim_player_hooks` (123), `sim_canon_book6`, `sim_book6_*` (7 scripts; `sim_book6_world` had a stale Dasha look assert, fixed), `unit_canon_db`, `sim_divergence`, `unit_event_order`, `sim_canon_book7`, `unit_map_db`, `unit_north_road`, `sim_book7_riverfarm`, validator 0 / 0 (Books 1 – 7), Python 114 OK. Full suite not run.
  - [x] M23.6 Book 7 (2026-10-11, branch `feat/m23.6-book7-bends`, ADR 0036 "Book 7"): data only, no engine change. Book 7 had almost no cause links, so most scenes ran with their cause gone. Real-cause flags now: the Pallass door chain, the inn's moth fight (`wandering_inn.fought_the_moths`), the wall and parade (`liscor.face_eater_moths_attacked`, `liscor.moths_driven_back`), Zel's will and funeral, the Heartflame (`heartflame.selys_inherits`), Selys's kidnap, Magnolia's letter / test / nobles, the Redfang five (`redfang.in_the_inn`, a Book 6 flag). Rain and flood no longer need Erin. 3 substitutes for Zevara (Relc ×2, Ilvriss, Tekshia), Zevara optional in 8 scenes, 10 alt events, kill-link cut (rout follows the scout, not Kerrig), 5 hooks (all 14 on-map days). Book 7 lost on a day-130 death: Erin 38 → 51, Laken 26 → 26, Selys 18 → 25, Zevara 17 → 5, Rags 14 → 14, Magnolia 0 → 12, Kerrig 5 → 3. Erin dead on day 114: Book 7 lost 38 → 64. Tests: `sim_kill_book7` (new, 10), `sim_book7_goblin_road` (alts left out of the batch count), `sim_player_hooks` (128), `sim_canon_book7`, `sim_book7_*` (8), `unit_rains`, `unit_canon_db`, `unit_event_order`, `sim_divergence`, `sim_kill_book2..6`, validator 0 / 0 (Books 1 – 7), Python 114 OK. Full suite not run.

### ROADMAP.md: long step notes for M23 – M25 (short form kept in the roadmap)
- [x] M25.0 NPCs level at low detail through the same System (DESIGN §4.5); save change + migration **[Opus · high]** (2026-10-12, ADR 0038: `NpcLevels`, save v21, `rules.npc.levels`, console `npclevels <npc>`)
- [x] M25.1 Talk topics: NPCs share news, rumours and requests (short summaries in our words, from events and flags) **[Opus · medium]** (2026-10-12, ADR 0039: `TalkTopics`, `data/talk.json`, `rules.talk`; request hints only, no save change)
- [x] M25.2 Job boards in more places (Liscor Adventurers' Guild, Invrisil, Celum Merchants) **[Sonnet · medium]** (2026-10-12: `take_guild_job`, `tally_ledgers`, `haul_goods`; 4 boards; data only)
- [x] M25.3 Character sheets for Merec, Raisha and the estate NPCs **[Sonnet · medium]** (2026-10-12: any canon NPC, read with [Appraisal]; `NpcSheet`, "Appraise" menu row; ADR 0038 note)
- [x] M25.4 Magnolia's real whereabouts by flags (Celum in Book 1, the road, the estate); the Earth transplants' stay (2.37) **[Opus · medium]** (2026-10-12: data only, `npc_behaviour.json`: Magnolia and Ressa off map in Celum until `magnolia.gone_north`, on the road until `magnolia.watches_the_inn`, the estate, away in the north from `magnolia.gone_to_first_landing` until `magnolia.sends_gold_to_esthelm`; Rose, Imani, Joseph on the estate maps by day from `magnolia.hides_other_earthers`)
- [x] M24.0 Actions for the new classes: hunt, shoot a bow, brew a potion, forge, teach; with map objects or stations on existing art **[Sonnet · medium]** (done 2026-10-11: actions `hunt`, `shoot_bow`, `brew_potion`, `forge_tool`, `teach_lesson`; objects `hunting_blind` (floodplains_south), `archery_target` (inn_hill), `brewing_cauldron` (liscor_mages_guild), `smiths_forge` (liscor_market), `lesson_slate` (inn_interior); sounds reuse existing cues)
- [x] M24.1 Recipes and goods: more dishes from the Books (canon names, numbers are guesses), tools and weapons in shops **[Sonnet · medium]** (done 2026-10-11: recipes `pizza`, `roast_meat`, `vegetable_soup` + actions; shop `liscor_smith` at `smith_counter` (liscor_market) sells `wooden_club`, `iron_dagger`, `hand_axe`; numbers are guesses)
- [x] M24.2 Spells: more spells from Books 1 – 7 with teachers and spellbooks **[Sonnet · medium]** (done 2026-10-11: spell `gust` (Pisces teaches, 1.22); spellbooks for `gust`, `ice_spike`, `flashfire`, `frozen_wind` (and `fireball` now has a price) sold at `spell_shelf` in liscor_mages_guild, shop `liscor_mages_guild`; Pisces casts `gust` as a fallback. Only attack shapes fit the engine, so [Ice Wall], [Barrier of Air], [Mend] and [Light] wait for an engine step)
- [x] M24.3 Skills: capstone Skills at 10 / 20 for the main classes; Skills for the class-tree step 1 – 3 classes that have none **[Sonnet · high]** (done 2026-10-11: 63 rare Skills in `skills.json`: every class has a rare Skill for level 10 (pool 10 – 30) and a second for level 20 (pool 20 – 30); 4 are combat actions (`crushing_blow`, `lance_strike`, `backstab`, `trampling_charge`); the rest are passive stat / XP bonuses; names and numbers are guesses; no schema or engine change)
- [x] M23.0 Tool + list: `tools/divergence_report.py` (per book: roles, fallbacks, hooks, events that depend on one NPC); the user picks the key NPCs and key events per book (user) **[Sonnet · medium]** (done 2026-10-10: report in `docs/divergence/report.md`; user rule: top 5 NPCs + top 3 events per book, in `docs/divergence/picks.md`)
- [x] M23.1 Book 2: roles with `fallback_tags`, `substitute` / `delay` / `mutate` on the key events, more hooks; `sim_kill_book2` (a key NPC dies, the book still runs and drift is sane) **[Opus · high]** (done 2026-10-10, ADR 0036: story-order links cut, 2 substitutes, 3 alt events, flag hand-off + delay, 19 hooks (one per on-map day), director runs an alt on its own day; Erin's death loses 109 events, was 140)
- [x] M23.2 Book 3: the same **[Opus · high]** (done 2026-10-10, ADR 0036 "Book 3": links cut, real-cause flags, 1 substitute, 9 alt events, flag hand-offs with delay, 13 hooks (one per on-map day), director lets a dependent wait on a delayed dependency; Book 2 Goblin raid no longer needs Ksmvr; Octavia's death loses 4 events, was 49)
- [x] M23.3 Book 4: the same **[Opus · high]** (done 2026-10-10, ADR 0036 "Book 4": trip, homecoming and relief links cut, trip-flag hand-offs, 5 alt events (Pawn in the Hive, the wagon hides from the Goblin army, home without the door, Liscor-only relief), 4 hooks (all 9 on-map days); Teriarch's death loses 2 events, was 83)
- [x] M23.4 Book 5: the same **[Opus · high]** (done 2026-10-11, ADR 0036 "Book 5": hand-off flags, 2 substitutes (Etretta for Quallet, Ijvani for Venitra), 9 alt events (Luan and Aiko go to Geneva, Erin pays for the build, Imenet comes alone, the Necromancer still turns to the Goblins, the Gnolls burn Brunkr, Riverfarm without Laken), 4 hooks (all 16 on-map days); Venitra's death loses 20 events, was 30; Quallet's loses 0, was 6)
- [x] M23.5 Book 6: the same **[Opus · high]** (done 2026-10-11, ADR 0036 "Book 6": real-cause flags for the Battle of Invrisil and the Redfang at the inn, 1 substitute (Zevara signs the rat contract), 9 alt events (no Zel: the Goblin Lord goes round Invrisil; no Magnolia: Zel stays in Liscor; no Goblin Lord: Zel hunts the raiders; no Erin: the Redfang go north), the five Chosen optional in the trap, 9 hooks (all 15 on-map days); Olesm's death loses 7 events, was 13; Oom's 1, was 9)
- [x] M23.6 Book 7: the same **[Opus · high]** (done 2026-10-11, ADR 0036 "Book 7": real-cause flags for the Pallass door, the inn's moth fight, Zel's will, Selys's kidnap, Magnolia's gathering and the Redfang five (Book 6 flag); rain and flood no longer need Erin; 3 substitutes for Zevara (Relc, Ilvriss, Tekshia), 10 alt events (no Erin: Liscor fights the moths alone; no Selys: the armour goes to Magnolia; no Laken: Durene and Tessia keep Riverfarm going; no Magnolia: Laken feeds his own villages; no Rags: Pyrite leads the tribe), 5 hooks (all 14 on-map days); Zevara's death loses 5 events, was 17; Erin's 51, was 38)
- [x] M23.7 Drift warning: at high drift the journal and the morning page say canon knowledge is unreliable (DESIGN §4.1) **[Sonnet · medium]** (done 2026-10-11: the journal line and the one-time warning page already existed; added a morning reminder line every day at high drift)
- [x] M21.6 Play pass: one session that closes the open "the user plays …" checks (fights, Book 6, rain, phone, touch stick, phone UI, long road, class objects, north road) and lists bugs (user) **[Sonnet · medium]** (done 2026-10-11: the user played all checks, all fine)
- [x] M22.0 Design + ADR: how a breakthrough is earned (canon moments, a hard fight with high duress, an `xp_window` event, a class's own trial) (user picks). Ask before the schema change **[Opus · high]** (done 2026-10-09: ADR 0035; user picked all three sources, from level 9, a vague hint; schema changes approved: `classes.json` `breakthrough`, hook `then: boon`, effect `breakthrough`, `rules.levels.breakthrough`)
- [x] M22.1 Engine: event effect `breakthrough` (director) + emergent triggers in the night pipeline; System message when it happens; no save change expected (`breakthroughs` is already saved) **[Opus · medium]** (done 2026-10-10: `core/breakthrough.gd`, night steps 2 and 5b, hook `boon`, checks in `DataDb` and the validator; `unit_breakthrough` 16 tests)
- [x] M22.2 Data: breakthrough sources for the main class lines (inn, cook, warrior, runner, mage, scout, priest, crafter) **[Sonnet · medium]** (done 2026-10-10: trials + hints on 8 classes in `classes.json`, 6 `boon` hooks in Books 1 – 3)
- [x] M22.3 Consolidation on top of breakthroughs (redo 565bc9b: M21.1 said yes; start from `git show 565bc9b`) **[Opus · medium]** (done 2026-10-10: automatic at night, a source class at level 10, so after its breakthrough; `consolidate_ready`, `rules.offers.consolidation_min_level`)
- [x] M22.4 A probe sim: a busy player passes level 10 in one class within the Book 1 – 3 days **[Sonnet · high]** (done 2026-10-10: `sim_breakthrough_probe`; busy inn level 10 on night 31 – 32, quiet inn on night 73, fighter on night 17 – 22; bar numbers kept)
