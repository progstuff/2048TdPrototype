extends Control

@onready var container = $MarginContainer/HFlowContainer

var cooldownIconScene = load("res://Data/BonusCooldownIconScene.tscn")

var cooldownBonuses = []

func add_bonus_cooldown(_image:Texture2D, _cooldown: float):
	if(_cooldown <= 0.1):
		return
	var cooldownIcon = null
	if(cooldownBonuses.is_empty()):
		cooldownIcon = cooldownBonuses.pop_front()
	cooldownIcon = cooldownIconScene.instantiate()
	container.add_child(cooldownIcon)
	cooldownIcon.init(self, _image, _cooldown)
	cooldownIcon.activate()

func remove_bonus_cooldown(_bonusCooldownIcon: Control):
	_bonusCooldownIcon.deactivate()
	container.remove_child(_bonusCooldownIcon)
	cooldownBonuses.append(_bonusCooldownIcon)

func restart():
	for bonusCooldownItem in container.get_children():
		remove_bonus_cooldown(bonusCooldownItem)
