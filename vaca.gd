extends CharacterBody2D

@export var velocidad := 50.0 
@export var tiempo_caminar := 1.0 
@export var tiempo_espera := 1.0 

# Gravedad del proyecto
var gravity : int = ProjectSettings.get_setting("physics/2d/default_gravity")

# Busca el AnimatedSprite2D de forma automática
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D if has_node("AnimatedSprite2D") else find_child("*AnimatedSprite2D*", true, false)

var estado := "esperando" 
var direccion := 1.0 
var temporizador := 0.0

func _ready() -> void:
	iniciar_caminata(1.0)

func _physics_process(delta: float) -> void:
	# 1. Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	temporizador -= delta

	if estado == "caminando":
		velocity.x = velocidad * direccion

		# Cambiar la orientación según la dirección
		if sprite:
			sprite.flip_h = (direccion < 0)

		if temporizador <= 0:
			iniciar_espera()

	elif estado == "caminando":
		velocity.x = 0

		if temporizador <= 0:
			iniciar_caminata(-direccion)

	# 2. Aplicar el movimiento físico
	move_and_slide()

# Función para activar el movimiento y lanzar la animación UNA SOLA VEZ
func iniciar_caminata(nueva_direccion: float) -> void:
	direccion = nueva_direccion
	estado = "caminando"
	temporizador = tiempo_caminar
	
	if sprite:
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("caminar"):
			sprite.play("caminar")
		else:
			sprite.play() # Reproduce la animación por defecto si no encuentra "caminar"

# Función para detenerse y pausar la animación
func iniciar_espera() -> void:
	estado = "esperando"
	temporizador = tiempo_espera
	
	if sprite:
		# Si tienes una animación de estar quieto llamada "idle", usa la siguiente línea:
		# sprite.play("idle")
		sprite.stop() # Si no tienes "idle", simplemente detiene la animación
