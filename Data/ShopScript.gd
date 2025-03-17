extends Control

var mainMenu = null
var shopItemScene = load("res://Data/ShopItemScene.tscn")
@onready var shopItemsContainer = $MarginContainer/VBoxContainer/HBoxContainer/PanelContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer

func _ready() -> void:
	for i in range(1, 100):
		var shopItem = shopItemScene.instantiate()
		shopItemsContainer.add_child(shopItem)
	
func set_main_menu(_mainMenu:Control):
	mainMenu = _mainMenu
	
func _on_button_pressed() -> void:
	mainMenu.show_main_menu_items()
