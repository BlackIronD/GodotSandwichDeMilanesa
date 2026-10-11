
extends Area2D

@export var cold_threshold_pct: float = 35.0
@export var broken_hits: int = 2

@onready var temperatura_sandwich: ProgressBar = $"../Camera2D/Control/TemperaturaSandwich"
@onready var label: Label = $"../Camera2D/EndPanel/Panel/Label"
@onready var end_panel: Control = $"../Camera2D/EndPanel"
@onready var boton_resultados: Button = $"../Camera2D/EndPanel/Panel/VerResultados"
@onready var sonido_final: AudioStreamPlayer = $SonidoFinal
@onready var musica_nivel: AudioStreamPlayer = $"../MusicaNivel"

var delivered: bool = false


func _ready() -> void:
	end_panel.visible = false

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

	if not boton_resultados.pressed.is_connected(_abrir_resultados):
		boton_resultados.pressed.connect(_abrir_resultados)


func _on_body_entered(body: Node2D) -> void:
	if delivered or not body.has_method("take_hit"):
		return

	if body.sandwich_quantity <= 0:
		return

	delivered = true
	
	sonido_final.play()
	
	musica_nivel.stop()

	var is_broken: bool = body.sandwich_hits >= broken_hits

	var pct: float = 0.0

	if temperatura_sandwich.max_value > 0:
		pct = (
			temperatura_sandwich.value
			/ temperatura_sandwich.max_value
			* 100.0
		)

	var is_cold: bool = pct <= cold_threshold_pct

	GameState.pedido_roto = is_broken
	GameState.pedido_frio = is_cold

	if is_broken and is_cold:
		GameState.estado_pedido = "Roto + Frío"
	elif is_broken:
		GameState.estado_pedido = "Roto"
	elif is_cold:
		GameState.estado_pedido = "Frío"
	else:
		GameState.estado_pedido = "Intacto"

	GameState.propina = _roll_tip()

	var pay: int = GameState.calcular_pago()

	GameState.monto_propina = GameState.propina
	GameState.monto_noche = pay - GameState.propina
	GameState.total_noche = pay

	GameState.money += pay

	label.text = (
		"¡Pedido entregado!\n"
		+ "Pago: $\n" + str(pay)
		+ "\nDinero acumulado: \n$"
		+ str(GameState.money)
	)

	end_panel.visible = true


func _roll_tip() -> int:

	if randf() > 0.40:
		return 0

	var r: float = randf()

	if r <= 0.50:
		return 7500

	elif r <= 0.75:
		return randi_range(0, 1000)

	else:
		return 7000


func _abrir_resultados() -> void:
	get_tree().change_scene_to_file("res://resultados.tscn")
