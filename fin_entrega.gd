extends Control


@onready var ganancias_label = $Ganancias
@onready var propinas_label = $Propinas
@onready var total_label = $Total
@onready var continuar_button = $Continuar


func _ready():

	ganancias_label.text = "Ganancias: $" + str(Economia.ganancias)

	propinas_label.text = "Propinas: $" + str(Economia.propinas)

	total_label.text = "TOTAL: $" + str(Economia.dinero_total)

	continuar_button.pressed.connect(_on_continuar_pressed)


func _on_continuar_pressed():

	get_tree().change_scene_to_file("res://escenas/menu.tscn")
