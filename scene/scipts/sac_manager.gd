extends Node

var sacs = {}

func _ready() -> void:
	sacs = {
	"Health UI Dissapears..": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_healthui"},
	"STM UI Dissapears..": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_stmui"},
	"No More Roll!": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_roll"},
	"Gaming in the 90's": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_color"},
	"Owl Vision": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_eyesight1"},
	"Broken Eyes": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_eyesight2"},
	"Deaf!": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_sound"},
	"Peaceful(-10 max hp)": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health10"},
	"Easy(-20 max hp)": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health20"},
	"Normal(-30 max hp)": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health30"},
	"Hard(-40 max hp)": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health40"},
	"Hardcore death more(-70 max hp)": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health70"},
	"Mid WIFI": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_movement_lag05s"},
	"Potato WIFI": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_movement_lag1s"},
	"No more eye frame": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_iframes"},
	"weak hands!": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_dmg10"},
	"Turtle!": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_speed"},
	"Slow hands!": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_timebetweenatk"},
	"ERROR_NO_TEXTURE": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_plrsprite"}
}

func apply_debuff(name: String):
	if sacs.has(name):
		sacs[name]["node"].call(sacs[name]["func"])

func pick_random_debuffs(count: int) -> Array:
	var keys = sacs.keys()
	var pool = keys.duplicate()
	var result = []
	for i in range(count):
		if pool.size() == 0:
			break
		var index = randi() % pool.size()
		result.append(pool[index])
		pool.remove_at(index)
	return result

func generate_cards() -> Array:
	var cards = []
	for i in range(3):
		var debuff_name = pick_random_debuffs(1)[0]
		cards.append(debuff_name)
	return cards


func apply_card(card_debuffs: Array):
	for debuff_name in card_debuffs:
		apply_debuff(debuff_name)

var basic_sac := []
var inter_sac := []
var adv_sac := []
var super_sac:= []


func add_sac(which, sac):
	which.append(sac)
