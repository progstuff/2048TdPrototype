extends PanelContainer
class_name BonusElement

@export var playerCoins = 100
@export var isChoosed = false
var isActive = false
var curCnt = 0
@export var bonusTime = 0
@export var bonusName = ""
@onready var priceLbl = $VBoxContainer2/MarginContainer/VBoxContainer/MarginContainer2/PricePanel/HBoxContainer/MarginContainer2/PriceLbl
@onready var disabledPanel = $DisabledPanel
@onready var chooseButton = $VBoxContainer2/HBoxContainer/MarginContainer/ChooseButton
@onready var pricePanel = $VBoxContainer2/MarginContainer/VBoxContainer/MarginContainer2/PricePanel
var icon = null
var bonusPanel = null

var price = 1

func _ready() -> void:
	pass

func process_bonus(_delta: float) -> void:
	if(isActive):
		curCnt += _delta
		if(curCnt >= bonusTime):
			deactivate_bonus()
			isActive = false
			curCnt = 0
			
func activate():
	visible = true
	set_enabled()
	clear_choose()
	
func deactivate():
	visible = false
	isChoosed = false
	isActive = false

func set_disabled():
	if(disabledPanel == null):
		return
	disabledPanel.visible = true

func set_enabled():
	if(disabledPanel == null):
		return
	disabledPanel.visible = false
	
func set_bonus_panel(_bonusPanel:PanelContainer):
	bonusPanel = _bonusPanel
	
func set_price(_price: int):
	price = _price
	priceLbl.text = str(price)
	
func turn_on_bonus():
	curCnt = 0
	isActive = true
	activate_bonus()
	
func activate_bonus():
	pass

func deactivate_bonus():
	pass

func restart():
	deactivate_bonus()

func set_short_description(_shortDescription: String):
	pass

func _on_choose_button_pressed() -> void:
	if(playerCoins >= price):
		if(bonusPanel != null):
			bonusPanel.choose_bonus(self)

func choose():
	isChoosed = true
	if(chooseButton == null):
		return
	chooseButton.visible = false
	if(pricePanel == null):
		return
	pricePanel.visible = false

func clear_choose():
	isChoosed = false
	if(chooseButton == null):
		return
	chooseButton.visible = true
	if(pricePanel == null):
		return
	pricePanel.visible = true
	
func _on_panel_gui_input(_event: InputEvent) -> void:
	if(_event.is_action_pressed("click")):
		if(bonusPanel != null):
			bonusPanel.show_description(get_title(), get_description())

func set_icon(_icon: Texture2D):
	icon = _icon
		
func get_icon() -> Texture2D:
	return icon

func get_title():
	return ""

func get_description():
	return ""
