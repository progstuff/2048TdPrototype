extends BonusElement

@export var speedMultiplier = 4
var image = load("res://Icons/Menu/globalCalibrBonus.png")
var wall = null

func _ready() -> void:
	bonusName = "globalCalibrAtttackSpeed"
	set_icon(image)
	set_price(25)
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
	return "Непрерывная стрельба"

func get_description():
	return "Увеличивает скорость стрельбы всех орудий в 4 раза на 20 секунд."
