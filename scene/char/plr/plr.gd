extends CharacterBody2D


func movement():
	var dir= Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity += dir
