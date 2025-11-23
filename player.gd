extends CharacterBody2D

const VELOCIDADE_HORIZONTAL = 150.0
const FORCA_PULO = -300.0
const VELOCIDADE_ESCALADA = 100.0
const GRAVIDADE = 980.0

var esta_na_escada = false #booleano para identificar se o player esta na escada

func _physics_process(delta):
	
	if not esta_na_escada:
		var areas_tocadas = $DetectorEscada.get_overlapping_areas()
		for area in areas_tocadas:
			if area.is_in_group("escadas"):
				esta_na_escada = true
				break 

	if not is_on_floor() and not esta_na_escada: # se nao esta no chao aplica a gravidade
		velocity.y += GRAVIDADE * delta

	var direcao = Input.get_axis("ui_left", "ui_right") #somento movimento horizontal 
	#pois a vertical so é mudada na escada
	
	if direcao != 0:
		velocity.x = direcao * VELOCIDADE_HORIZONTAL
		if direcao < 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDADE_HORIZONTAL)

	if esta_na_escada:
		var direcao_vertical = Input.get_axis("ui_up", "ui_down")
		velocity.y = direcao_vertical * VELOCIDADE_ESCALADA
	
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or esta_na_escada):
		velocity.y = FORCA_PULO
		esta_na_escada = false #quando pular sai da escada sozinho

	move_and_slide()

# parte dos sinais ligados pela godot
func _on_detector_escada_area_entered(area):
	if area.is_in_group("escadas"):
		esta_na_escada = true

func _on_detector_escada_area_exited(area):
	if area.is_in_group("escadas"):
		esta_na_escada = false
