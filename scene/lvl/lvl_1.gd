extends Node2D

# Mobs
var mob1 = preload("res://scene/char/enemies/fireball_man.tscn")
var moblist = [mob1]

# Spawn points container
var spawns

# Wave system
var wave = 1
var mobs_per_wave = 0
var spawned_mobs = 0
var alive_mobs = []

# Spawn timing
var spawn_interval = 1.0
var spawn_timer = 0.0

func _ready():
	randomize()
	spawns = $spawns.get_children() 
	start_wave()

func _process(delta: float) -> void:
	if spawned_mobs < mobs_per_wave:
		spawn_timer += delta
		if spawn_timer >= spawn_interval:
			spawn_random_mob()
			spawn_timer = 0.0

	for mob in alive_mobs.duplicate():
		if not is_instance_valid(mob):
			alive_mobs.erase(mob)

	if spawned_mobs == mobs_per_wave and alive_mobs.size() == 0:
		print("Wave ", wave, " complete!")
		wave += 1
		start_wave()

func start_wave():
	mobs_per_wave = pow(wave * 2, 3)
	spawned_mobs = 0
	spawn_timer = 0.0
	print("Wave ", wave, " started! Mobs to spawn: ", mobs_per_wave)

func spawn_random_mob():
	if moblist.size() == 0 or spawns.size() == 0:
		return null

	var mob_scene = moblist[randi() % moblist.size()]
	var mob_instance = mob_scene.instantiate()

	var spawn_point = spawns[randi() % spawns.size()]
	mob_instance.position = spawn_point.position if spawn_point is Node2D else spawn_point

	add_child(mob_instance)
	alive_mobs.append(mob_instance)
	spawned_mobs += 1
	return mob_instance
