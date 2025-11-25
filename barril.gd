extends RigidBody2D

var velocidade_constante = 200 # valor base da velocidade do barril
var desaceleramento = velocidade_constante * 0.4 # desaceleramento para mudança gradual de direção
var multiplicador_aletororio = randf_range(0.9,1.3) # multiplicador para velocidade base -> aumentar a dificuldade do jogo

func _integrate_forces(state):
	var velocidade_atual_y = state.linear_velocity.y
	
	state.linear_velocity = Vector2(velocidade_constante*multiplicador_aletororio,velocidade_atual_y) # altera a velocidade x do barril

func _on_body_entered(body):
	if body.is_in_group("jogador"): # caso haja colisão com jogador
		
		body.set_physics_process(false) # jogador para
		
		get_parent()._on_abismo_body_entered(body) # game over (mesmo game over do abismo)
		
			


func _on_detector_inversor_area_entered(area):
	if area.is_in_group("inversores"): # caso haja colisão com inversor
		var velocidade_constante_aux = velocidade_constante 
		velocidade_constante = desaceleramento # desacelara
		await get_parent().criar_pausa(0.4) # pausa para que o barril caia na proxima plataforma
		velocidade_constante = velocidade_constante_aux * -1 # inverte velocidade
		desaceleramento *= -1 # inverte desaceleramento para o proximo inversor funcionar corretamente
	
