extends Control

var coinBonusScene = load("res://Data/CoinBonusScene.tscn")
var calibrBonusScene = load("res://Data/CalibrBonusScene.tscn")
var fieldBonusScene = load("res://Data/FieldBonusScene.tscn")
var fieldCellRemoveBonusScene = load("res://Data/FieldCellRemoveBonusScene.tscn")
var poisonEffectBonusScene = load("res://Data/PoisonBonusScene.tscn")
var freezeEffectBonusScene = load("res://Data/FreezeBonusScene.tscn")
var calibrAttackBonusScene = load("res://Data/CalibrAttackBonusScene.tscn")
var globalFreezeBonusScene = load("res://Data/GlobalFreezeBonusScene.tscn")
var globalPoisonBonusScene = load("res://Data/GlobalPoisonBonusScene.tscn")
var globalCalibrBonusScene = load("res://Data/GlobalSpeedCalibrScene.tscn")
var globalAttackBonusScene = load("res://Data/GlobalAttackBonusScene.tscn")
var fieldAllCellRemoveBonusScene = load("res://Data/FieldRemoveAllCellsScene.tscn")
var fieldTwoFourCellRemoveBonusScene = load("res://Data/FieldTwoFourRemoveBonusScene.tscn")
var levelFourBonusScene = load("res://Data/LevelFourBonusScene.tscn")

var mainMenu = null
var bonusPanel = null
var shopItemScene = load("res://Data/ShopItemScene.tscn")
@onready var shopItemsContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer
@onready var title = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/Title
@onready var description = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/Description
@onready var textureIcon = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/BonusIconContainer/Panel/AspectRatioContainer/TextureIcon
@onready var bonusIconContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer2/MarginContainer/GridContainer/BonusIconContainer

var bonuses = []

func _ready() -> void:
	
	var calibrBonus = calibrBonusScene.instantiate()
	var poisonBonus = poisonEffectBonusScene.instantiate()
	var freezeBonus = freezeEffectBonusScene.instantiate()
	var calibrAttackBonus = calibrAttackBonusScene.instantiate()
	var coinBonus = coinBonusScene.instantiate()
	var fieldBonus = fieldBonusScene.instantiate()
	var fieldCellRemoveBonus = fieldCellRemoveBonusScene.instantiate()
	var fieldAllCellRemoveBonus = fieldAllCellRemoveBonusScene.instantiate()
	var fieldTwoFourCellRemoveBonus = fieldTwoFourCellRemoveBonusScene.instantiate()
	var levelFourBonus = levelFourBonusScene.instantiate()
	
	var globalFreezeBonus = globalFreezeBonusScene.instantiate()
	var globalPoisonBonus = globalPoisonBonusScene.instantiate()
	var globalCalibrBonus = globalCalibrBonusScene.instantiate()
	var globalAttackBonus = globalAttackBonusScene.instantiate()
	
	bonuses.append(calibrBonus)
	bonuses.append(poisonBonus)
	bonuses.append(freezeBonus)
	bonuses.append(calibrAttackBonus)
	bonuses.append(globalFreezeBonus)
	bonuses.append(globalPoisonBonus)
	bonuses.append(globalCalibrBonus)
	bonuses.append(globalAttackBonus)
	bonuses.append(coinBonus)
	bonuses.append(fieldCellRemoveBonus)
	bonuses.append(fieldBonus)
	bonuses.append(fieldAllCellRemoveBonus)
	bonuses.append(fieldTwoFourCellRemoveBonus)
	bonuses.append(levelFourBonus)
	
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

func show_first_bonus() -> void:
	show_information(bonuses[0])
