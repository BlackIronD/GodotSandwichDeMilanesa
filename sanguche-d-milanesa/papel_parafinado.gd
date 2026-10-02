extends Sprite2D

var click = false
var papel_colocado = false
var mi_offset = Vector2.ZERO
var distancia_para_colocar = 120

@onready var papel_seleccionado = $"../PapelSeleccionado"
@onready var guia_papel = $"../GuiaPapel"
@onready var papel_dentro_caja = $"../PapelDentroCaja"
@onready var fondo_armado_caja = $"../FondoArmadoCaja"

func _ready():
	papel_seleccionado.visible = false
	guia_papel.visible = false
	papel_dentro_caja.visible = false

func _process(_delta):
	if not fondo_armado_caja.visible:
		return

	if Input.is_action_just_pressed("left_click") and not papel_colocado:
		if is_pixel_opaque(to_local(get_global_mouse_position())):
			papel_seleccionado.global_position = get_global_mouse_position()
			papel_seleccionado.visible = true
			guia_papel.visible = true
			visible = false
			click = true
			mi_offset = papel_seleccionado.global_position - get_global_mouse_position()

	if click and not papel_colocado:
		papel_seleccionado.global_position = get_global_mouse_position() + mi_offset

	if Input.is_action_just_released("left_click") and click:
		click = false

		if papel_seleccionado.global_position.distance_to(guia_papel.global_position) < distancia_para_colocar:
			papel_seleccionado.global_position = guia_papel.global_position
			papel_seleccionado.visible = false
			guia_papel.visible = false
			papel_dentro_caja.visible = true
			papel_colocado = true
			$"../Instrucciones".text = "TOCA EL SANDWICH Y MUEVELO CON LAS TECLAS ← →.\n CUANDO ESTE EN LA CAJA, PRESIONA ENTER"
