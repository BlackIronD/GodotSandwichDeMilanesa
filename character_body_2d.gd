extends CharacterBody2D

@export var velocidad: float = 40.0
@export var distancia_movimiento: float = 80.0
@export var knockback_force: float = 900.0

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D

var posicion_inicial_x: float
var direccion: int = 1

func _ready() -> void:
	posicion_inicial_x = global_position.x


	if animacion:
		animacion.play("new_animation")


func _physics_process(_delta: float) -> void:
	velocity.x = direccion * velocidad
	move_and_slide()


	if global_position.x >= posicion_inicial_x + distancia_movimiento:
		direccion = -1
		animacion.flip_h = true
	elif global_position.x <= posicion_inicial_x - distancia_movimiento:
		direccion = 1
		animacion.flip_h = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.has_method("take_hit"):
		body.take_hit()


	if body.has_method("apply_knockback"):
		var diferencia: Vector2 = body.global_position - global_position

		if abs(diferencia.x) > abs(diferencia.y):
			var direccion_x: float = sign(diferencia.x)
			body.apply_knockback(Vector2(direccion_x, 0), knockback_force)
		else:
			var direccion_y: float = sign(diferencia.y)
			body.apply_knockback(Vector2(0, direccion_y), knockback_force)
