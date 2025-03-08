extends PanelContainer
class_name BonusElement

@export var playerCoins = 10
@export var isChoosed = false
@export var bonusTime = 2

@onready var bonusTimer = $BonusTimer
@onready var priceLbl = $MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Price
var bonusPanel = null

var price = 1

func _ready() -> void:
	pass

func activate():
	visible = true
	isChoosed = false
	
func deactivate():
	visible = false
	isChoosed = false
	
func set_bonus_panel(_bonusPanel:PanelContainer):
	bonusPanel = _bonusPanel
	
func set_price(_price: int):
	price = _price
	priceLbl.text = str(price)

func _on_panel_gui_input(event: InputEvent) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and not event.is_pressed()
	):
		if(playerCoins >= price):
			isChoosed = true
			if(bonusPanel != null):
				bonusPanel.choose_bonus()

func activate_bonus():
	pass

func deactivate_bonus():
	pass

func _on_bonus_timer_timeout() -> void:
	deactivate_bonus()
