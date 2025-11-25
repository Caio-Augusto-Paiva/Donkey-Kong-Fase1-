extends Node2D

var cena_barril = preload("res://barril.tscn")

func reiniciar_fase():
	get_tree().reload_current_scene()
	
func criar_pausa(tempo : float = 1):
	await get_tree().create_timer(tempo).timeout

func criar_barril(): # cria barril no Maker colocado na mao do Kong
	var novo_barril = cena_barril.instantiate()
	
	novo_barril.position = $SpawBarril.position
	
	add_child(novo_barril)

func _ready(): # inicia o level criando um barril
	await criar_pausa(0.5)
	criar_barril()

func _on_timer_timeout(): # quando o timer acabar spawna um novo barril
	criar_barril()
	

func _on_objetivo_body_entered(body):
	if body.is_in_group("jogador"): # caso princesa colida com o jogador
		print("Você ganhou, parabéns!") 
		
		body.set_physics_process(false)
		await criar_pausa(2.2)	# pausa para diregir a vitoria
		call_deferred("reiniciar_fase") # reinicia a fase 


func _on_abismo_body_entered(body):
	if body.is_in_group("jogador"): # caso jogador colida com o abismo
		print("Game Over!")
		
		await criar_pausa() # pausa para diregir o game over
		
		call_deferred("reiniciar_fase") # reinicia a fase
		
		
# call_deferred evita erros -> caso o godot esteja fazendo cálculos irá espera acabar os cálculos para chamar a função
