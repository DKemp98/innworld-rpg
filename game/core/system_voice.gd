## The System's lines in the books' style (M29.0, ADR 0044): "[Innkeeper Level 2!]",
## "[Skill – Basic Cooking obtained!]", "[Innkeeper Class Obtained!]". Class and Skill names
## in data carry their brackets ("[Innkeeper]"); these lines take them off and frame the whole line.
class_name SystemVoice
extends RefCounted


## "[Innkeeper]" -> "Innkeeper". A name without brackets stays as it is.
static func bare(name: String) -> String:
	if name.begins_with("[") and name.ends_with("]"):
		return name.substr(1, name.length() - 2)
	return name


static func level_up(class_name_: String, level: int) -> String:
	return "[%s Level %d!]" % [bare(class_name_), level]


static func skill(skill_name: String) -> String:
	return "[Skill – %s obtained!]" % bare(skill_name)


static func class_obtained(class_name_: String) -> String:
	return "[%s Class Obtained!]" % bare(class_name_)


static func class_offered(class_name_: String) -> String:
	return "[%s Class Offered!]" % bare(class_name_)


static func class_lost(class_name_: String) -> String:
	return "[%s Class Lost.]" % bare(class_name_)


static func level_down(class_name_: String, from_level: int, to_level: int) -> String:
	return "[%s Level %d → Level %d.]" % [bare(class_name_), from_level, to_level]


## Consolidation (and the books' class changes): "[Conditions Met: Cook, Server → Innkeeper Class!]".
static func conditions_met(from_names: Array, to_name: String) -> String:
	return "[Conditions Met: %s → %s Class!]" % [", ".join(from_names.map(func(n: String) -> String: return bare(n))), bare(to_name)]


static func breakthrough(class_name_: String, level: int) -> String:
	return "[Breakthrough: %s can grow past Level %d!]" % [bare(class_name_), level]
