extends Sprite2D

var click = false
var mi_offset = Vector2.ZERO
var caja_colocada = false

@onready var minijuego = $".."
@onready var caja_centro = $"../CajaCentro"
@onready var guia_caja = $"../GuiaCaja"
@onready var fondo_armado_caja = $"../FondoArmadoCaja"

var distancia_para_colocar = 150


func _ready():
	# Al comenzar, estos elementos están ocultos
	caja_centro.visible = false
	guia_caja.visible = false
	fondo_armado_caja.visible = false

	# Orden de las capas
	fondo_armado_caja.z_index = 0
	caja_centro.z_index = 1


func _process(_delta):

	# =========================
	# AGARRAR LA CAJA
	# =========================
	if Input.is_action_just_pressed("left_click") and not caja_colocada:

		# Si todavía no se inició el minijuego,
		# no se puede agarrar la caja
		if not minijuego.minijuego_iniciado:
			return

		# Comprobar si el mouse está sobre la caja
		if is_pixel_opaque(to_local(get_global_mouse_position())):

			caja_centro.global_position = get_global_mouse_position()

			caja_centro.visible = true
			guia_caja.visible = true

			click = true

			mi_offset = (
				caja_centro.global_position
				- get_global_mouse_position()
			)


	# =========================
	# MOVER LA CAJA
	# =========================
	if click and not caja_colocada:

		caja_centro.global_position = (
			get_global_mouse_position() + mi_offset
		)


	# =========================
	# SOLTAR LA CAJA
	# =========================
	if Input.is_action_just_released("left_click") and click:

		click = false

		# Comprobar si llegó a la guía
		if caja_centro.global_position.distance_to(
			guia_caja.global_position
		) < distancia_para_colocar:

			# Colocar exactamente en la guía
			caja_centro.global_position = guia_caja.global_position

			# Ocultar guía
			guia_caja.visible = false

			# Mostrar fondo
			fondo_armado_caja.visible = true

			# La caja queda quieta
			caja_colocada = true
			minijuego.instrucciones.text = "TOCA EL PAPEL Y ARRASTRALO HACIA EL CENTRO"


func _on_area_2d_input_event(_viewport, _event, _shape_idx):
	pass
