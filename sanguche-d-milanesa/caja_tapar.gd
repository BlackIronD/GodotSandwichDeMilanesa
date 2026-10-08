extends Area2D

var agarrada := false
var colocada := false
var bloqueada := false
var offset := Vector2.ZERO

@onready var caja_tapada = $"../CajaTapada"
@onready var guia_caja = $"../GuiaCajaTapar"


func _ready():
	caja_tapada.visible = false
	guia_caja.visible = false


func _process(_delta):

	if bloqueada:
		return

	if colocada and Input.is_key_pressed(KEY_ENTER):
		agarrada = false
		bloqueada = true
		return


	if Input.is_action_just_pressed("left_click"):

		var mouse = get_global_mouse_position()

		if global_position.distance_to(mouse) < 150:

			agarrada = true

			offset = global_position - mouse

			rotation = 0

			$Sprite2D.visible = false

			caja_tapada.global_position = global_position
			caja_tapada.rotation = 0
			caja_tapada.visible = true

			# Mostrar guía
			guia_caja.visible = true

			print("TAPA AGARRADA")

	if agarrada:

		global_position = get_global_mouse_position() + offset

		caja_tapada.global_position = global_position

	if Input.is_action_just_released("left_click") and agarrada:

		agarrada = false

		if global_position.distance_to(guia_caja.global_position) < 100:

			# Colocar en la guía
			global_position = guia_caja.global_position
			caja_tapada.global_position = guia_caja.global_position

			# Horizontal
			rotation = 0
			caja_tapada.rotation = 0

			# Ocultar guía
			guia_caja.visible = false

			# CajaTapada queda visible
			caja_tapada.visible = true
			$"../Instrucciones".text = "TOCA EL HILO PIOLIN Y\n¡EMPEZÁ A ATAR LA CAJA!"

			colocada = true

			print("CAJA TAPADA COLOCADA")
