extends Node2D

var cena_barril = preload("res://barril.tscn")

func reiniciar_fase():
	get_tree().reload_current_scene()
	
func criar_pausa(tempo : float = 1):
	await get_tree().create_timer(tempo).timeout


func _on_timer_timeout() -> void:
	var novo_barril = cena_barril.instantiate()
	
	novo_barril.position = $SpawBarril.position
	
	add_child(novo_barril)
	
	novo_barril.linear_velocity = Vector2(300.0,0)
	

func _on_objetivo_body_entered(body):
	# Verifica se quem encostou foi o jogador
	if body.is_in_group("jogador"):
		print("Você ganhou, parabéns!")
		
		body.set_physics_process(false)
		await criar_pausa(2.2)	
		# Reinicia a fase para jogar de novo
		call_deferred("reiniciar_fase")


func _on_abismo_body_entered(body):
	if body.is_in_group("jogador"):
		print("Game Over!")
		
		await criar_pausa()
		
		call_deferred("reiniciar_fase")
		
# call_deferred evita erros -> caso o godot esteja vazendo cálculos irá espera acabar os cálculos para chamar a função
