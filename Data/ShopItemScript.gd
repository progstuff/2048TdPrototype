extends VBoxContainer
@onready var bonusIcon = $Panel/MarginContainer/BonusIcon
var bonus = null
var shop = null

func _ready() -> void:
	pass
	
func set_shop(_shop:Control):
	shop = _shop

func set_bonus(_bonus: BonusElement):
	bonus = _bonus
	set_image(bonus.get_icon())
		
func set_image(_image: Texture2D):
	if(bonusIcon == null):
		bonusIcon = $Panel/MarginContainer/BonusIcon
	bonusIcon.texture = _image

func _on_panel_gui_input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("click")):
		shop.show_information(bonus)

func _on_bonus_icon_gui_input(_event: InputEvent) -> void:
	_on_panel_gui_input(_event)
