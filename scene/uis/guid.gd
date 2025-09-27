extends CanvasLayer
var maxhealth
var current_health
var maxstm
var current_stm
func _process(delta: float) -> void:
	$HBoxContainer/health.max_value = maxhealth
	$HBoxContainer/health.value= current_health
	$HBoxContainer/stm.max_value = maxstm
	$HBoxContainer/stm.value= current_stm
