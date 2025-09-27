extends Node

var sacs = {}

func _ready() -> void:
	sacs = {
	"health_ui_gone": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_healthui"},
	"stm_ui_gone": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_stmui"},
	"roll_gone": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_roll"},
	"greyscale_vision": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_color"},
	"viginette1": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_eyesight1"},
	"viginette2": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_eyesight2"},
	"sound_mute": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_sound"},
	"max_health_-10": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health10"},
	"max_health_-20": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health20"},
	"max_health_-30": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health30"},
	"max_health_-40": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health40"},
	"max_health_-70": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_max_health70"},
	"sac_movement_lag05s": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_movement_lag05s"},
	"sac_movement_lag1s": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_movement_lag1s"},
	"sac_iframes": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_iframes"},
	"sac_dmg_10": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_dmg10"},
	"sac_speed": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_speed"},
	"swingcd": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_timebetweenatk"},
	"plr_sprt": {"node": get_tree().current_scene.get_node("plr"), "func": "sac_plrsprite"}
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
		# pick_random_debuffs(1) returns an Array, so grab [0] to get the single debuff name
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
