extends CharacterBody2D

@onready var animation_op: AnimatedSprite2D = $animation_op
@onready var det_left: RayCast2D = $det_left
@onready var det_right: RayCast2D = $det_right
@onready var right: RayCast2D = $right
@onready var left: RayCast2D = $left
@onready var timer: Timer = $Timer
@onready var detection_area: Area2D = $"detection area"
@onready var shot_place: Marker2D = $Marker2D

const SPEED = 100.0
var direction = 1

var death = false
var health = 130
var max_hel = 130
var min_hel = 0

var is_attacking = false

const bullet = preload("res://scenes/infrantryman_bullet.tscn")

func _physics_process(delta: float) -> void:
	
	if death:
		animation_op.play("die")
		return
	
	elif is_attacking:
		if det_right.is_colliding() == true:
			direction = 1
			animation_op.flip_h = false
			shot_place.position.x = 10.0
		
		elif det_left.is_colliding() == true:
			direction = -1
			animation_op.flip_h = true
			shot_place.position.x = -10.0
		
		animation_op.play("attack_shot")
		return
	
	else:
		if animation_op.animation != "walking":
			animation_op.play("walk")
		position.x += SPEED * direction * delta
	
	
	if left.is_colliding() == false:
		direction = 1
		animation_op.flip_h = false
		shot_place.position.x = 10
	
	elif right.is_colliding() == false:
		direction = -1
		animation_op.flip_h = true
		shot_place.position.x = -10
	
	
	move_and_slide()


func _on_animation_op_animation_finished() -> void:
	if animation_op.animation == "die":
		queue_free()
		Global.score += 1
	
	if animation_op.animation == "attack":
		timer.start()

func attack() -> void:
	var bullet_ins = bullet.instantiate()
	get_tree().root.add_child(bullet_ins)
	bullet_ins.global_position = shot_place.global_position
	
	
	if animation_op.flip_h == true:
		bullet_ins.dir = -1
	else:
		bullet_ins.dir = 1
	
	timer.start()

func _on_detection_area_body_entered(body: Node2D) -> void:
	is_attacking = true
	timer.start()

func _on_detection_area_body_exited(body: Node2D) -> void:
	is_attacking = false
	timer.stop()

func _on_timer_timeout() -> void:
	if is_attacking:
		attack()
