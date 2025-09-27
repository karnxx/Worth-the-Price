extends Node2D
var speed = 300
var direction = Vector2.ZERO
var dmg = 20
func _physics_process(delta):
	if direction != Vector2.ZERO:
		position += direction * speed * delta


func _on_hit_body_entered(body: Node2D) -> void:
	if body.has_method('sword_slash'):
		body.get_dmged(dmg)
	queue_free()
