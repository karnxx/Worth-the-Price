extends CanvasLayer
var maxhealth = 0
var current_health = 0
var maxstm = 0
var current_stm = 0
func _process(delta: float) -> void:
	$HBoxContainer/health.max_value = maxhealth
	$HBoxContainer/health.value = current_health
	$HBoxContainer/stm.max_value = maxstm
	$HBoxContainer/stm.value= current_stm
