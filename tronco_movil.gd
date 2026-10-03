extends AnimatableBody2D

@export var velocidad := 100.0
@export var distancia := 200.0

var posicion_inicial: Vector2

func _ready():
	posicion_inicial = position

func _physics_process(delta):
	var movimiento = sin(Time.get_ticks_msec() / 1000.0 * velocidad / 100.0)

	position.x = posicion_inicial.x + movimiento * distancia
