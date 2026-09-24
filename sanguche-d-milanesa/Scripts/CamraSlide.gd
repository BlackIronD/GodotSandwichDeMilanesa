extends Camera2D

@export var normal_speed := 100.0
@export var max_speed := 900.0
@export var acceleration := 800.0
@export var deceleration := 250.0

var current_speed := 100.0


func _ready() -> void:
	position_smoothing_enabled = false
	current_speed = normal_speed


func _process(delta: float) -> void:
	position.x += current_speed * delta


func speed_up(delta: float) -> void:
	current_speed = move_toward(
		current_speed,
		max_speed,
		acceleration * delta
	)


func slow_down(delta: float) -> void:
	current_speed = move_toward(
		current_speed,
		normal_speed,
		deceleration * delta
	)
