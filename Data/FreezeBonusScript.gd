extends BonusElement

var image = load("res://Icons/Menu/freezeBonus.png")
var wall = null
@onready var freezeEffectParams = $FreezeEffectParams

var freezeDuration = 3
var slowFactor = 0.4

func _ready() -> void:
	bonusName = "freeze"
	set_icon(image)
	set_price(20)
	bonusTime = 20

func set_manager(_manager: Node):
	if(freezeEffectParams == null):
		freezeEffectParams = $FreezeEffectParams
	freezeEffectParams.set_params(freezeDuration, slowFactor)
	freezeEffectParams.set_manager(_manager)
	
func set_wall(_wall: Node2D):
	wall = _wall
	
func activate_bonus():
	wall.add_freeze(freezeEffectParams)

func deactivate_bonus():
	wall.remove_freeze()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
	
func get_title():
	return "Ледяные снаряды"

func get_description():
	return "Главное оружие стреляет замораживающими снарядами, замедляющие врагов. Стрельба ядовитыми снарядами длится 20 секунд."
