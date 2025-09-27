extends CharacterBody3D
var current_health
var current_stm
var current_dmg
var current_roll_dis
@export var roll_dis : int
@export var health :int
@export var stm:int
@export var dmg:int

@export var speed: float = 2.0
#	-health ui
#	-stm ui
#	-ability to roll
#	-colours
#	-vision-blur-viginette
#	-losing allies
#	-enemy healthbar
#	-ability to move in a dir-only 1 round
#	-dmg lag
#	-roll i frames
#	-Sound
#	-delayed controls
#	-speed
var input_dir: Vector2
var move_dir: Vector3

func _physics_process(delta: float) -> void:
	input_dir = Input.get_vector("ui_left", "ui_right", "ui_up","ui_down")
	move_dir = Vector3(input_dir.x, 0, input_dir.y)
	if move_dir != Vector3.ZERO:
		move_dir = move_dir.normalized() * speed
		velocity.x = -move_dir.x
		velocity.z = -move_dir.z
		walkanim(input_dir)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		idleanim(input_dir)
	if !is_on_floor():
		velocity.y -= 10 * 10
	
	
	move_and_slide()

func walkanim(dir=) -> void:
	if dir.x < 0 and dir.y == 0:
		$AnimatedSprite3D.play("walk_right")
	elif dir.x > 0 and dir.y == 0:
		$AnimatedSprite3D.play("walk_left")
	elif dir.y < 0 and dir.x == 0:
		$AnimatedSprite3D.play("walk_up")
	elif dir.y > 0 and dir.x == 0:
		$AnimatedSprite3D.play("walk_down")
	elif dir.x < 0 and dir.y < 0:
		$AnimatedSprite3D.play("walk_topright")
	elif dir.x > 0 and dir.y < 0:
		$AnimatedSprite3D.play("walk_topleft")
	elif dir.x < 0 and dir.y > 0:
		$AnimatedSprite3D.play("wawlk_bottomright")
	elif dir.x > 0 and dir.y > 0:
		$AnimatedSprite3D.play("walk_bottomleft")

func idleanim(dir) -> void:
	if dir == Vector2.ZERO:
		print('ad')
	else:
		walkanim(dir)
