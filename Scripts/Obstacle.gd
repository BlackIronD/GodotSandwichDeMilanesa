extends Node2D

@export var knockback_force := 900.0

@onready var hit_area: Area2D = $Area2D
@onready var tiempo: Timer = $"../Camera2D/Control/Tiempo"


func _ready() -> void:
	hit_area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:

		var difference = body.global_position - global_position

		body.take_hit()

		tiempo.sandwich_state((tiempo.state + 1) % 4)

		# Knockback
		if abs(difference.x) > abs(difference.y):
			var direction_x = sign(difference.x)
			body.apply_knockback(
				Vector2(direction_x, 0),
				knockback_force
			)
		else:
			var direction_y = sign(difference.y)
			body.apply_knockback(
				Vector2(0, direction_y),
				knockback_force
			)
