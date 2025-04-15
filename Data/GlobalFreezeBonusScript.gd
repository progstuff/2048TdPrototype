extends BonusElement

var image = load("res://Icons/Menu/globalFreezeBonus.png")
var wall = null
@onready var freezeEffectParams = $FreezeEffectParams
var freezeDuration = 3
var slowFactor = 0.4

func _ready() -> void:
	bonusName = "globalFreeze"
	set_icon(image)
	set_price(25)
	bonusTime = 20

func set_wall(_wall: Node2D):
	wall = _wall

func set_manager(_manager: Node):
	if(freezeEffectParams == null):
		freezeEffectParams = $FreezeEffectParams
	freezeEffectParams.set_params(freezeDuration, slowFactor)
	freezeEffectParams.set_manager(_manager)
	
func activate_bonus():
	if(wall == null):
		return
	wall.add_global_freeze(freezeEffectParams)

func deactivate_bonus():
	wall.remove_freeze()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)

func get_title():
	return tr("GLOBAL_FREEZE_BONUS_TITLE")

func get_description():
	return tr("GLOBAL_FREEZE_BONUS_DESCRIPTION")
