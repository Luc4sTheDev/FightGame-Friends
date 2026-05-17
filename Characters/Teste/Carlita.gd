extends Fighterz
class_name BonecoTeste

func execute_attack(stage: int):
	if stage >= hitboxes.size():
		return
	
	var hitbox_atual = hitboxes[stage]
	
	match stage:
		0:
			hitBoxActivate(hitbox_atual, 0.1, 0.2)
			play_anim(data.highpunch_anim)
		1:
			hitBoxActivate(hitbox_atual, 0.1, 0.2)
			play_anim(data.mediumpunch_anim)
		2:
			hitBoxActivate(hitbox_atual, 0.3, 0.2)
			play_anim(data.lowkick_anim)

func powerUp():
	print("Kakaia")
func powerDown():
	print("Kukula")
func powerNeutral():
	print("Ratalos")

func _on_hurt_box_cima_area_entered(area: Area2D) -> void:
	var atacante = area.owner
	if atacante is Fighterz and atacante != self:
		if "HitBoxForte" in area.name:
			takeDamage(atacante.dano_atual, atacante.global_position, atacante.e_critico_agora, $Pivot/Cranio)
			knockback(atacante.global_position, 400.0)
			
		elif "HitBoxCima" in area.name:
			takeDamage(atacante.dano_atual, atacante.global_position, atacante.e_critico_agora, $Pivot/Cranio)
			
func _on_hurt_box_medio_area_entered(area: Area2D) -> void:
	var atacante = area.owner
	if atacante is Fighterz and atacante != self:
		if "HitBoxForte" in area.name:
			takeDamage(atacante.dano_atual, atacante.global_position, atacante.e_critico_agora, $Pivot/RibCage)
			knockback(atacante.global_position, 400.0)
			
		elif "HitBoxMedio" in area.name:
			takeDamage(atacante.dano_atual, atacante.global_position, atacante.e_critico_agora, $Pivot/RibCage)

func _on_hurtbox_baixo_area_entered(area: Area2D) -> void:
	var atacante = area.owner
	if atacante is Fighterz and atacante != self:
		if "HitBoxForte" in area.name:
			takeDamage(atacante.dano_atual, atacante.global_position, atacante.e_critico_agora, $Pivot/Legs)
			knockback(atacante.global_position, 400.0)

		elif "HitBoxBaixo" in area.name:
			takeDamage(atacante.dano_atual, atacante.global_position, atacante.e_critico_agora, $Pivot/Legs)
