extends CharacterBody2D

@onready var animation_opp: AnimatedSprite2D = $animation_opp
@onready var detection_area: Area2D = $"detection area"
@onready var shot_place: Marker2D = $shot_place
@onready var left: RayCast2D = $left
@onready var right: RayCast2D = $right
@onready var attack_timer: Timer = $attack_timer

const SPEED = 300.0
var direction = 1
var dead = false
var is_attacking = false

const bullet = preload("res://scenes/destroyer_bullet.tscn")

func _physics_process(delta: float) -> void:
	
	if dead:
		animation_opp.play("die")
		return
	
	elif is_attacking:
		attack_timer.start()
		return
	
	else:
		position.x += SPEED * direction * delta
	
	
	if left.is_colliding() == false:
		direction = 1
		animation_opp.flip_h = false
		shot_place.position.x = 35
		
	elif right.is_colliding() == false:
		direction = -1
		animation_opp.flip_h = true
		shot_place.position.x = -45
	
	
	move_and_slide()

func _on_animation_animation_finished() -> void:
	if animation_opp.animation == "attack":
		attack()
		
	if animation_opp.animation == "die":
		queue_free()
		Global.score += 1

func attack() -> void:
	var bullet_ins = bullet.instantiate()
	get_tree().root.add_child(bullet_ins)
	bullet_ins.global_position = shot_place.global_position
	attack_timer.start()

func _on_attack_timer_timeout() -> void:
	animation_opp.play("attacking_shot")


func _on_detection_area_body_entered(body: Node2D) -> void:
	is_attacking = true
	attack_timer.start()

func _on_detection_area_body_exited(body: Node2D) -> void:
	is_attacking = false
	attack_timer.start()
