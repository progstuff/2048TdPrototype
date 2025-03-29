extends Node
var poisonEffects = []

var posionEffectScene = load("res://Data/PoisonEffectScene.tscn")

func create_poison_effect() -> Node:
	var effect
	if(poisonEffects.size() > 0):
		effect = poisonEffects.pop_front()
	else:
		effect = posionEffectScene.instantiate()
		add_child(effect)
	effect.set_manager(self)
	

	
	return effect

func remove_poison_effect(_effect: Node):
	poisonEffects.append(_effect)
