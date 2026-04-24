extends Fighterz
class_name BonecoTeste

func powerUp():
	print("Kakaia")
func powerDown():
	print("Kukula")
func powerNeutral():
	print("Ratalos")

func _on_hurt_box_cima_area_entered(area: Area2D) -> void:
		var atacante = area.owner 
		if atacante is Fighterz and atacante != self:
			if "HitBoxCima" in area.name:
				takeDamage(atacante.dano_atual, atacante.e_critico_agora)

func _on_hurt_box_medio_area_entered(area: Area2D) -> void:
	var atacante = area.owner 
	if atacante is Fighterz and atacante != self:
		if "HitBoxMedio" in area.name:
			takeDamage(atacante.dano_atual, atacante.e_critico_agora)

func _on_hurtbox_baixo_area_entered(area: Area2D) -> void:
	var atacante = area.owner 
	if atacante is Fighterz and atacante != self:
		if "HitBoxBaixo" in area.name:
			takeDamage(atacante.dano_atual, atacante.e_critico_agora)
