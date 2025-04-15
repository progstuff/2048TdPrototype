extends BonusElement

@export var speedMultiplier = 4
var image = load("res://Icons/Menu/bonusCalibr.png")
var wall = null

func _ready() -> void:
	bonusName = "calibrAtttackSpeed"
	set_icon(image)
	set_price(25)
	bonusTime = 20

func set_wall(_wall: Node2D):
	wall = _wall
	
func activate_bonus():
	if(wall == null):
		return
	wall.change_main_calibr_shoot_speed(speedMultiplier)

func deactivate_bonus():
	wall.set_normal_shoot_period()


func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)

func get_title():
	return tr("CALIBR_SPEED_BONUS_TITLE")

func get_description():
	return tr("CALIBR_SPEED_BONUS_DESCRIPTION")
