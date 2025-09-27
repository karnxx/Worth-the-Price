extends CharacterBody2D

func _physics_process(delta: float) -> void:
	movement()
	move_and_slide()

func movement():
	var dir= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity += dir
