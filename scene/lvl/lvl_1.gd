extends Node2D

var mob1 = preload("res://scene/char/enemies/fireball_man.tscn")
var mob2 = preload("res://scene/trooper.tscn")
var moblist = [mob1, mob2]

var spawns

var wave: int = 1
var mobs_per_wave: int = 0
var spawned_mobs: int = 0
var alive_mobs: Array = []

var spawn_interval: float = 1.0
var spawn_timer: float = 0.0

@onready var card_selec = get_node("plr/Camera2D/card_selec")
var waiting_for_card: bool = false

func _ready() -> void:
	randomize()
	spawns = $spawns.get_children()
	start_wave()

func _process(delta: float) -> void:
	if waiting_for_card:
		return

	if spawned_mobs < mobs_per_wave:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_random_mob()
			spawn_timer = 0.0

	for mob in alive_mobs.duplicate():
		if not is_instance_valid(mob):
			alive_mobs.erase(mob)

	if spawned_mobs == mobs_per_wave and alive_mobs.size() == 0 and not waiting_for_card:
		print("Wave ", wave, " complete!")
		waiting_for_card = true
		_show_card_selection()

func start_wave() -> void:
	mobs_per_wave = wave * wave + 3
	spawned_mobs = 0
	spawn_timer = 0.0
	print("Wave ", wave, " started! Mobs to spawn: ", mobs_per_wave)

func spawn_random_mob():
	if spawns.is_empty():
		return null
	var mob_scene
	if randi() % 100 < 20:
		mob_scene = mob2
	else:
		mob_scene = mob1

	var mob_instance = mob_scene.instantiate()

	var spawn_point = spawns[randi() % spawns.size()]
	if spawn_point is Node2D:
		mob_instance.position = spawn_point.position
	else:
		mob_instance.position = spawn_point

	add_child(mob_instance)
	alive_mobs.append(mob_instance)
	spawned_mobs += 1
	return mob_instance


func _show_card_selection() -> void:
	card_selec.visible = true
	if card_selec.has_method("refresh_cards"):
		card_selec.call("refresh_cards")

	if not card_selec.is_connected("card_chosen", Callable(self, "_on_card_chosen")):
		card_selec.connect("card_chosen", Callable(self, "_on_card_chosen"))

func _on_card_chosen(debuff_name: String) -> void:
	print("Player chose debuff: ", debuff_name)
	waiting_for_card = false
	card_selec.visible = false

	wave += 1
	start_wave()
