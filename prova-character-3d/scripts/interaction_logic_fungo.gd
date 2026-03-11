extends SimpleInteractable
func on_enter() -> void:
	print("miao")
func interact() -> void:
	# Chiamiamo il Singleton
	GameManager.add_collected_npc()
	
	# Distruggiamo l'NPC padre
	get_parent().queue_free()
