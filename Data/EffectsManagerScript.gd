extends Node
var poisonEffects = []
var freezeEffects = []

var posionEffectScene = load("res://Data/PoisonEffectScene.tscn")
var freezeEffectScene = load("res://Data/FreezeEffectScene.tscn")

func create_poison_effect() -> Node:
	var effect
	if(poisonEffects.size() > 0):
		effect = poisonEffects.pop_front()
	else:
		effect = posionEffectScene.instantiate()
		add_child(effect)
	effect.set_manager(self)
	
	return effect

func create_freeze_effect() -> Node:
	var effect
	if(freezeEffects.size() > 0):
		effect = freezeEffects.pop_front()
	else:
		effect = freezeEffectScene.instantiate()
		add_child(effect)
	effect.set_manager(self)
	
	return effect
	
func remove_poison_effect(_effect: Node):
	poisonEffects.append(_effect)

func remove_freeze_effect(_effect: Node):
	freezeEffects.append(_effect)
