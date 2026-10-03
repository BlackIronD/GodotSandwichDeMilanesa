extends Node2D
@onready var pantalla_negra = $CanvasLayer/ColorRect
@onready var timer = $Timer

var blackout_activo := false


func _ready():
	pantalla_negra.color = Color(0, 0, 0, 0)

	timer.wait_time = 5.0
	timer.one_shot = true


func activar_blackout():

	if blackout_activo:
		return

	blackout_activo = true

	var tween = create_tween()

	tween.tween_property(
		pantalla_negra,
		"color",
		Color(0, 0, 0, 0.85),
		1.0
	)

	timer.start()


func _on_timer_timeout():

	var tween = create_tween()

	tween.tween_property(
		pantalla_negra,
		"color",
		Color(0, 0, 0, 0),
		1.0
	)

	blackout_activo = false
