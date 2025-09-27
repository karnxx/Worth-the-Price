extends CharacterBody2D


@export var health: int = 100
@export var stm: int = 50
@export var dmg: int = 10
@export var speed: float = 150.0
@export var roll_dis: int = 100
var facing
var current_health
var current_stm
var current_dmg
var current_roll_dis
var able_to_roll = true
var input_dir: Vector2 = Vector2.ZERO
var last_dir: Vector2 = Vector2.DOWN
var is_rolling:= false
var is_moving:= false
var is_attacking := false
var can_move :=true
var movement_lag = 0
func _ready():
	current_health = health
	current_stm = stm
	current_dmg = dmg
	current_roll_dis = roll_dis

func _physics_process(_delta: float) -> void:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO and can_move:
		if movement_lag != 0:
			await get_tree().create_timer(movement_lag).timeout
		velocity = input_dir.normalized() * speed
		last_dir = input_dir
		if not is_rolling and not is_attacking:
			playwalk(input_dir)
		is_moving = true
	else:
		velocity = Vector2.ZERO
		if not is_rolling and not is_attacking:
			playidle()
		is_moving = false
	if Input.is_action_just_pressed("roll") and not is_rolling and able_to_roll:
		is_rolling = true
		await roll(last_dir)
		is_rolling = false
	if Input.is_action_just_pressed("ui_accept"):
		if not is_rolling and not is_attacking:
			sword_slash()
	move_and_slide()

func _process(_delta: float) -> void:
	get_node('Camera2D/guid').current_health = current_health
	get_node('Camera2D/guid').maxhealth = health
	get_node('Camera2D/guid').current_stm = current_stm
	get_node('Camera2D/guid').maxstm = stm

func playwalk(dir) -> void:
	if dir.x > 0 and dir.y == 0:
		$animate.play("walk_right")
		facing = "right"
	elif dir.x < 0 and dir.y == 0:
		$animate.play("walk_left")
		facing = "left"
	elif dir.y < 0 and dir.x == 0:
		$animate.play("walk_up")
		facing = "up"
	elif dir.y > 0 and dir.x == 0:
		$animate.play("walk_down")
		facing = "down"
	elif dir.x > 0 and dir.y < 0:
		$animate.play("walk_topright")
		facing = "topright"
	elif dir.x < 0 and dir.y < 0:
		$animate.play("walk_topleft")
		facing = "topleft"
	elif dir.x > 0 and dir.y > 0:
		$animate.play("wawlk_bottomright")
		facing = "bottomright"
	elif dir.x < 0 and dir.y > 0:
		$animate.play("walk_bottomleft")
		facing = "bottomleft"

func playidle() -> void:
	if facing == "right":
		$animate.play("right_idle")
	elif facing == "left":
		$animate.play("left_idle")
	elif facing == "up":
		$animate.play("up_idle")
	elif facing == "down":
		$animate.play("down_idle")
	elif facing == "topright":
		$animate.play("upright_idle")
	elif facing == "topleft":
		$animate.play("upleft_idle")
	elif facing == "bottomright":
		$animate.play("downright_idle")
	elif facing == "bottomleft":
		$animate.play("downleft_idle")

func playrol(dir) -> void:
	if dir.x > 0 and dir.y == 0:
		$animate.play("roll_right")
	elif dir.x < 0 and dir.y == 0:
		$animate.play("roll_left")
	elif dir.y < 0 and dir.x == 0:
		$animate.play("roll_up")
	elif dir.y > 0 and dir.x == 0:
		$animate.play("roll_down")
	elif dir.x > 0 and dir.y < 0:
		$animate.play("roll_upright")
	elif dir.x < 0 and dir.y < 0:
		$animate.play("roll_upleft")
	elif dir.x > 0 and dir.y > 0:
		$animate.play("roll_downright")
	elif dir.x < 0 and dir.y > 0:
		$animate.play("roll_downleft")

func roll(dir) -> void:
	can_move =false
	playrol(dir)
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + (dir.normalized() * roll_dis), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
	can_move = true

func sword_slash():
	can_move = false
	$animate2.visible = true
	if facing == "up" or facing =="topright":
		$animate.play("slash_up")
		$animate2.play("up")
		var colliders = [$attack/up,$attack/right,$attack/topright]
		is_attacking = true
		for i in colliders:
			if i.is_colliding():
				if i.get_collider().has_method('get_dmged'):
					i.get_collider().get_dmged(current_dmg)
	elif facing == "down" or facing =="bottomleft":
		$animate.play("slash_down")
		$animate2.play("down")
		is_attacking = true
		var colliders = [$attack/left,$attack/bottomleft,$attack/down]
		for i in colliders:
			if i.is_colliding():
				if i.get_collider().has_method('get_dmged'):
					i.get_collider().get_dmged(current_dmg)
	elif facing == "right" or facing =="bottomright":
		$animate.play("slash_right")
		$animate2.play("right")
		is_attacking = true
		var colliders = [$attack/down,$attack/bottomright,$attack/right]
		for i in colliders:
			if i.is_colliding():
				if i.get_collider().has_method('get_dmged'):
					i.get_collider().get_dmged(current_dmg)
	elif facing == "left" or facing =="topleft":
		$animate.play("slash_left")
		$animate2.play("left")
		is_attacking = true
		var colliders = [$attack/up,$attack/topleft,$attack/left]
		for i in colliders:
			if i.is_colliding():
				if i.get_collider().has_method('get_dmged'):
					i.get_collider().get_dmged(current_dmg)
	await $animate.animation_finished
	is_attacking = false
	$animate2.visible = false
	can_move = true

func sac_healthui():
	get_node('Camera2D/guid/HBoxContainer/health').visible = false
	SacManager.add_sac(SacManager.inter_sac, "health_ui_gone")

func sac_stmui():
	get_node('Camera2D/guid/HBoxContainer/stm').visible = false
	SacManager.add_sac(SacManager.inter_sac, "stm_ui_gone")

func sac_roll():
	able_to_roll = false
	SacManager.add_sac(SacManager.adv_sac, "roll_gone")
 
func sac_color():
	get_node('Camera2D/guid/ColorRect').visible = true
	SacManager.add_sac(SacManager.basic_sac, "greyscale_vision")

func sac_eyesight1():
	get_node('Camera2D/guid/vigin1').visible = true
	SacManager.add_sac(SacManager.basic_sac, "viginette1")

func sac_eyesight2():
	get_node('Camera2D/guid/vigin2').visible = true
	SacManager.add_sac(SacManager.adv_sac, "viginette2")

func sac_sound():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
	SacManager.add_sac(SacManager.basic_sac, "sound_mute")

func sac_max_health10():
	health -= 10
	SacManager.add_sac(SacManager.basic_sac, "max_health_-10")

func sac_max_health20():
	health -= 20
	SacManager.add_sac(SacManager.basic_sac, "max_health_-20")

func sac_max_health30():
	health -= 30
	SacManager.add_sac(SacManager.inter_sac, "max_health_-30")

func sac_max_health40():
	health -= 40
	SacManager.add_sac(SacManager.adv_sac, "max_health_-40")

func sac_max_health70():
	health -= 70
	SacManager.add_sac(SacManager.super_sac, "max_health_-70")

func sac_movement_lag():
	movement_lag = 1
	SacManager.add_sac(SacManager.super_sac, "max_health_-70")
