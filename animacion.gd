extends CharacterBody2D

@export var velocidad := 200.0

@onready var animacion = $AnimatedSprite2D

func _physics_process(delta):

	var direccion = Input.get_axis("move_left", "move_right")

	velocity.x = direccion * velocidad

	$"../AnimatedSprite2D".play("QUIETO")

	move_and_slide()
