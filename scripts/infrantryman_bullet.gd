extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var speed = 300
var dir = 1

func _physics_process(delta: float) -> void:
	if dir < 0:
		sprite_2d.flip_h = true
	elif dir > 0:
		sprite_2d.flip_h = false
	
	position.x += dir * speed * delta



func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.health -= 20
	queue_free()
