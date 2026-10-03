extends Area2D

@export var blackout: Node


func _on_body_entered(body):

	if body.is_in_group("jugador"):
		blackout.activar_blackout()
