extends CharacterBody2D

# --- Variáveis de Ajuste (Equações) ---
const VELOCIDADE_HORIZONTAL = 150.0
const FORCA_PULO = -300.0
const VELOCIDADE_ESCALADA = 100.0
const GRAVIDADE = 980.0

# --- Variáveis de Estado ---
var esta_na_escada = false

func _physics_process(delta):
	
	# --- [NOVO] TRAVA DE SEGURANÇA ---
	# Se o jogo acha que NÃO estamos na escada, verificamos manualmente
	# se o detector está tocando em alguma área do grupo "escadas".
	if not esta_na_escada:
		# Pega todas as áreas que o Detector está tocando agora
		var areas_tocadas = $DetectorEscada.get_overlapping_areas()
		for area in areas_tocadas:
			if area.is_in_group("escadas"):
				esta_na_escada = true
				break # Achou uma escada, para de procurar
	# ---------------------------------

	# 1. Aplicar Gravidade
	# Só aplicamos gravidade se NÃO estiver no chão E NÃO estiver segurando na escada
	if not is_on_floor() and not esta_na_escada:
		velocity.y += GRAVIDADE * delta

	# 2. Movimento Horizontal (Andar)
	var direcao = Input.get_axis("ui_left", "ui_right")
	
	if direcao != 0:
		velocity.x = direcao * VELOCIDADE_HORIZONTAL
		if direcao < 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, VELOCIDADE_HORIZONTAL)

	# 3. Lógica da Escada
	if esta_na_escada:
		# Se está na escada, a gravidade não afeta, nós controlamos o Y manualmente
		var direcao_vertical = Input.get_axis("ui_up", "ui_down")
		velocity.y = direcao_vertical * VELOCIDADE_ESCALADA
	
	# 4. Pulo
	# Pode pular se estiver no chão OU se estiver na escada
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or esta_na_escada):
		velocity.y = FORCA_PULO
		esta_na_escada = false # Se pular, solta da escada imediatamente

	# 5. Aplica o movimento final
	move_and_slide()

# --- Sinais do DetectorEscada ---

# Mantemos os sinais para garantir que ele saia da escada quando se afastar
func _on_detector_escada_area_entered(area):
	if area.is_in_group("escadas"):
		esta_na_escada = true

func _on_detector_escada_area_exited(area):
	if area.is_in_group("escadas"):
		esta_na_escada = false
