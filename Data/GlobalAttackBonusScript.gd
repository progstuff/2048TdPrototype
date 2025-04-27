extends BonusElement

@export var attackMultiplier = 4
var image = load("res://Icons/Menu/GlobalAttackBonus.png")
var wall = null

func _ready() -> void:
	bonusName = "globalCalibrAtttackDamage"
	set_icon(image)
	set_price(10)
	bonusTime = 20

func set_wall(_wall: Node2D):
	wall = _wall
	
func activate_bonus():
	if(wall == null):
		return
	wall.change_global_calibr_shoot_attack(attackMultiplier)

func deactivate_bonus():
	wall.set_normal_shoot_attack()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)

func get_title():
	return tr("GLOBAL_ATTACK_BONUS_TITLE")

func get_description():
	return tr("GLOBAL_ATTACK_BONUS_DESCRIPTION")
