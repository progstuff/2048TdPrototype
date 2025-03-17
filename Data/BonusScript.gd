extends PanelContainer
class_name BonusElement

@export var playerCoins = 10
@export var isChoosed = false
@export var bonusTime = 2

@onready var bonusTimer = $BonusTimer
@onready var priceLbl = $VBoxContainer2/MarginContainer/VBoxContainer/Panel2/HBoxContainer/MarginContainer3/HBoxContainer/MarginContainer/Price
@onready var descriptionLbl = $VBoxContainer2/MarginContainer/VBoxContainer/MarginContainer/Panel/DescriptionLbl

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

func activate_bonus():
	pass

func deactivate_bonus():
	pass

func _on_bonus_timer_timeout() -> void:
	deactivate_bonus()

func restart():
	deactivate_bonus()

func set_short_description(_shortDescription: String):
	descriptionLbl.text = _shortDescription
	
func _on_description_button_pressed() -> void:
	if(bonusPanel != null):
		bonusPanel.show_description()

func _on_choose_button_pressed() -> void:
	if(playerCoins >= price):
		if(bonusPanel != null):
			bonusPanel.choose_bonus(self)

func choose():
	isChoosed = true
