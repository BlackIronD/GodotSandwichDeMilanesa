extends Sprite2D

var click = false
var sandwich_colocado = false
var mi_offset = Vector2.ZERO

var posicion_correcta = Vector2(845, 740)

var distancia_para_colocar = 50

var velocidad_rotacion = 0.01

@onready var guia_sandwich = $"../GuiaSandwich"
@onready var papel_dentro_caja = $"../PapelDentroCaja"
@onready var caja_superpuesta = $"../CajaSuperpuesta"
@onready var instrucciones = $"../Instrucciones"

func _ready():

	guia_sandwich.visible = false
	caja_superpuesta.visible = false

func _process(_delta):

	if Input.is_action_just_pressed("ui_accept"):

		if not sandwich_colocado:

			var distancia = global_position.distance_to(
				posicion_correcta
			)
			
			if distancia <= distancia_para_colocar:

				sandwich_colocado = true
				click = false

				global_position = posicion_correcta

				guia_sandwich.visible = false

				instrucciones.text = "TOCA LA CAJA Y ARRASTRALA HACIA EL CENTRO."

			else:

				sandwich_colocado = false

				instrucciones.text = "¡SANDWICH MAL COLOCADO!\nUBICALO EN EL CENTRO."

		return

	if sandwich_colocado:
		return

	if not papel_dentro_caja.visible:
		return

	if Input.is_action_just_pressed("left_click"):

		var mouse = get_global_mouse_position()

		if is_pixel_opaque(to_local(mouse)):

			click = true
			
			caja_superpuesta.visible = true
			guia_sandwich.visible = true

			mi_offset = mouse - global_position

	if click:

		global_position = get_global_mouse_position() - mi_offset

		if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
			rotation -= velocidad_rotacion

		if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
			rotation += velocidad_rotacion

	if Input.is_action_just_released("left_click") and click:

		click = false

		instrucciones.text = "APRETA ENTER PARA COLOCAR EL SANDWICH."
