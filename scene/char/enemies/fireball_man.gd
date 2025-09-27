extends CharacterBody2D
var health = 100

func get_dmged(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
		print('asd')
