extends Control

@onready var temporizador = $Temporizador
@onready var tiempo_label = $Tiempo
@onready var boton_iniciar = $BotonIniciar
@onready var boton_comenzar = $ComenzarJuego
@onready var instrucciones = $Instrucciones

var tiempo = 30
var minijuego_iniciado = false
var resistencia = ""

func _ready():

	temporizador.wait_time = 1.0
	temporizador.one_shot = false
	
	boton_iniciar.pressed.connect(iniciar_minijuego)
	temporizador.timeout.connect(actualizar_tiempo)
	boton_comenzar.pressed.connect(comenzar_juego)

	minijuego_iniciado = false

	boton_iniciar.visible = true

	boton_comenzar.visible = false

	tiempo_label.text = "Tiempo: 30"

	instrucciones.visible = false

func iniciar_minijuego():

	minijuego_iniciado = true

	boton_iniciar.visible = false
	instrucciones.visible = true
	instrucciones.text = "TOCA LAS CAJAS APILADAS Y ARRASTRA HACIA EL CENTRO"

	tiempo = 25
	tiempo_label.text = "Tiempo: " + str(tiempo)

	temporizador.start()


func actualizar_tiempo():
	tiempo -= 1

	tiempo_label.text = "Tiempo: " + str(tiempo)

	if tiempo <= 0:
		temporizador.stop()
		tiempo_label.text = "¡TIEMPO!"
		minijuego_iniciado = false


func comenzar_juego():
	get_tree().change_scene_to_file("res://level.tscn")
