extends CharacterBody2D

var velocidad = 200
var velocidad_correr = 400
var fuerza_salto = 500
var gravedad = 1000

func _physics_process(delta):

	
	if not is_on_floor():
		velocity.y += gravedad * delta

	
	var direccion = Input.get_axis("move_left", "move_right")

	if direccion:
		velocity.x = direccion * velocidad
	else:
		velocity.x = 0

	
	if Input.is_action_pressed("run"):
		velocity.x = direccion * velocidad_correr

	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -fuerza_salto


	move_and_slide()
