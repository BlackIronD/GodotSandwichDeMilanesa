extends Area2D

@onready var temperatura_sandwich: ProgressBar = $"../Camera2D/Control/TemperaturaSandwich"
@onready var sprite_2d: Sprite2D = $"../Camera2D/Control/Sprite2D"
@export var SanwichState0: Texture2D
@export var SanwichState1: Texture2D
@export var SanwichState2: Texture2D
@export var SanwichState3: Texture2D
@onready var label: Label = $"../Camera2D/EndPanel/Panel/Label"
@onready var end_panel: Control = $"../Camera2D/EndPanel"


var Money
var JobPay = 100
var Bonus = 0
var ishardMode = false


func _ready() -> void:
	Money = JobPay
	body_entered.connect(_on_body_entered)
	end_panel.visible = false


func _on_body_entered(body: Node2D) -> void:
	
	
	if not body is CharacterBody2D:
		return

	print("PLAYER REACHED END")
	end_panel.visible = true
	Money = JobPay

	ishardMode = temperatura_sandwich.max_value == 450

	if sprite_2d.texture == SanwichState0:
		Money = Money

	elif sprite_2d.texture == SanwichState1:
		Money *= 0.80

	elif sprite_2d.texture == SanwichState2:
		Money *= 0.60

	elif sprite_2d.texture == SanwichState3:
		Money = 0


	var porcentaje = (temperatura_sandwich.value / temperatura_sandwich.max_value) * 100.0

	print("Temperature: ", temperatura_sandwich.value)
	print("Percentage: ", porcentaje)
	print("Hard mode: ", ishardMode)


	if ishardMode:

		Money += Bonus

		if porcentaje >= 75:
			Money *= 0.90

		elif porcentaje >= 50:
			Money *= 0.70

	else:

		if porcentaje >= 75:
			Money *= 0.70

		elif porcentaje >= 50:
			Money *= 0.50


	print("Final payment: ", Money)

	label.text = "Pago: " + str(Money)
