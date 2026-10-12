## Talk topics (M25.1, ADR 0039): on the first talk of the day an NPC shares one
## topic: recent news, a T1 rumour, or a topic from data/talk.json (news, rumour
## or a request hint). Hints only: a topic has no state and changes nothing.
##
## Pool, each with a weight from rules.talk.weights:
##   "own"   - news (gs.world.news, last rules.talk.news_days days) of an event
##             that cast this NPC by name;
##   "town"  - other local news of an event in the NPC's town (event location →
##             nearest settlement; NPC town from its canon home);
##   "rumor" - T1 rumours: anyone can pass them on;
##   "topic" - talk.json "news"/"rumor" topics whose gate passes;
##   "request" - talk.json "request" topics whose gate passes.
## A topic gate: "who" (any of "npcs", "tags", "towns" matches; empty = anyone),
## "flags", "not_flags", "days": [from, to]. An NPC whose regard is below
## rules.talk.min_regard says nothing. The pick uses gs.rng (CLAUDE.md rule 3).
class_name TalkTopics
extends RefCounted

const KINDS := ["news", "rumor", "request"]
const WEIGHTS := ["own", "town", "rumor", "topic", "request"]
const RULE_FIELDS := ["news_days", "min_regard", "weights", "line"]
const FIELDS := ["kind", "text", "confidence"]
const WHO := ["npcs", "tags", "towns"]


static func rules(db: DataDb) -> Dictionary:
	return db.rules.get("talk", {})


static func on(db: DataDb) -> bool:
	return not rules(db).is_empty()


## Every topic `npc` could share today: [{"source", "text", "weight"}], in a
## fixed order (news newest first, then talk.json ids sorted).
static func pool(gs: GameState, db: DataDb, npc: String) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	if not on(db) or not db.canon.npcs.has(npc):
		return out
	var r := rules(db)
	var w: Dictionary = r["weights"]
	var day := gs.clock.day()
	var town := npc_town(db, npc)
	var seen := {}
	for n: Dictionary in gs.world.news_since(day - int(r["news_days"]) + 1):
		var text := String(n["text"])
		if text == "" or seen.has(text):
			continue
		var source := ""
		if n["kind"] == Director.RUMOR:
			source = "rumor"
		elif _cast(gs, String(n["event"])).has(npc):
			source = "own"
		elif town != "" and event_town(db, String(n["event"])) == town:
			source = "town"
		if source != "":
			seen[text] = true
			out.append({"source": source, "text": text, "weight": int(w[source])})
	var ids: Array = db.talk.keys()
	ids.sort()
	for id: String in ids:
		var t: Dictionary = db.talk[id]
		if _passes(gs, db, t, npc, town):
			var source := "request" if t["kind"] == "request" else "topic"
			out.append({"source": source, "text": String(t["text"]), "weight": int(w[source]), "id": id})
	return out


## The line `npc` says about one topic from the pool, or "" (no topic, or the
## NPC does not like the player enough).
static func line(gs: GameState, db: DataDb, npc: String) -> String:
	if not on(db) or Standing.regard(gs, db, npc) < int(rules(db)["min_regard"]):
		return ""
	var p := pool(gs, db, npc)
	var weights: Array = []
	for t: Dictionary in p:
		weights.append(t["weight"])
	if p.is_empty() or weights.all(func(x: int) -> bool: return x <= 0):
		return ""
	var i := gs.rng.weighted_index(weights)
	return String(rules(db)["line"]) % [db.canon.npcs[npc]["name"], p[i]["text"]]


## The NPC's town: the nearest settlement at or above its canon home. "" if none.
static func npc_town(db: DataDb, npc: String) -> String:
	var home: Variant = db.canon.npcs.get(npc, {}).get("home", null)
	return "" if home == null else Standing.town_of_location(db, String(home))


## The town of a canon event's location. "" if none.
static func event_town(db: DataDb, event_id: String) -> String:
	var loc: Variant = db.canon.events.get(event_id, {}).get("location", null)
	return "" if loc == null else Standing.town_of_location(db, String(loc))


## Named NPCs cast in the event's run (world.events roles). npc → true.
static func _cast(gs: GameState, event_id: String) -> Dictionary:
	var out := {}
	for v: Variant in (gs.world.events.get(event_id, {}).get("roles", {}) as Dictionary).values():
		var vals: Array = v if v is Array else [v]
		for x: Variant in vals:
			var id := str(x) if x != null else ""
			if id != "" and not id.begins_with(Director.ANONYMOUS):
				out[id] = true
	return out


static func _passes(gs: GameState, db: DataDb, t: Dictionary, npc: String, town: String) -> bool:
	for f: String in t.get("flags", []):
		if not gs.flags.get(f, false):
			return false
	for f: String in t.get("not_flags", []):
		if gs.flags.get(f, false):
			return false
	var days: Array = t.get("days", [])
	var day := gs.clock.day()
	if days.size() == 2 and (day < int(days[0]) or day > int(days[1])):
		return false
	var who: Dictionary = t.get("who", {})
	if who.is_empty():
		return true
	if (who.get("npcs", []) as Array).has(npc) or (who.get("towns", []) as Array).has(town):
		return true
	var tags: Array = db.canon.npcs[npc].get("tags", [])
	return (who.get("tags", []) as Array).any(func(x: String) -> bool: return tags.has(x))


## Checks rules.talk and the talk.json topics. Returns the errors.
static func validate(db: DataDb) -> Array[String]:
	var errs: Array[String] = []
	if not on(db):
		return errs
	var r := rules(db)
	for f: String in RULE_FIELDS:
		if not r.has(f):
			errs.append("rules.talk: missing '%s'." % f)
	if not errs.is_empty():
		return errs
	for k: String in WEIGHTS:
		if not (r["weights"] as Dictionary).has(k) or int(r["weights"][k]) < 0:
			errs.append("rules.talk.weights: '%s' must be a number >= 0." % k)
	if int(r["news_days"]) < 1:
		errs.append("rules.talk.news_days must be >= 1.")
	if String(r["line"]).count("%s") != 2:
		errs.append("rules.talk.line needs two %s (name, text).")
	for id: String in db.talk:
		errs.append_array(_validate_topic(db, id, db.talk[id]))
	return errs


static func _validate_topic(db: DataDb, id: String, t: Variant) -> Array[String]:
	var errs: Array[String] = []
	var at := "talk '%s'" % id
	if not t is Dictionary:
		return ["%s: must be an object." % at] as Array[String]
	for f: String in FIELDS:
		if not (t as Dictionary).has(f):
			errs.append("%s: missing '%s'." % [at, f])
	if not errs.is_empty():
		return errs
	if not KINDS.has(t["kind"]):
		errs.append("%s: kind must be one of %s." % [at, KINDS])
	if not t["text"] is String or String(t["text"]).strip_edges() == "":
		errs.append("%s: text must be a non-empty string." % at)
	if not DataDb.CONFIDENCE.has(t["confidence"]):
		errs.append("%s: confidence must be one of %s." % [at, DataDb.CONFIDENCE])
	for f: String in ["flags", "not_flags"]:
		if t.has(f) and not (t[f] is Array and (t[f] as Array).all(func(x: Variant) -> bool: return x is String)):
			errs.append("%s: %s must be a list of strings." % [at, f])
	if t.has("days"):
		var d: Variant = t["days"]
		if not (d is Array and (d as Array).size() == 2 and int(d[0]) >= 1 and int(d[0]) <= int(d[1])):
			errs.append("%s: days must be [from, to] with 1 <= from <= to." % at)
	var who: Variant = t.get("who", {})
	if not who is Dictionary:
		errs.append("%s: who must be an object." % at)
		return errs
	for k: String in who:
		if not WHO.has(k) or not who[k] is Array:
			errs.append("%s: who.%s is not one of %s (lists)." % [at, k, WHO])
	for n: Variant in who.get("npcs", []):
		if not db.canon.npcs.has(n):
			errs.append("%s: unknown npc '%s'." % [at, n])
	for l: Variant in who.get("towns", []):
		if not db.canon.locations.has(l):
			errs.append("%s: unknown town '%s'." % [at, l])
	return errs
