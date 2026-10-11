extends Control

const TITULOS := {
	"Intacto": "¡Entrega perfecta!",
	"Roto": "Llegó hecho un lío",
	"Frío": "Llegó frío",
	"Roto + Frío": "Frío y destrozado… noche dura"
}

@onready var titulo: Label = $PanelResultados/Titulo
@onready var tiempo_label: Label = $PanelResultados/TiempoLabel
@onready var estado_label: Label = $PanelResultados/EstadoLabel
@onready var pago_label: Label = $PanelResultados/PagoLabel
@onready var propina_label: Label = $PanelResultados/PropinaLabel
@onready var total_label: Label = $PanelResultados/TotalLabel
@onready var plata_label: Label = $PanelResultados/PlataLabel

@onready var pasar_nivel: Button = $PanelResultados/PasarNivel
@onready var volver_menu: Button = $PanelResultados/VolverMenu


func _ready() -> void:
	titulo.text = TITULOS.get(
		GameState.estado_pedido,
		"Resultados de la noche"
	)

	tiempo_label.text = "Tiempo transcurrido: " + GameState.tiempo_noche
	estado_label.text = "Estado del pedido: " + GameState.estado_pedido
	pago_label.text = "Pago sin propina: $" + str(GameState.monto_noche)

	if GameState.monto_propina > 0:
		propina_label.text = "Propina: $" + str(GameState.monto_propina)
	else:
		propina_label.text = "Propina: —"

	total_label.text = "Total ganado: $" + str(GameState.total_noche)
	plata_label.text = "Plata acumulada: $" + str(GameState.money)

	pasar_nivel.pressed.connect(_pasar_nivel)
	volver_menu.pressed.connect(_volver_al_menu)


func _pasar_nivel() -> void:
	Global.nivel_siguiente = 2
	MusicaMenu.detener()
	get_tree().change_scene_to_file("res://minijuego_caja.tscn")


func _volver_al_menu() -> void:
	MusicaMenu.reproducir()
	get_tree().change_scene_to_file("res://menu_principal.tscn")
