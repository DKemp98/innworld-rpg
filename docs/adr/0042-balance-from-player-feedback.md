# ADR 0042: Balance from player feedback (M27)

Status: accepted (2026-10-15).

## Problem
A contributor played long games and reported four problems (paraphrased):
- Levels above 5 are hard to reach. A single-class [Warrior] took about 60 in-game days to reach level 10.
  A friend took every class and had 25 total levels after 300 days, with no class above level 5.
  Non-fight classes level much slower: they get no danger bonus, and repeating an action lowers its XP.
- Consolidation needs a level-10 source class, which is grindy.
- Selling 10 goods takes 10 times as long as selling one.
- One trip to Invrisil and back makes everyone in Liscor forget the player.

The code confirmed all four. The level cost follows the total level (ADR 0022, M17.7), so many classes do
not make levels cheaper. That rule stays. The repeat penalty fell to a 10% floor after a few days of the
same work. One sale took 5 minutes and made one action record per good. A relationship lost 1 point a
night after 7 days without contact, and "friend" starts at 6.

## Decision
All numbers are game balance (`confidence: guess`), not canon.
- **Levels (M27.0):** `rules.levels.base_xp` 40 -> 30, `growth` 1.25 -> 1.2 (late growth 1.12 above level 10
  stays). Level 10 costs 624 XP in all (was 1032); total level 25 about 6,400 (was about 12,100).
- **Repeat penalty (M27.0):** `rules.xp.novelty.k` 0.35 -> 0.2, `floor` 0.1 -> 0.3. Fights keep their danger
  and duress bonus, so a fighter still levels faster, but the gap is smaller.
- **Consolidation (M27.1):** `rules.offers.consolidation_min_level` 10 -> 5. This is below the level-10
  capstone, so a source class no longer waits for its breakthrough. The level cost of a consolidation (2 or
  3) stays; the new class is at least level 1. The contributor's example (Inkar) is after Book 1 and was not
  checked in the book text, so it is not used as canon.
- **Trade many (M27.2):** `Economy.buy/sell` take a count. A trade of n goods takes `trade_minutes +
  trade_extra_minutes x (n - 1)` (5 + 1 per extra good) and makes **one** action record. Buying needs coins
  for all; a meal eaten there or clothes are always one. Selling more than the bag holds sells all. The use
  menu adds "Sell all N" and "Buy 5" (`rules.economy.bulk_buy`) rows; menu picks carry the count after `#`
  (`sell:herbs#10`, `Interact.trade_action` / `trade_parts`). Console: `buy|sell <object> <good> [n]`.
  The two new `rules.economy` keys are optional (missing = old behaviour).
- **Forgetting (M27.3):** `rules.standing.decay_after_days` 7 -> 30, `reputation_decay_every` 3 -> 10.

## Results (balance sims, 3 seeds)
- `sim_balance_progress` (hard inn worker): level 5 on night 7 (was 9 - 10), total level 11 on day 22.
- `sim_balance_fighter`: total level 14 - 15 on day 22.
The sims' targets moved to match. These are scripted, very busy days; a real game is slower.

## Consequences
- Every class levels faster. If level 10+ now comes too fast, raise `base_xp` first.
- No save change: all of this is rules data and command arguments.
- The user still has to play it: do level 5 and level 10 come at a fair pace, does trading feel right?
