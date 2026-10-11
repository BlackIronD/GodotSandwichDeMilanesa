
extends Timer

@onready var progress_bar: ProgressBar = $"../TemperaturaSandwich"
@onready var tiempo_label: Label = $"../TiempoLabel"

@onready var sandwich1: Sprite2D = $"../SandwichIcon/Sandwich1"
@onready var sandwich2: Sprite2D = $"../SandwichIcon/Sandwich2"
@onready var sandwich3: Sprite2D = $"../SandwichIcon/Sandwich3"
@onready var sandwich4: Sprite2D = $"../SandwichIcon/Sandwich4"
@onready var sandwich5: Sprite2D = $"../SandwichIcon/Sandwich5"
@onready var sandwich6: Sprite2D = $"../SandwichIcon/Sandwich6"

@export var DecayRate: float = 10.0

var state: int = 0
var tiempo_restante: int = 45


func _ready() -> void:
	wait_time = 1.0
	one_shot = false
	tiempo_restante = 45

	sandwich_state(0)

	tiempo_label.text = "Tiempo: 45"
	GameState.tiempo_noche = "00:00"

	if not timeout.is_connected(_on_timeout):
		timeout.connect(_on_timeout)

	start()


func sandwich_state(new_state: int) -> void:
	state = clampi(new_state, 0, 5)

	sandwich1.visible = state == 0
	sandwich2.visible = state == 1
	sandwich3.visible = state == 2
	sandwich4.visible = state == 3
	sandwich5.visible = state == 4
	sandwich6.visible = state == 5


func avanzar_sandwich() -> void:
	if state < 5:
		sandwich_state(state + 1)


func _process(_delta: float) -> void:
	var temperatura: float = progress_bar.value / 50.0
	progress_bar.modulate = Color.BLUE.lerp(Color.RED, temperatura)


func _on_timeout() -> void:
	if tiempo_restante <= 0:
		stop()
		tiempo_label.text = "Tiempo: 0\n¡Tiempo terminado!"
		guardar_tiempo()
		return

	tiempo_restante -= 1
	guardar_tiempo()

	if tiempo_restante <= 15 and tiempo_restante > 5:
		tiempo_label.text = "Tiempo: %d\n¡El sándwich se está enfriando!" % tiempo_restante
	elif tiempo_restante <= 5:
		tiempo_label.text = "Tiempo: %d\n¡Sándwich frío!" % tiempo_restante
	else:
		tiempo_label.text = "Tiempo: %d" % tiempo_restante

	progress_bar.value = maxf(
		0.0,
		progress_bar.value - DecayRate
	)


func guardar_tiempo() -> void:
	var transcurrido: int = 45 - tiempo_restante
	var minutos: int = floori(float(transcurrido) / 60.0)
	var segundos: int = transcurrido % 60

	GameState.tiempo_noche = "%02d:%02d" % [minutos, segundos]
