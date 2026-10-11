extends Area2D

@onready var sonido_pickup = $SonidoPickup

func _on_body_entered(body):

	if body.is_in_group("jugador"):
		Global.papas += 1
		
		print("🥔 Agarraste una papa")
		print("🥔 Total de papas: ", Global.papas)
		
		sonido_pickup.play()
		
		$Sprite2D.hide()
		$CollisionShape2D.set_deferred("disabled", true)
		
		await sonido_pickup.finished
		queue_free()
