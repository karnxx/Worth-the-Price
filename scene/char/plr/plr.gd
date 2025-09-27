extends CharacterBody2D

var caniframe := true
@export var health: int = 100
@export var stm: int = 50
@export var dmg: int = 30
@export var speed: float = 150.0
@export var roll_dis: int = 100
@export var time_between_atk := 0.5
var is_enemy = false
var facing
var stm_loss := stm / 3.5
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
var movement_lag = 0.0
var crackedsprite = false
func _ready():
	current_health = health
	current_stm = stm
	current_dmg = dmg
	current_roll_dis = roll_dis

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if not is_rolling and not is_attacking:
		if input_dir != Vector2.ZERO:
			if movement_lag != 0:
				await get_tree().create_timer(movement_lag).timeout
			velocity = input_dir.normalized() * speed
			last_dir = input_dir
			playwalk(input_dir)
			is_moving = true
		else:
			velocity = Vector2.ZERO
			playidle()
			is_moving = false
	if Input.is_action_just_pressed("roll") and able_to_roll and not is_rolling:
		if movement_lag != 0:
			await get_tree().create_timer(movement_lag).timeout
			$AudioStreamPlayer.stream = preload("res://assets/whoosh-velocity-383019.mp3")
			$AudioStreamPlayer.play()
		await roll(last_dir)
	if Input.is_action_just_pressed("accept") and not is_rolling and not is_attacking:
		if movement_lag != 0:
			await get_tree().create_timer(movement_lag).timeout
		sword_slash()
	move_and_slide()


func _process(_delta: float) -> void:
	if current_stm < stm_loss :
		able_to_roll = false
	else:
		able_to_roll = true
	get_node('Camera2D/guid').current_health = current_health
	get_node('Camera2D/guid').maxhealth = health
	get_node('Camera2D/guid').current_stm = current_stm
	get_node('Camera2D/guid').maxstm = stm
	
	if current_stm != stm:
		current_stm = current_stm + 0.05

func playwalk(dir) -> void:
	if crackedsprite:
		$animate.play("crack")
	else:
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
	if crackedsprite:
		$animate.play("crack")
	else:
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
	if crackedsprite:
		$animate.play("crack")
	else:
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
	can_move = false
	is_rolling = true
	playrol(dir)
	var roll_duration = 0.3
	var roll_speed = roll_dis / roll_duration
	velocity = dir.normalized() * roll_speed
	current_stm -= stm_loss
	await get_tree().create_timer(roll_duration).timeout
	velocity = Vector2.ZERO
	can_move = true
	is_rolling = false

func sword_slash():
	if is_attacking:
		return
	
	can_move = false
	velocity = Vector2.ZERO
	is_attacking = true
	$animate2.visible = true
	
	var dir = facing
	if dir in ["up", "topright"]:
		dir = "up"
	elif dir in ["left", "topleft"]:
		dir = "left"
	elif dir in ["down", "bottomleft"]:
		dir = "down"
	elif dir in ["right", "bottomright"]:
		dir = "right"

	var attack_data = {
		"up": {"anim": "slash_up", "hitbox": $attack/topright},
		"down": {"anim": "slash_down", "hitbox": $attack/bottomleft},
		"left": {"anim": "slash_left", "hitbox": $attack/topleft},
		"right": {"anim": "slash_right", "hitbox": $attack/bottomright}
	}

	
	$AudioStreamPlayer.stream = preload("res://assets/clean-fast-swooshaiff-14784.mp3")
	$AudioStreamPlayer.play()
	$animate2.play(dir)
	$animate2.z_index = 100

	for hb in [$attack/topleft, $attack/topright, $attack/bottomleft, $attack/bottomright]:
		hb.monitoring = false
		hb.visible = false

	var hitbox = attack_data[dir]["hitbox"]
	hitbox.monitoring = true
	hitbox.visible = true
	if crackedsprite:
		$animate.play("crack")
	else:
		$animate.play(attack_data[dir]["anim"])
		await $animate.animation_finished
	

	hitbox.monitoring = false
	hitbox.visible = false
	$animate2.visible = false

	can_move = true
	is_attacking = false
	await get_tree().create_timer(time_between_atk).timeout




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

func sac_movement_lag05s():
	movement_lag = 0.5
	SacManager.add_sac(SacManager.adv_sac, "sac_movement_lag")

func sac_movement_lag1s():
	movement_lag = 1
	SacManager.add_sac(SacManager.adv_sac, "sac_movement_lag")

func get_dmged(dmg):
	if not is_rolling and caniframe:
		current_health -= dmg
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.RED, 0.1)
		tween.tween_property(self, "modulate", Color.WHITE, 0.1)
		if current_health <= 0:
			queue_free()
			get_tree().reload_current_scene()

func sac_iframes():
	caniframe = false
	SacManager.add_sac(SacManager.adv_sac, "sac_iframes")

func sac_dmg10():
	current_dmg -= 10
	SacManager.add_sac(SacManager.adv_sac, "sac_dmg_10")

func sac_speed():
	speed -= 50
	SacManager.add_sac(SacManager.inter_sac, "sac_speed")

func sac_timebetweenatk():
	time_between_atk += 0.1
	SacManager.add_sac(SacManager.inter_sac, "swingcd")

func sac_plrsprite():
	crackedsprite = true
	SacManager.add_sac(SacManager.inter_sac, "plr_sprt")



func _on_topright_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.get_dmged(current_dmg)


func _on_bottomleft_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.get_dmged(current_dmg)


func _on_bottomright_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.get_dmged(current_dmg)


func _on_topleft_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		body.get_dmged(current_dmg)
