extends RigidBody2D

var velocidade_constante = 200
var desaceleramento = velocidade_constante * 0.4
#
func _integrate_forces(state):
	var velocidade_atual = state.linear_velocity
	
	state.linear_velocity = Vector2(velocidade_constante,velocidade_atual.y)

func _on_body_entered(body):
	if body.is_in_group("jogador"):
		
		body.set_physics_process(false)
		
		get_parent()._on_abismo_body_entered(body)
		
			


func _on_detector_inversor_area_entered(area):
	if area.is_in_group("inversores"):
		var velocidade_constante_aux = velocidade_constante
		velocidade_constante = desaceleramento
		await get_parent().criar_pausa(0.4)
		velocidade_constante = velocidade_constante_aux * -1
		desaceleramento *= -1
	
