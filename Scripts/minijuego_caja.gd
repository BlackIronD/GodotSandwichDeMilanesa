extends Control

@onready var temporizador = $Temporizador
@onready var tiempo_label = $Tiempo
@onready var boton_iniciar = $BotonIniciar
@onready var boton_comenzar = $ComenzarJuego
@onready var instrucciones = $Instrucciones
@onready var caja_tapada = $CajaTapada
@onready var resultado_resistencia = $ResultadoResistencia
@onready var boton_reiniciar = $ReiniciarMinijuego

var tiempo = 30
var minijuego_iniciado = false
var resistencia = ""

func _ready():

	temporizador.wait_time = 1.0
	temporizador.one_shot = false
	boton_reiniciar.visible = false

	boton_iniciar.pressed.connect(iniciar_minijuego)
	temporizador.timeout.connect(actualizar_tiempo)
	boton_comenzar.pressed.connect(comenzar_juego)
	boton_reiniciar.pressed.connect(reiniciar_minijuego)

	minijuego_iniciado = false

	boton_iniciar.visible = true
	boton_comenzar.visible = false

	tiempo_label.text = "Tiempo: 30"

	instrucciones.visible = false
	resultado_resistencia.visible = false

	resultado_resistencia.add_theme_color_override("font_color", Color.WHITE)
	resultado_resistencia.add_theme_color_override("font_outline_color", Color.BLACK)
	resultado_resistencia.add_theme_constant_override("outline_size", 20)
	
func iniciar_minijuego():

	minijuego_iniciado = true
	
	boton_reiniciar.visible = true

	boton_iniciar.visible = false
	instrucciones.visible = true

	instrucciones.text = "TOCA LAS CAJAS APILADAS Y ARRASTRA HACIA EL CENTRO"

	tiempo = 30
	tiempo_label.text = "Tiempo: " + str(tiempo)

	temporizador.start()

func reiniciar_minijuego():
	get_tree().reload_current_scene()

func actualizar_tiempo():

	tiempo -= 1

	tiempo_label.text = "Tiempo: " + str(tiempo)

	if tiempo <= 0:

		temporizador.stop()
		tiempo_label.text = "¡TIEMPO!"
		minijuego_iniciado = false

		tiempo_agotado()

func tiempo_agotado():

	# Bloquear el minijuego
	minijuego_iniciado = false

	$CajaCentro.visible = false
	$GuiaCaja.visible = false

	$PapelParafinado.visible = false
	$PapelSeleccionado.visible = false
	$PapelDentroCaja.visible = false

	$Sandwich.visible = false
	$GuiaSandwich.visible = false
	$SandwichDentroCaja.visible = false

	$CajaTapar.visible = false
	$GuiaCajaTapar.visible = false

	$Teclas.visible = false
	$CuentaRegresiva.visible = false

	$CajaAtadaPerfecta.visible = false
	$CajaBienAtada.visible = false
	$CajaAtadaMal.visible = false

	$CajasApiladas.visible = true
	$HiloPiolin.visible = true
	caja_tapada.visible = true

	instrucciones.visible = true
	instrucciones.text = "CAJA TAPADA AUTOMÁTICAMENTE"

	resistencia = "muy_fragil"

	resultado_resistencia.text = "RESISTENCIA:\nMUY FRÁGIL"
	resultado_resistencia.visible = true

	boton_comenzar.visible = true

func comenzar_juego():

	get_tree().change_scene_to_file("res://level.tscn")
