extends Camera2D

@export var follow_speed := 8.0
@export var bounce_strength := 0.08
@export var max_bounce := 35.0

var target_x := 0.0
var previous_player_x := 0.0
var velocity_x := 0.0


func _ready() -> void:
	position_smoothing_enabled = false

	var player = get_parent().get_node_or_null("Player")

	if player:
		target_x = player.global_position.x
		previous_player_x = target_x


func _process(delta: float) -> void:
	var player = get_parent().get_node_or_null("Player")

	if not player:
		return

	# Player's current position
	target_x = player.global_position.x

	# Detect how quickly the player is moving
	var player_velocity := (target_x - previous_player_x) / delta
	previous_player_x = target_x

	# Follow the player with a slight delay
	global_position.x = lerp(
		global_position.x,
		target_x,
		1.0 - exp(-follow_speed * delta)
	)

	# Small bounce based on player's acceleration
	var acceleration := player_velocity - velocity_x
	velocity_x = player_velocity

	var bounce := acceleration * bounce_strength
	bounce = clamp(bounce, -max_bounce, max_bounce)

	global_position.y = lerp(
		global_position.y,
		global_position.y - bounce,
		8.0 * delta
	)
