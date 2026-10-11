
extends CharacterBody2D

@export_group("Movimiento")
@export var velocidad: float = 60.0
@export var tiempo_caminar: float = 1.5
@export var tiempo_espera: float = 1.0

@export_group("Ladrido")
@export var tiempo_entre_ladridos: float = 2.0

@export_group("Golpe")
@export var knockback_force: float = 900.0

var gravedad: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sonido_ladrido: AudioStreamPlayer2D = $"../AudioStreamPlayer2D"

enum Estado { CAMINANDO, ESPERANDO }
var estado_actual: Estado = Estado.ESPERANDO

var direccion: float = 1.0
var temporizador: float = 0.0

var jugador_cerca: bool = false
var temporizador_ladrido: float = 0.0


func _ready() -> void:
	iniciar_caminata(1.0)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravedad * delta

	temporizador -= delta

	if jugador_cerca:
		temporizador_ladrido -= delta

	match estado_actual:
		Estado.CAMINANDO:
			velocity.x = direccion * velocidad

			if sprite:
				sprite.flip_h = direccion < 0

			if temporizador <= 0:
				iniciar_espera()

		Estado.ESPERANDO:
			velocity.x = move_toward(velocity.x, 0, velocidad)

			if temporizador <= 0:
				iniciar_caminata(-direccion)

	if jugador_cerca and temporizador_ladrido <= 0:
		ladrar()
		temporizador_ladrido = tiempo_entre_ladridos
		

	move_and_slide()


func iniciar_caminata(nueva_direccion: float) -> void:
	direccion = nueva_direccion
	estado_actual = Estado.CAMINANDO
	temporizador = tiempo_caminar

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

	if sprite:
		if sprite.sprite_frames and sprite.sprite_frames.has_animation("idle"):
			sprite.play("idle")
		else:
			sprite.stop()


func ladrar() -> void:
	if sonido_ladrido:
		sonido_ladrido.play()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = true
		temporizador_ladrido = 0.0

		if body.has_method("take_hit"):
			body.take_hit()

			if body.has_method("apply_knockback"):
				var diferencia: Vector2 = body.global_position - global_position

				if abs(diferencia.x) > abs(diferencia.y):
					var direccion_x: float = sign(diferencia.x)
					body.apply_knockback(Vector2(direccion_x, 0), knockback_force)
				else:
					var direccion_y: float = sign(diferencia.y)
					body.apply_knockback(Vector2(0, direccion_y), knockback_force)


func _on_area_2d_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		temporizador_ladrido = 0.0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("take_hit"):
		var diferencia: Vector2 = body.global_position - global_position

		body.take_hit()

		if body.has_method("apply_knockback"):
			if abs(diferencia.x) > abs(diferencia.y):
				var direccion_x: float = sign(diferencia.x)
				body.apply_knockback(
					Vector2(direccion_x, 0),
					knockback_force
				)
			else:
				var direccion_y: float = sign(diferencia.y)
				body.apply_knockback(
					Vector2(0, direccion_y),
					knockback_force
				)
