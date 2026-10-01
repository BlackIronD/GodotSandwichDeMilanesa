extends CharacterBody2D

@export var SPEED = 300.0
const JUMP_VELOCITY = -600.0

@export var post_knockback_wait := 0.4

@export var backpack_level := 1
@export var sandwich_quantity := 3

@export var hits_per_sandwich := 3
var sandwich_hits := 0

var knockback_timer := 0.0
var post_knockback_timer := 0.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var cantidad_sangu: Label = $"../Camera2D/Control/CantidadSangu"


func apply_knockback(direction: Vector2, force: float) -> void:
	velocity = direction * force
	knockback_timer = 0.2
	post_knockback_timer = 0.0


func take_hit() -> void:
	if sandwich_quantity <= 0:
		return

	sandwich_hits += 1

	print("Sandwich damage: ", sandwich_hits, "/", hits_per_sandwich)

	if sandwich_hits >= hits_per_sandwich:
		sandwich_quantity -= 1
		sandwich_hits = 0

		print("Sandwich destroyed!")
		print("quadan: ", sandwich_quantity)

		cantidad_sangu.text = "x" + str(sandwich_quantity)

		if sandwich_quantity <= 0:
			print("Sin sannguches")


func _physics_process(delta: float) -> void:

	# Knockback
	if knockback_timer > 0:
		knockback_timer -= delta

		velocity += get_gravity() * delta
		move_and_slide()

		if knockback_timer <= 0:
			post_knockback_timer = post_knockback_wait

		return


	# Post-knockback penalty
	if post_knockback_timer > 0:
		post_knockback_timer -= delta

		animated_sprite_2d.play("Hurt")

		# Keep moving forward
		velocity.x = SPEED

		if not is_on_floor():
			velocity += get_gravity() * delta
			animated_sprite_2d.play("JumpDown")

		move_and_slide()
		return


	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta


	# Constant forward movement
	velocity.x = SPEED


	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	# Slide
	if Input.is_action_pressed("ui_down") and is_on_floor():
		animated_sprite_2d.play("Slide")
		animation_player.play("Slide")

	# Jump animation
	elif not is_on_floor():
		if velocity.y < 0:
			animated_sprite_2d.play("JumpUp")
		else:
			animated_sprite_2d.play("JumpDown")

	# Run
	else:
		animated_sprite_2d.play("Run")


	move_and_slide()
