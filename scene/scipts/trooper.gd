extends CharacterBody2D

# --- Stats ---
var health: int = 200
const SPEED: float = 30
const STOP_DISTANCE: float = 50
var attack_damage: int = 15
var attack_cooldown: float = 1.5
var is_attacking: bool = false
var is_dormant: bool = false
const DORMANT_TIME: float = 5.0

var random_dir: Vector2 = Vector2.ZERO
var player: CharacterBody2D

@onready var move_timer: Timer = $move_timer
@onready var random_timer: Timer = $Timer
@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var animate: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	player = get_tree().current_scene.get_node("plr")
	
	random_timer.wait_time = randf_range(3, 8)
	random_timer.one_shot = true
	random_timer.start()
	
	move_timer.wait_time = randf_range(1.5, 3.0)
	move_timer.one_shot = false
	move_timer.start()

func _physics_process(delta: float) -> void:
	if not player or is_dormant:
		return
	
	nav.target_position = player.global_position
	var next_pos = nav.get_next_path_position()
	var dir = (next_pos - global_position).normalized()
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player > STOP_DISTANCE:
		velocity = dir * SPEED
	else:
		velocity = random_dir * (SPEED * 0.5)
	
	move_and_slide()
	
	animate.flip_h = player.global_position.x < global_position.x
	
	if distance_to_player <= STOP_DISTANCE and not is_attacking:
		attack_player()
	if distance_to_player > STOP_DISTANCE:
		animate.play("idle")
	elif not is_attacking:
		animate.play("idle")

func attack_player() -> void:
	if not player:
		return
	
	is_attacking = true
	animate.play("hit")
	player.get_dmged(attack_damage)
	
	is_dormant = true
	velocity = Vector2.ZERO
	if get_tree() != null:
		await get_tree().create_timer(DORMANT_TIME).timeout
	is_dormant = false
	is_attacking = false

func get_dmged(dmg: int) -> void:
	health -= dmg
	if health <= 0:
		queue_free()

func _on_move_timer_timeout() -> void:
	if is_dormant:
		return 
	
	var distance_to_player = global_position.distance_to(player.global_position)
	
	if distance_to_player <= STOP_DISTANCE:
		var angle = randf() * TAU
		random_dir = Vector2(cos(angle), sin(angle)).normalized()
	else:
		random_dir = Vector2.ZERO
	
	move_timer.wait_time = randf_range(3.0, 5.0)
