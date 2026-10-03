extends Node2D # O Node2D / Node

# Referencia al nodo AnimationPlayer
@onready var animador: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	# Reemplaza "nombre_de_tu_animacion" por el nombre exacto de la animación
	if animador and animador.has_animation("nombre_de_tu_animacion"):
		animador.play("nombre_de_tu_animacion")
