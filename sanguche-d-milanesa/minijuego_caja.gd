extends Control

@onready var temporizador = $Temporizador
@onready var tiempo_label = $Tiempo
@onready var boton_iniciar = $BotonIniciar
@onready var boton_comenzar = $ComenzarJuego
@onready var instrucciones = $Instrucciones

var tiempo = 25
var minijuego_iniciado = false
var resistencia = ""


func _ready():
	# Configuración del temporizador
	temporizador.wait_time = 1.0
	temporizador.one_shot = false
	

	# Conectar botón y temporizador
	boton_iniciar.pressed.connect(iniciar_minijuego)
	temporizador.timeout.connect(actualizar_tiempo)
	boton_comenzar.pressed.connect(comenzar_juego)

	# Al comenzar, el minijuego todavía no está iniciado
	minijuego_iniciado = false

	# Mostrar botón de iniciar
	boton_iniciar.visible = true

	# Ocultar botón de comenzar
	boton_comenzar.visible = false

	# Mostrar tiempo inicial
	tiempo_label.text = "Tiempo: 25"

	instrucciones.visible = false

func iniciar_minijuego():
	# Activar el minijuego
	minijuego_iniciado = true

	# Ocultar botón
	boton_iniciar.visible = false
	instrucciones.visible = true
	instrucciones.text = "TOCA LAS CAJAS APILADAS Y ARRASTRA HACIA EL CENTRO"

	# Reiniciar tiempo
	tiempo = 25
	tiempo_label.text = "Tiempo: " + str(tiempo)

	# Empezar a contar
	temporizador.start()


func actualizar_tiempo():
	tiempo -= 1

	tiempo_label.text = "Tiempo: " + str(tiempo)

	# Cuando llega a 0
	if tiempo <= 0:
		temporizador.stop()
		tiempo_label.text = "¡TIEMPO!"
		minijuego_iniciado = false


func comenzar_juego():
	get_tree().change_scene_to_file("res://level.tscn")
