
extends Node

var money: int = 30000

var sandwiches_del_pedido: int = 3
var resistencia: String = "Normal"

var pedido_roto: bool = false
var pedido_frio: bool = false
var pedido_robado: bool = false

const PAGO_BASE: int = 15000
const DESCUENTO_ROTO: int = 3000
const DESCUENTO_FRIO: int = 1000

var propina: int = 0
var total_pedido: int = 0

var estado_pedido: String = "Intacto"
var tiempo_noche: String = "00:00"

var monto_noche: int = 0
var monto_propina: int = 0
var total_noche: int = 0


func calcular_pago() -> int:
	var pago: int = PAGO_BASE

	if pedido_roto:
		pago -= DESCUENTO_ROTO

	if pedido_frio:
		pago -= DESCUENTO_FRIO

	pago += propina

	total_pedido = pago
	return total_pedido
