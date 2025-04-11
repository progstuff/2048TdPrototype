extends BonusElement

@export var attackMultiplier = 4
var image = load("res://Icons/Menu/GlobalAttackBonus.png")
var wall = null

func _ready() -> void:
	bonusName = "globalCalibrAtttackDamage"
	set_icon(image)
	set_price(25)
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
	return "Увеличенный урон"

func get_description():
	return "На 20 секунд для всех орудий увеличивает урон от снарядов В 4 раза."
