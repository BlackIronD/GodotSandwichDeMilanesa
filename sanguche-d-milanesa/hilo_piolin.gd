extends Area2D

@onready var teclas = $"../Teclas"
@onready var cuenta_regresiva = $"../CuentaRegresiva"

@onready var caja_perfecta = $"../CajaAtadaPerfecta"
@onready var caja_bien = $"../CajaBienAtada"
@onready var caja_mal = $"../CajaAtadaMal"

@onready var boton_comenzar = $"../ComenzarJuego"
@onready var resultado_resistencia = $"../ResultadoResistencia"

@onready var caja_tapada = $"../CajaTapada"

var tecla_actual = 1
var hilo_activado = false
var errores = 0
var contando = false

var secuencia = [
	KEY_RIGHT,
	KEY_LEFT,
	KEY_RIGHT,
	KEY_LEFT,
	KEY_UP,
	KEY_DOWN
]


func _ready():
	teclas.visible = false
	cuenta_regresiva.visible = false

	caja_perfecta.visible = false
	caja_bien.visible = false
	caja_mal.visible = false

	resultado_resistencia.visible = false
	boton_comenzar.visible = false

	for i in range(1, 7):
		var tecla = teclas.get_node_or_null("Tecla" + str(i))
		if tecla:
			tecla.visible = false


func _process(_delta):

	# La caja tiene que estar tapada antes de poder iniciar el hilo
	if not caja_tapada.visible:
		return

	# Detectar cuando tocamos el hilo con el mouse
	if not hilo_activado and not contando and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):

		var mouse_pos = get_global_mouse_position()

		if $CollisionShape2D.shape != null:
			var rect = $CollisionShape2D.shape.get_rect()
			var local_mouse = to_local(mouse_pos)

			if rect.has_point(local_mouse):
				empezar_cuenta_regresiva()


func empezar_cuenta_regresiva():
	contando = true
	errores = 0
	tecla_actual = 1

	teclas.visible = false
	cuenta_regresiva.visible = true

	resultado_resistencia.visible = false

	await mostrar_numero("3")
	await get_tree().create_timer(1.0).timeout

	await mostrar_numero("2")
	await get_tree().create_timer(1.0).timeout

	await mostrar_numero("1")
	await get_tree().create_timer(1.0).timeout

	await mostrar_numero("¡YA!")

	await get_tree().create_timer(0.5).timeout

	cuenta_regresiva.visible = false
	contando = false

	hilo_activado = true
	teclas.visible = true

	mostrar_tecla()


func mostrar_numero(numero):
	cuenta_regresiva.text = numero
	await get_tree().create_timer(0.01).timeout


func mostrar_tecla():

	for i in range(1, 7):
		var tecla = teclas.get_node_or_null("Tecla" + str(i))

		if tecla:
			tecla.visible = false

	var actual = teclas.get_node_or_null("Tecla" + str(tecla_actual))

	if actual:
		actual.visible = true


func _input(event):

	if not hilo_activado:
		return

	if event is InputEventKey and event.pressed and not event.echo:

		if event.keycode == secuencia[tecla_actual - 1]:

			tecla_actual += 1

			if tecla_actual > 6:
				terminar_hilo()
			else:
				mostrar_tecla()

		else:
			errores += 1


func terminar_hilo():

	hilo_activado = false
	teclas.visible = false

	caja_perfecta.visible = false
	caja_bien.visible = false
	caja_mal.visible = false

	# ==================================
	# DETERMINAR RESISTENCIA
	# ==================================

	if errores == 0:

		caja_perfecta.visible = true

		resultado_resistencia.text = "RESISTENCIA:\nALTA"
		resultado_resistencia.visible = true

		$"..".resistencia = "alta"


	elif errores <= 2:

		caja_bien.visible = true

		resultado_resistencia.text = "RESISTENCIA:\nNORMAL"
		resultado_resistencia.visible = true

		$"..".resistencia = "normal"


	else:

		caja_mal.visible = true

		resultado_resistencia.text = "RESISTENCIA:\nFRÁGIL"
		resultado_resistencia.visible = true

		$"..".resistencia = "fragil"


	# Esperar 2 segundos y mostrar el botón
	await get_tree().create_timer(2.0).timeout

	boton_comenzar.visible = true
