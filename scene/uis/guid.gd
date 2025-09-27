extends CanvasLayer
var maxhealth
var current_health
func _process(delta: float) -> void:
	$ProgressBar.max_value = maxhealth
	$ProgressBar.value = current_health
