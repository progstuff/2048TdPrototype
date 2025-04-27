extends BonusElement

var image = load("res://Icons/Menu/poisonBonus.png")
var wall = null
@onready var poisonEffectParams = $PoisonEffectParams

var poisonPeriod = 0.5
var poisonDuration = 10
var poisonDamage = 5

func _ready() -> void:
	bonusName = "poison"
	set_icon(image)
	set_price(5)
	bonusTime = 20

func set_manager(_manager: Node):
	if(poisonEffectParams == null):
		poisonEffectParams = $PoisonEffectParams
	poisonEffectParams.set_params(poisonPeriod, poisonDuration, poisonDamage)
	poisonEffectParams.set_manager(_manager)
	
func set_wall(_wall: Node2D):
	wall = _wall
	
func activate_bonus():
	wall.add_poison(poisonEffectParams)

func deactivate_bonus():
	wall.remove_poison()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
	
func get_title():
	return tr("POISON_BONUS_TITLE")

func get_description():
	return tr("POISON_BONUS_DESCRIPTION")
