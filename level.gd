extends Node2D

func _on_objetivo_body_entered(body):
	# Verifica se quem encostou foi o jogador
	if body.is_in_group("jogador"):
		print("Parabéns! Fase Concluída!")
		
		# Reinicia a fase para jogar de novo
		get_tree().reload_current_scene()
