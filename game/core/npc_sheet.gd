## An NPC's character sheet as text lines (M25.3). Read-only and headless.
## The player sees it only with the Skill named in `rules.npc.appraisal_skill`
## ([Appraisal]). A canon level that is null shows as "?". The total level is
## never shown (like the player's).
class_name NpcSheet
extends RefCounted


## True if the player may read NPC sheets (holds the appraisal Skill).
static func can_read(gs: GameState, db: DataDb) -> bool:
	var skill := String(db.rules.get("npc", {}).get("appraisal_skill", ""))
	return skill != "" and gs.progression.has_skill(skill)


## Lines for `npc`; empty if the NPC is not in the canon data.
static func lines(gs: GameState, db: DataDb, npc: String) -> Array[String]:
	var out: Array[String] = []
	if not db.canon.npcs.has(npc):
		return out
	var rec: Dictionary = db.canon.npcs[npc]
	out.append("%s" % rec["name"])
	out.append("Race: %s." % String(rec.get("race", "?")))
	if not gs.world.is_alive(db.canon, npc):
		out.append("Dead.")
	out.append("")
	out.append("Classes:")
	var classes := NpcLevels.classes_of(gs, db, npc)
	if classes.is_empty():
		out.append("  None.")
	for c: Dictionary in classes:
		out.append("  %s level %s" % [c["name"], str(c["level"]) if c["known"] else "?"])
	return out
