extends PanelContainer
class_name BonusElement

@export var playerCoins = 10
@export var isChoosed = false
@onready var icon = $BonusIcon
@onready var priceLbl = $HBoxContainer/MarginContainer/Price

var price = 1

func _ready() -> void:
	pass

func set_price(_price: int):
	price = _price
	priceLbl.text = str(price)
		
func _on_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and not event.is_pressed()
	):
		if(playerCoins >= price):
			isChoosed = true
			var bonusPanel = get_parent().get_parent().get_parent()
			bonusPanel.choose_bonus()
