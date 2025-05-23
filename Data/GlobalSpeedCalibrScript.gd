extends BonusElement

@export var speedMultiplier = 4
var image = load("res://Icons/Menu/globalCalibrBonus.png")
var wall = null

func _ready() -> void:
	bonusName = "globalCalibrAtttackSpeed"
	set_icon(image)
	set_price(10)
	bonusTime = 20

func set_wall(_wall: Node2D):
	wall = _wall
	
func activate_bonus():
	if(wall == null):
		return
	wall.change_global_shoot_speed(speedMultiplier)

func deactivate_bonus():
	wall.set_normal_shoot_period()

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)

func get_title():
	return tr("GLOBAL_SPEED_CALIBR_BONUS_TITLE")

func get_description():
	return tr("GLOBAL_SPEED_CALIBR_BONUS_DESCRIPTION")
