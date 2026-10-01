extends CharacterBody2D

@export var SPEED = 300.0
const JUMP_VELOCITY = -600.0

@export var post_knockback_wait := 0.4

# Backpack
@export var backpack_level := 1
@export var sandwich_quantity := 3


@export var hits_per_sandwich := 3
var sandwich_hits := 0

var knockback_timer := 0.0
var post_knockback_timer := 0.0

@onready var camera: Camera2D = get_viewport().get_camera_2d()
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

	# Damage current sandwich
	sandwich_hits += 1

	print("Sandwich damage: ", sandwich_hits, "/", hits_per_sandwich)

	# Destroy sandwich after 3 hits
	if sandwich_hits >= hits_per_sandwich:
		sandwich_quantity -= 1
		sandwich_hits = 0

		print("Sandwich destroyed!")
		print("quadan: ", sandwich_quantity)
		cantidad_sangu.text = "x"+ str(sandwich_quantity)
		if sandwich_quantity <= 0:
			print("Sin sannguches")
			


func _physics_process(delta: float) -> void:

	# Knockback
	if knockback_timer > 0:
		knockback_timer -= delta
		velocity += get_gravity() * delta
		move_and_slide()

		# Knockback just finished
		if knockback_timer <= 0:
			post_knockback_timer = post_knockback_wait

		return

	# Post-knockback penalty
	if post_knockback_timer > 0:
		post_knockback_timer -= delta

		velocity.x = 0

		if not is_on_floor():
			velocity += get_gravity() * delta

		move_and_slide()
		return

	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = 0

	# Slide
	if Input.is_action_pressed("ui_down"):
		velocity.y = -JUMP_VELOCITY
		animated_sprite_2d.play("Slide")
		animation_player.play("Slide")

	# Run
	elif direction != 0:
		animated_sprite_2d.play("Run")

	# Idle
	else:
		animated_sprite_2d.play("Idle")

	move_and_slide()

	if camera:
		var half_width := get_viewport_rect().size.x / 2.0

		var left_edge := camera.global_position.x - half_width
		var right_edge := camera.global_position.x + half_width

		if global_position.x < left_edge + 50:
			global_position.x = left_edge + 50

		if global_position.x > right_edge - 100:
			camera.speed_up(delta)
		else:
			camera.slow_down(delta)
