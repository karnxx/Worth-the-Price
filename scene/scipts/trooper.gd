extends CharacterBody2D
# Enemy stats
var health = 200
const speed = 30
var shoot = false
var facing = "down"
var stop_distance = 50
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
	
	if player.global_position.x < global_position.x:
		animate.flip_h = true 
	else:
		animate.flip_h = false
	
	if not shoot:
		if distance > stop_distance:
			animate.play("idle")
		else:
			animate.play("hit")

func get_dmged(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
func make_path() -> void:
	if player:
		nav.target_position = player.global_position
func _on_move_timer_timeout() -> void:
	if global_position.distance_to(player.global_position) <= stop_distance:
		var angle = randf() * TAU
		random_dir = Vector2(cos(angle), sin(angle)).normalized()
	else:
		random_dir = Vector2.ZERO
	
	move_timer.wait_time = randf_range(3.0, 5.0)
