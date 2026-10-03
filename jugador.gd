extends CharacterBody2D

var velocidad = 200
var velocidad_correr = 350
var fuerza_salto = 400
var gravedad = 1000

func _physics_process(delta):

	# GRAVEDAD
	if not is_on_floor():
		velocity.y += gravedad * delta

	# CAMINAR
	var direccion = Input.get_axis("move_left", "move_right")

	if direccion:
		velocity.x = direccion * velocidad
	else:
		velocity.x = 0

	# CORRER
	if Input.is_action_pressed("run"):
		velocity.x = direccion * velocidad_correr

	# SALTAR
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -fuerza_salto

	# MOVER
	move_and_slide()
