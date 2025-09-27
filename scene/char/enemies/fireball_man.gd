extends CharacterBody2D
var is_crack = false
var health = 100
const speed = 50
var shoot = false
var facing = "down"
var stop_distance = 100
var random_dir: Vector2 = Vector2.ZERO
@onready var move_timer: Timer = $move_timer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D
@onready var random_timer: Timer = $Timer
var player: CharacterBody2D
func _ready() -> void:
	player = get_tree().current_scene.get_node("plr")
	random_timer.wait_time = randf_range(3, 8)
	random_timer.one_shot = true
	random_timer.start()
	move_timer.wait_time = randf_range(1.5, 3.0)
	move_timer.one_shot = false
	move_timer.start()
func _physics_process(delta: float) -> void:
	if not player:
		return
	make_path()
	var next_pos = nav.get_next_path_position()
	var dir = (next_pos - global_position).normalized()
	var distance = global_position.distance_to(player.global_position)
	if distance > stop_distance:
		velocity = dir * speed
	else:
		velocity = random_dir * (speed * 0.5) 
	
	move_and_slide()
	if not shoot:
		if distance > stop_distance:
			playwalk(dir)
		else:
			playwalk(random_dir)
func get_dmged(dmg):
	health -= dmg
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
	if health <= 0:
		queue_free()
func make_path() -> void:
	if player:
		nav.target_position = player.global_position
func _process(delta: float) -> void:
	if SacManager.inter_sac.has("plr_sprt"):
		is_crack = true
	else:
		false
func playwalk(dir: Vector2) -> void:
	if is_crack:
		animate.play("break")
	else:
		if dir.length() == 0:
			animate.play("down_run")
			return
		
		var tol = 0.3
		if dir.x > tol and abs(dir.y) <= tol:
			animate.play("right_run")
			facing = "right"
		elif dir.x < -tol and abs(dir.y) <= tol:
			animate.play("left_run")
			facing = "left"
		elif dir.y < -tol and abs(dir.x) <= tol:
			animate.play("up_run")
			facing = "up"
		elif dir.y > tol and abs(dir.x) <= tol:
			animate.play("down_run")
			facing = "down"
		elif dir.x > tol and dir.y > tol:
			animate.play("right_down")
			facing = "bottomright"
		elif dir.x < -tol and dir.y > tol:
			animate.play("left_down")
			facing = "bottomleft"
		elif dir.x > tol and dir.y < -tol:
			animate.play("right_up")
			facing = "topright"
		elif dir.x < -tol and dir.y < -tol:
			animate.play("left_up")
			facing = "topleft"

func play_shoot(dir):
	var tol = 0.3
	if dir.x > tol and abs(dir.y) <= tol:
		animate.play("right_shoot")
		facing = "right"
	elif dir.x < -tol and abs(dir.y) <= tol:
		animate.play("left_shoot")
		facing = "left"
	elif dir.y < -tol and abs(dir.x) <= tol:
		animate.play("up_shoot")
		facing = "up"
	elif dir.y > tol and abs(dir.x) <= tol:
		animate.play("down_shoot")
		facing = "down"
	elif dir.x > tol and dir.y > tol:
		animate.play("right_down_shoot")
		facing = "bottomright"
	elif dir.x < -tol and dir.y > tol:
		animate.play("left_down_shoot")
		facing = "bottomleft"
	elif dir.x > tol and dir.y < -tol:
		animate.play("right_up_shoot")
		facing = "topright"
	elif dir.x < -tol and dir.y < -tol:
		animate.play("left_up_shoot")
		facing = "topleft"
func _on_timer_timeout() -> void:
	if not player:
		return
	print('a')
	shoot = true
	var shoot_dir = (player.global_position - global_position).normalized()
	var fireball_scene = preload("res://scene/fireball.tscn")
	var fireball = fireball_scene.instantiate()
	fireball.global_position = global_position
	fireball.rotation = shoot_dir.angle()
	fireball.direction = shoot_dir
	get_parent().add_child(fireball)
	if is_crack:
		animate.play("break")
	else:
		await play_shoot(shoot_dir)
	var anim_length = 1.0
	await get_tree().create_timer(anim_length).timeout
	shoot = false
	random_timer.wait_time = randf_range(3, 8)
	random_timer.start()
func _on_move_timer_timeout() -> void:
	if global_position.distance_to(player.global_position) <= stop_distance:
		var angle = randf() * TAU
		random_dir = Vector2(cos(angle), sin(angle)).normalized()
	else:
		random_dir = Vector2.ZERO
	
	move_timer.wait_time = randf_range(3.0, 5.0)
