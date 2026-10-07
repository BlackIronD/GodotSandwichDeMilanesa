extends Control

var plata: int = 30000

var nombres = [
	"Mejora 1",
	"Protección Básica",
	"Conservadora",
	"Caja Térmica",
	"Zapatillas",
	"Protección Reforzada",
	"Mochila Grande PeligrosYa"
]

var precios = [
	15000,
	20000,
	25000,
	30000,
	35000,
	40000,
	45000
]

var compradas = [
	false,
	false,
	false,
	false,
	false,
	false,
	false
]

var mejora_seleccionada: int = -1

@onready var confirmar_compra = $ConfirmarCompra
@onready var cantidad_dinero = $DineroDisponible/CantidadDinero

func _ready() -> void:
	confirmar_compra.confirmed.connect(_on_confirmar_compra_confirmed)

	for i in range(7):
		var boton = get_node("TiendaScroll/Cartas/Mejora" + str(i + 1) + "/BotonComprar")
		boton.pressed.connect(_comprar_mejora.bind(i))

	actualizar_botones()
	actualizar_dinero()
	
func actualizar_dinero() -> void:
	cantidad_dinero.text = "$" + str(plata)

func actualizar_botones() -> void:
	for i in range(7):
		var boton = get_node("TiendaScroll/Cartas/Mejora" + str(i + 1) + "/BotonComprar")

		if compradas[i]:
			boton.text = "Comprada"
		elif plata < precios[i]:
			boton.text = "Te falta plata"
		else:
			boton.text = "Comprar"

func _comprar_mejora(indice: int) -> void:

	if compradas[indice]:
		return

	if plata < precios[indice]:
		var boton = get_node("TiendaScroll/Cartas/Mejora" + str(indice + 1) + "/BotonComprar")
		boton.text = "Te falta plata"
		return

	mejora_seleccionada = indice

	confirmar_compra.dialog_text = "¿Comprar " + nombres[indice] + " por $" + str(precios[indice]) + "?"
	confirmar_compra.popup_centered()


func _on_confirmar_compra_confirmed() -> void:

	if mejora_seleccionada == -1:
		return

	plata -= precios[mejora_seleccionada]
	compradas[mejora_seleccionada] = true
	actualizar_dinero()

	var boton = get_node(
		"TiendaScroll/Cartas/Mejora" + str(mejora_seleccionada + 1) + "/BotonComprar"
	)

	boton.text = "¡Listo! Ya es tuya."

	print("Compraste: ", nombres[mejora_seleccionada])
	print("Plata restante: $", plata)

	mejora_seleccionada = -1

	actualizar_botones()


func _on_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
