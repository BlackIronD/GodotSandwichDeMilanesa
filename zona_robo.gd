extends Area2D

@export var enemigo: CharacterBody2D

var robo_activado := false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") and not robo_activado:
		robo_activado = true
		if enemigo:
			enemigo.empezar_persecucion(body)
