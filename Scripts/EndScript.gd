extends Area2D

@onready var temperatura_sandwich: ProgressBar = $"../Camera2D/Control/TemperaturaSandwich"
@onready var sprite_2d: Sprite2D = $"../Camera2D/Control/Sprite2D"

@onready var label: Label = $"../Camera2D/EndPanel/Panel/Label"
@onready var end_panel: Control = $"../Camera2D/EndPanel"

@export var JobPay := 100.0


@export var max_time := 120.0


@export var time_penalty_per_second := 1.0

var Money := 0.0
var Bonus := 0.0
var ishardMode := false

var start_time := 0.0
var initial_sandwich_quantity := 0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	end_panel.visible = false

	
	start_time = Time.get_ticks_msec() / 1000.0


func _on_body_entered(body: Node2D) -> void:

	if not body is CharacterBody2D:
		return

	print("PLAYER REACHED END")

	end_panel.visible = true

	var sandwich_quantity = body.sandwich_quantity
	var sandwich_hits = body.sandwich_hits
	var hits_per_sandwich = body.hits_per_sandwich

	print("Sandwiches remaining: ", sandwich_quantity)
	print("Current sandwich hits: ", sandwich_hits, "/", hits_per_sandwich)


	if initial_sandwich_quantity <= 0:
		initial_sandwich_quantity = sandwich_quantity

	var total_sandwiches = initial_sandwich_quantity


	if total_sandwiches <= 0:
		label.text = "Pago: $0"
		return


	var money_per_sandwich = JobPay / float(total_sandwiches)

	print("Total sandwiches: ", total_sandwiches)
	print("Money per sandwich: ", money_per_sandwich)


	var delivered_sandwiches = total_sandwiches - sandwich_quantity

	if delivered_sandwiches < 0:
		delivered_sandwiches = 0

	var delivered_money = delivered_sandwiches * money_per_sandwich


	var current_sandwich_multiplier := 1.0

	if hits_per_sandwich > 0:

		if sandwich_hits == 0:
			current_sandwich_multiplier = 1.0

		elif sandwich_hits == 1:
			current_sandwich_multiplier = 0.80

		elif sandwich_hits == 2:
			current_sandwich_multiplier = 0.60

		else:
		
			current_sandwich_multiplier = 0.0


	var current_sandwich_money := 0.0

	if sandwich_quantity > 0:
		current_sandwich_money = money_per_sandwich * current_sandwich_multiplier


	Money = delivered_money + current_sandwich_money


	print("Delivered sandwiches: ", delivered_sandwiches)
	print("Delivered money: ", delivered_money)
	print("Current sandwich multiplier: ", current_sandwich_multiplier)
	print("Current sandwich money: ", current_sandwich_money)
	print("Money before time penalty: ", Money)



	var current_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = current_time - start_time

	print("Elapsed time: ", elapsed_time)


	if elapsed_time > max_time:

		var overtime = elapsed_time - max_time
		var time_penalty = overtime * time_penalty_per_second

		Money -= time_penalty

		print("Overtime: ", overtime)
		print("Time penalty: ", time_penalty)

	Money = max(Money, 0.0)


	ishardMode = temperatura_sandwich.max_value == 450

	var porcentaje := 0.0

	if temperatura_sandwich.max_value > 0:
		porcentaje = (temperatura_sandwich.value / temperatura_sandwich.max_value) * 100.0

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


	Money = max(Money, 0.0)

	print("Final payment: ", Money)

	label.text = "Pago: $" + str(round(Money))
