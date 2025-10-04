extends Node2D
@onready var night_sky: Node2D = $bg
var parallax_strength = 0.075
@onready var bg_music: AudioStreamPlayer = $AudioStreamPlayer

var screen_size: Vector2
var base_position: Vector2
var hover = false
var fade_in_time := 3
var fade_elapsed := 0.0
var fading_in := false

func _ready() -> void:
	await get_tree().process_frame  # Wait one frame to ensure viewport exists
	screen_size = get_viewport_rect().size
	base_position = night_sky.position
	
	bg_music.volume_db = -80
	await get_tree().create_timer(2.0).timeout
	bg_music.play()
	fade_elapsed = 0.0
	fading_in = true

func _process(delta: float) -> void:
	if hover and Input.is_action_just_pressed("click"):
		get_tree().change_scene_to_file("res://scene/lvl/lvl_1.tscn")
	
	# ✅ Parallax effect (only if viewport exists)
	if is_instance_valid(get_viewport()):
		var mouse_pos = get_viewport().get_mouse_position()
		var offset = (mouse_pos - screen_size / 2) * parallax_strength
		night_sky.position = base_position + offset
	
	# ✅ Music fade in
	if fading_in:
		fade_elapsed += delta
		var t = fade_elapsed / fade_in_time
		bg_music.volume_db = lerp(-80.0, -20.0, clamp(t, 0, 1))
		if t >= 1.0:
			fading_in = false

func _on_area_2d_mouse_entered() -> void:
	hover = true

func _on_area_2d_mouse_exited() -> void:
	hover = false
