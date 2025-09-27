extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = dir.normalized() * speed
	if dir.x > 0:
		naimat(walk_right)
	move_and_slide()

func naimat(animation):
	$animate.play(animation)
