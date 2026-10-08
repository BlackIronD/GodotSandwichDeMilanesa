extends Sprite2D

var click = false
var sandwich_colocado = false
var mi_offset = Vector2.ZERO
var distancia_para_colocar = 100
var velocidad_rotacion = 0.01

@onready var guia_sandwich = $"../GuiaSandwich"
@onready var papel_dentro_caja = $"../PapelDentroCaja"
@onready var caja_superpuesta = $"../CajaSuperpuesta"

func _ready():
	guia_sandwich.visible = false
	caja_superpuesta.visible = false


func _process(_delta):

	if Input.is_key_pressed(KEY_ENTER):
		click = false
		sandwich_colocado = true
		guia_sandwich.visible = false
		$"../Instrucciones".text = "TOCA LA CAJA Y ARRASTRALA HACIA EL CENTRO."
		return

	if sandwich_colocado:
		return

	if not papel_dentro_caja.visible:
		return

	if Input.is_action_just_pressed("left_click"):
		if is_pixel_opaque(to_local(get_global_mouse_position())):

			caja_superpuesta.visible = true
			guia_sandwich.visible = true

			click = true
			mi_offset = global_position - get_global_mouse_position()


	if click:
		global_position = get_global_mouse_position() + mi_offset

		if Input.is_key_pressed(KEY_LEFT) or Input.is_key_pressed(KEY_A):
			rotation -= velocidad_rotacion

		if Input.is_key_pressed(KEY_RIGHT) or Input.is_key_pressed(KEY_D):
			rotation += velocidad_rotacion


	if Input.is_action_just_released("left_click") and click:
		click = false

		if global_position.distance_to(guia_sandwich.global_position) < distancia_para_colocar:
			global_position = guia_sandwich.global_position
			guia_sandwich.visible = false
			sandwich_colocado = true


func _on_caja_tapar_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("AGARRE LA TAPA")
