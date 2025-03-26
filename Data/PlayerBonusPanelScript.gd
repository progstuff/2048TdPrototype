extends Control

var activatedBonuses = {}
var bonuses = [null, null]
var slots = []

@onready var bonusOneSlot = $MarginContainer/HFlowContainer/BonusOne/BonusOneImage
@onready var bonusTwoSlot = $MarginContainer/HFlowContainer/BonusTwo/BonusTwoImage

func _ready() -> void:
	slots.insert(0, bonusOneSlot)
	slots.insert(1, bonusTwoSlot)

func is_full():
	for bonus in bonuses:
		if(bonus == null):
			return false
	return true
	
func _restart():
	activatedBonuses = {}
	bonuses = [null, null]
	slots[0].texture = null
	slots[1].texture = null
	
func _process(_delta: float) -> void:
	for bonusName in activatedBonuses:
		activatedBonuses[bonusName].process_bonus(_delta)
		
func add_bonus(_bonus: BonusElement):
		
	for i in range(0, bonuses.size()):
		if(bonuses[i] == null):
			bonuses[i] = _bonus
			slots[i].texture = _bonus.get_icon()
			break
			
func _on_bonus_one_image_gui_input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("click")):
		if(bonuses[0] == null):
			return
		bonuses[0].turn_on_bonus()
		activatedBonuses[bonuses[0].bonusName] = bonuses[0]
		bonuses[0] = null
		slots[0].texture = null
		
func _on_bonus_two_image_gui_input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("click")):
		if(bonuses[1] == null):
			return
		bonuses[1].turn_on_bonus()
		activatedBonuses[bonuses[1].bonusName] = bonuses[1]
		bonuses[1] = null
		slots[1].texture = null
