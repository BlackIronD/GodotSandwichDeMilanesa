extends Control


func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")

func _on_boton_salir_pressed() -> void:
	get_tree().quit()


func _on_boton_mejoras_pressed() -> void:
	get_tree().change_scene_to_file("res://mejoras.tscn")
