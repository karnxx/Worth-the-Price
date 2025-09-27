extends CharacterBody2D


@export var health: int = 100
@export var stm: int = 50
@export var dmg: int = 10
@export var speed: float = 200.0
@export var roll_dis: int = 100

var current_health
var current_stm
var current_dmg
var current_roll_dis

var input_dir: Vector2 = Vector2.ZERO
var last_dir: Vector2 = Vector2.DOWN
var is_rolling: bool = false
var is_moving: bool = false

func _ready():
	current_health = health
	current_stm = stm
	current_dmg = dmg
	current_roll_dis = roll_dis

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if input_dir != Vector2.ZERO:
		velocity = input_dir.normalized() * speed
		last_dir = input_dir
		if not is_rolling:
			playwalk(input_dir)
		is_moving = true
		print(last_dir)
	else:
		velocity = Vector2.ZERO
		if not is_rolling:
			playidle(last_dir)
		is_moving = false
	if Input.is_action_just_pressed("roll") and not is_rolling:
		is_rolling = true
		await roll(last_dir)
		is_rolling = false
	
	move_and_slide()

func playwalk(dir) -> void:
	if dir.x > 0 and dir.y == 0:
		$animate.play("walk_right")
	elif dir.x < 0 and dir.y == 0:
		$animate.play("walk_left")
	elif dir.y < 0 and dir.x == 0:
		$animate.play("walk_up")
	elif dir.y > 0 and dir.x == 0:
		$animate.play("walk_down")
	elif dir.x > 0 and dir.y < 0:
		$animate.play("walk_topright")
	elif dir.x < 0 and dir.y < 0:
		$animate.play("walk_topleft")
	elif dir.x > 0 and dir.y > 0:
		$animate.play("wawlk_bottomright")
	elif dir.x < 0 and dir.y > 0:
		$animate.play("walk_bottomleft")

func playidle(dir) -> void:
	if dir.x > 0 and dir.y == 0:
		$animate.play("right_idle")
	elif dir.x < 0 and dir.y == 0:
		$animate.play("left_idle")
	elif dir.y < 0 and dir.x == 0:
		$animate.play("up_idle")
	elif dir.y > 0 and dir.x == 0:
		$animate.play("down_idle")
	elif dir.x > 0 and dir.y < 0:
		$animate.play("upright_idle")
	elif dir.x < 0 and dir.y < 0:
		$animate.play("upleft_idle")
	elif dir.x > 0 and dir.y > 0:
		$animate.play("downright_idle")
	elif dir.x < 0 and dir.y > 0:
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
	playrol(dir)
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + (dir.normalized() * roll_dis), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await tween.finished
