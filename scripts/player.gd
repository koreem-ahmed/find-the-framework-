extends CharacterBody2D

@onready var animation_sp: AnimatedSprite2D = $animation_sp

const SPEED = 220.0
const JUMP_VELOCITY = -300.0
var is_attacking = false

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	
	if Input.is_action_just_pressed("jump") and is_on_floor() and is_attacking == false:
		velocity.y = JUMP_VELOCITY
		animation_sp.play("jump")


	var direction := Input.get_axis("left", "right")
	
	if direction > 0:
		animation_sp.flip_h = false
	
	
	elif direction < 0:
		animation_sp.flip_h = true
	
	
	if direction && is_attacking == false:
		velocity.x = direction * SPEED
		animation_sp.play("run")
	else:
		if is_attacking == false:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			animation_sp.play("idle")
	
	if Input.is_action_just_pressed("attack"):
		animation_sp.play("attack")
		is_attacking = true
	
	move_and_slide()


func _on_animation_sp_animation_finished() -> void:
	if animation_sp.animation == "attack":
		is_attacking = false
