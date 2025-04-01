extends Control

var coinBonusScene = load("res://Data/CoinBonusScene.tscn")
var calibrBonusScene = load("res://Data/CalibrBonusScene.tscn")
var fieldBonusScene = load("res://Data/FieldBonusScene.tscn")
var fieldCellRemoveBonus = load("res://Data/FieldCellRemoveBonusScene.tscn")
var poisonEffectBonus = load("res://Data/PoisonBonusScene.tscn")
var freezeEffectBonus = load("res://Data/FreezeBonusScene.tscn")

var mainMenu = null
var bonusPanel = null
var shopItemScene = load("res://Data/ShopItemScene.tscn")
@onready var shopItemsContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer
@onready var title = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/Title
@onready var description = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/Description
@onready var textureIcon = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/BonusIconContainer/Panel/AspectRatioContainer/TextureIcon
@onready var bonusIconContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/BonusIconContainer

func _ready() -> void:
	var bonuses = []
	var coinBonus = coinBonusScene.instantiate()
	var calibrBonus = calibrBonusScene.instantiate()
	var fieldBonus = fieldBonusScene.instantiate()
	var fieldCellRemoveBonus = fieldCellRemoveBonus.instantiate()
	var poisonBonus = poisonEffectBonus.instantiate()
	var freezeBonus = freezeEffectBonus.instantiate()
	bonuses.append(coinBonus)
	bonuses.append(calibrBonus)
	bonuses.append(fieldBonus)
	bonuses.append(fieldCellRemoveBonus)
	bonuses.append(poisonBonus)
	bonuses.append(freezeBonus)
	
	for bonus in bonuses:
		bonus._ready()
		var shopItem = shopItemScene.instantiate()
		shopItem.set_shop(self)
		shopItem.set_bonus(bonus)
		shopItemsContainer.add_child(shopItem)

func show_information(_bonus:BonusElement):
	bonusIconContainer.visible = true
	title.text = _bonus.get_title()
	description.text = _bonus.get_description()
	textureIcon.texture = _bonus.get_icon()
	
	
func set_main_menu(_mainMenu:Control):
	mainMenu = _mainMenu
	
func _on_button_pressed() -> void:
	mainMenu.show_main_menu_items()
