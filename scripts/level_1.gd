extends Node2D



func _on_poratal_body_entered(body: Node2D) -> void:
	if Global.score >= 6:
		Transition.change_scene("res://scenes/winning.tscn")
	
	
#kfjkjdfhskhfjdhsfslkdjflkdjslfdksfjl
