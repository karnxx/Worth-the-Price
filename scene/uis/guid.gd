extends CanvasLayer
var maxhealth
var current_health
func _process(delta: float) -> void:
	$HBoxContainer/health.max_value = maxhealth
	$HBoxContainer/health.value= current_health
