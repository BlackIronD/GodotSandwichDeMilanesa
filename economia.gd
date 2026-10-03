
extends Node

const PAGO_BASE := 2000
const PROPINA_MAX := 1500
const UMBRAL_FRIO := 0.2          
const MULT_ROTO := 0.5
const MULT_FRIO := 0.6
const MULT_ROBADO := 0.0
const MULT_GASEOSA := 0.8
const MULT_BASE_TARDE := 0.7       

static func calcular(pedido: Dictionary) -> Dictionary:
	var ratio := clampf(pedido["tiempo_restante"] / pedido["tiempo_total"], 0.0, 1.0)
	if ratio < UMBRAL_FRIO:
		pedido["frio"] = true

	var detalle: Array[String] = []
	var base := PAGO_BASE
	var propina := PROPINA_MAX * ratio
	detalle.append("Pago base: $%d" % PAGO_BASE)
	detalle.append("Propina por tiempo (%d%%): $%d" % [roundi(ratio * 100), roundi(propina)])

	if ratio <= 0.0:
		base = roundi(base * MULT_BASE_TARDE)
		detalle.append("Llegaste tarde: -30% del pago")
	if pedido["roto"]:
		propina *= MULT_ROTO
		detalle.append("Pedido roto: -50% propina")
	if pedido["frio"]:
		propina *= MULT_FRIO
		detalle.append("Pedido frío: -40% propina")
	if pedido["gaseosa_derramada"]:
		propina *= MULT_GASEOSA
		detalle.append("Gaseosa derramada: -20% propina")
	if pedido["robado"]:
		propina *= MULT_ROBADO
		detalle.append("Te robaron: sin propina")

	var propina_final := roundi(propina)
	return {
		"base": base,
		"propina": propina_final,
		"total": base + propina_final,
		"detalle": detalle,
	}
