extends Area2D

const PAY_INTACT := 15000
const PAY_STOLEN := 10000  # sin usar todavía
const PAY_BROKEN := 3000
const PAY_COLD := 1000

@export var cold_threshold_pct := 35.0  # 20.0 con Caja térmica
@export var broken_hits := 2            # golpes acumulados para "roto" (1 = como tenías antes)

@onready var temperatura_sandwich: ProgressBar = $"../Camera2D/Control/TemperaturaSandwich"
@onready var label: Label = $"../Camera2D/EndPanel/Panel/Label"
@onready var end_panel: Control = $"../Camera2D/EndPanel"

var delivered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	end_panel.visible = false


func _on_body_entered(body: Node2D) -> void:
	if delivered or not body.has_method("take_hit"):
		return
	delivered = true
	end_panel.visible = true

	var pay := 0
	if body.sandwich_quantity > 0:
		var is_broken: bool = body.sandwich_hits >= broken_hits
		var pct := temperatura_sandwich.value / temperatura_sandwich.max_value * 100.0
		var is_cold := pct <= cold_threshold_pct
		pay = _calc_pay(is_broken, is_cold)

	GameState.money += pay
	label.text = "Pago: $" + str(pay)


func _calc_pay(broken: bool, cold: bool) -> int:
	if cold:
		return PAY_COLD  # incluye roto + frío
	if broken:
		return PAY_BROKEN
	return PAY_INTACT + _roll_tip()


func _roll_tip() -> int:
	if randf() > 0.40:
		return 0
	var r := randf()
	if r <= 0.50:
		return 7500
	elif r <= 0.75:
		return randi_range(0, 1000)
	return 7000  # revisar: ¿debería ser > 7500?
