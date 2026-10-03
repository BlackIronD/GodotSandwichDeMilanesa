
extends CharacterBody2D

# =========================
# CONFIGURACIÓN
# =========================
@export_group("Movimiento")
@export var velocidad : float = 60.0
@export var tiempo_caminar : float = 1.5 # Segundos que camina hacia cada lado
@export var tiempo_espera : float = 1.0  # Segundos que se queda quieto

# Gravedad predeterminada de Godot 4
var gravedad : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Nodos
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonido_pasos: AudioStreamPlayer2D = $AudioStreamPlayer2D # Nodo del sonido

# Estados posibles
enum Estado { CAMINANDO, ESPERANDO }
var estado_actual : Estado = Estado.ESPERANDO

var direccion : float = 1.0 # 1.0 = Derecha, -1.0 = Izquierda
var temporizador : float = 0.0

func _ready() -> void:
	iniciar_caminata(1.0)

func _physics_process(delta: float) -> void:
	# 1. Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravedad * delta

	# 2. Control por temporizador
	temporizador -= delta

	match estado_actual:
		Estado.CAMINANDO:
			velocity.x = direccion * velocidad

			if sprite:
				sprite.flip_h = (direccion < 0)

			if temporizador <= 0:
				iniciar_espera()

		Estado.ESPERANDO:
			velocity.x = move_toward(velocity.x, 0, velocidad)

			if temporizador <= 0:
				iniciar_caminata(-direccion)

	# 3. Aplicar físicas
	move_and_slide()

# =========================
# FUNCIONES DE CONTROL
# =========================

func iniciar_caminata(nueva_direccion: float) -> void:
	direccion = nueva_direccion
	estado_actual = Estado.CAMINANDO
	temporizador = tiempo_caminar

	# Reproducir sonido al empezar a caminar
	if sonido_pasos and not sonido_pasos.playing:
		sonido_pasos.play()

	if sprite:
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("caminando"):
			sprite.play("caminando")
		elif sprite.sprite_frames and sprite.sprite_frames.has_animation("walk"):
			sprite.play("walk")
		else:
			sprite.play()

func iniciar_espera() -> void:
	estado_actual = Estado.ESPERANDO
	temporizador = tiempo_espera

	# Detener sonido al quedar quieto
	if sonido_pasos and sonido_pasos.playing:
		sonido_pasos.stop()

	if sprite:
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")
		else:
			sprite.stop()
