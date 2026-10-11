
extends Node

var SonidoMenu: AudioStreamPlayer
var musica_habilitada := true

func _ready() -> void:
	SonidoMenu = AudioStreamPlayer.new()
	SonidoMenu.name = "SonidoMenu"
	add_child(SonidoMenu)

	SonidoMenu.stream = load("res://Audio/SonidoMenu.mp3")
	SonidoMenu.volume_db = 3.0
	SonidoMenu.finished.connect(_reproducir_de_nuevo)
	SonidoMenu.play()

func _reproducir_de_nuevo() -> void:
	if musica_habilitada:
		SonidoMenu.play()

func detener() -> void:
	musica_habilitada = false
	SonidoMenu.stop()

func reproducir() -> void:
	musica_habilitada = true
	if not SonidoMenu.playing:
		SonidoMenu.play()
