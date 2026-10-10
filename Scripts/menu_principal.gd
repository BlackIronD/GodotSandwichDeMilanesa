extends Control

@onready var confirmar_salir = $ConfirmarSalir

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://minijuego_caja.tscn")
	
func _on_boton_opciones_pressed() -> void:
	get_tree().change_scene_to_file("res://opciones.tscn")

func _on_boton_salir_pressed() -> void:
	confirmar_salir.popup_centered()

func _on_boton_mejoras_pressed() -> void:
	get_tree().change_scene_to_file("res://mejoras.tscn")

func _on_confirmar_salir_confirmed() -> void:
	get_tree().quit()
