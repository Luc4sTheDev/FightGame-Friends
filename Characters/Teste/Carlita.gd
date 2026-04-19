extends Fighterz
class_name BonecoTeste

func powerUp():
	print("Kakaia")
func powerDown():
	print("Kukula")
func powerNeutral():
	print("Ratalos")

func _on_hurt_box_cima_area_entered(area: Area2D) -> void:
	var atacante = area.get_parent()
	if atacante.has_method("takeDamage"):
		takeDamage(atacante.dano_atual, atacante.e_critico_agora)

func _on_hurt_box_medio_area_entered(area: Area2D) -> void:
	if area.name == "HitBoxMedio":
		takeDamage(0.1)

func _on_hurtbox_baixo_area_entered(area: Area2D) -> void:
	if area.name == "HitBoxBaixo":
		takeDamage(0.1)
