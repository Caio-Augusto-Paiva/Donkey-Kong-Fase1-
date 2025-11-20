extends RigidBody2D

var velocidade_constante = 100

#func _integrate_forces(state):
	#var velocidade_atual = state.linear_velocity
	#
	#state.linear_velocity = Vector2(velocidade_constante,velocidade_atual.y)

func _on_body_entered(body):
	if body.is_in_group("jogador"):
		
		body.set_physics_process(false)
		
		get_parent()._on_abismo_body_entered(body)
		
			
