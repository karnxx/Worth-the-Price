extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir.normalized() * speed
	
	if dir != Vector2.ZERO:
		walkanim(dir)
	else:
		$animate.play("idle")
	
	move_and_slide()

func walkanim(dir) -> void:
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
