extends Node2D
var level
var cantSandwiches

signal LostSandwich
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (level == 0):
		cantSandwiches = 2
	if (level == 1):
		cantSandwiches = 4
	if (level == 2):
		cantSandwiches = 8

func LooseSandwich():
	
	cantSandwiches -= 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
