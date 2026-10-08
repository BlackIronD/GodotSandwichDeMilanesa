extends Control

@onready var volumen = $VBoxContainer/Volumen
@onready var pantalla_completa = $VBoxContainer/PantallaCompleta


func _ready() -> void:
	volumen.value = 100
	pantalla_completa.button_pressed = false


func _on_volumen_value_changed(value: float) -> void:
	var bus = AudioServer.get_bus_index("Master")
	
	if value <= 0:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		AudioServer.set_bus_volume_db(bus, linear_to_db(value / 100.0))


func _on_pantalla_completa_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_boton_volver_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_principal.tscn")
