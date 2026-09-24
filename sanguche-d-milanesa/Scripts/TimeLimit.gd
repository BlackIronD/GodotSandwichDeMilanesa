extends Timer

@onready var progress_bar: ProgressBar = $"../TemperaturaSandwich"
@onready var sprite: Sprite2D = $"../Sprite2D"

@export var DecayRate := 10

var state := 0


func _ready() -> void:
	pass


func sandwich_state(new_state: int) -> void:
	state = new_state
	
	match state:
		0:
			sprite.texture = load("res://Sanwich.jpg")
		
		1:
			sprite.texture = load("res://Sanwiahstate1.png")
		
		2:
			sprite.texture = load("res://Sanwiahstate2.png")
		
		3:
			sprite.texture = load("res://Sanwiahstate3.png")


func _process(delta: float) -> void:
	var temperature = progress_bar.value / 50.0
	progress_bar.modulate = Color.BLUE.lerp(Color.RED, temperature)


func _on_timeout() -> void:
	progress_bar.value -= DecayRate
