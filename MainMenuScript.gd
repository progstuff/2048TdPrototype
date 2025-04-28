extends Control

var mainGameScene = null

@onready var optionsMenu = $MenuContainer/MarginContainer/OptionsMenu
@onready var menuItems = $MenuContainer/MarginContainer/MenuItems
@onready var menuContainer = $MenuContainer
@onready var shop = $Shop

@onready var mode1 = $MenuContainer/Panel/GridContainer/Mode1
@onready var mode2 = $MenuContainer/Panel/GridContainer/Mode2
@onready var mode3 = $MenuContainer/Panel/GridContainer/Mode3
@onready var mode4 = $MenuContainer/Panel/GridContainer/Mode4

var config = ConfigFile.new()

func _ready() -> void:
	shop.set_main_menu(self)
	var isOk = config.load("user://prefs.cfg")
	
	var gameMode = 1
	if isOk == OK:
		gameMode = config.get_value("gameMode", "value", 1)
	choose_mode(gameMode)

func show_menu():
	visible = true
	get_tree().paused = true
	menuItems.visible = true
	mainGameScene.visible = false
	shop.visible = false
	optionsMenu.visible = false
	menuContainer.visible = true
	
func show_shop():
	menuContainer.visible = false
	shop.visible = true
	shop.show_first_bonus()

func show_main_menu_items():
	menuItems.visible = true
	shop.visible = false
	menuContainer.visible = true

func show_language_menu():
	menuItems.visible = false
	optionsMenu.visible = true
	
func set_main_game_scene(_mainGameScene: Node2D):
	mainGameScene = _mainGameScene
	optionsMenu.init(self, mainGameScene)
	
func _on_start_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	mainGameScene.visible = true
	var gameMode = game_mode()
	mainGameScene.set_game_mode(gameMode)
	mainGameScene.restart_game()

func _on_shop_button_pressed() -> void:
	show_shop()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_language_button_pressed() -> void:
	show_language_menu()

func game_mode() -> int:
	var modulateColor = Color8(255, 255, 255, 255)
	
	if(mode1.modulate == modulateColor):
		return 1
	if(mode2.modulate == modulateColor):
		return 2
	if(mode3.modulate == modulateColor):
		return 3
		
	return 4
	
func choose_mode(_modeInd:int):
	if(_modeInd == 1):
		mode1.modulate = Color8(255, 255, 255, 255)
		mode2.modulate = Color8(255, 255, 255, 106)
		mode3.modulate = Color8(255, 255, 255, 106)
		mode4.modulate = Color8(255, 255, 255, 106)
	elif(_modeInd == 2):
		mode1.modulate = Color8(255, 255, 255, 106)
		mode2.modulate = Color8(255, 255, 255, 255)
		mode3.modulate = Color8(255, 255, 255, 106)
		mode4.modulate = Color8(255, 255, 255, 106)
	elif(_modeInd == 3):
		mode1.modulate = Color8(255, 255, 255, 106)
		mode2.modulate = Color8(255, 255, 255, 106)
		mode3.modulate = Color8(255, 255, 255, 255)
		mode4.modulate = Color8(255, 255, 255, 106)
	elif(_modeInd == 4):
		mode1.modulate = Color8(255, 255, 255, 106)
		mode2.modulate = Color8(255, 255, 255, 106)
		mode3.modulate = Color8(255, 255, 255, 106)
		mode4.modulate = Color8(255, 255, 255, 255)
		
func _on_mode_1_gui_input(_event: InputEvent) -> void:
	if(_event.is_action("click")):
		choose_mode(1)
		var isOk = config.load("user://prefs.cfg")
		if isOk == OK:
			config.set_value("gameMode", "value", 1)
			config.save("user://prefs.cfg")

func _on_mode_2_gui_input(_event: InputEvent) -> void:
	if(_event.is_action("click")):
		choose_mode(2)
		var isOk = config.load("user://prefs.cfg")
		if isOk == OK:
			config.set_value("gameMode", "value", 2)
			config.save("user://prefs.cfg")

func _on_mode_3_gui_input(_event: InputEvent) -> void:
	if(_event.is_action("click")):
		choose_mode(3)
		var isOk = config.load("user://prefs.cfg")
		if isOk == OK:
			config.set_value("gameMode", "value", 3)
			config.save("user://prefs.cfg")

func _on_mode_4_gui_input(_event: InputEvent) -> void:
	if(_event.is_action("click")):
		choose_mode(4)
		var isOk = config.load("user://prefs.cfg")
		if isOk == OK:
			config.set_value("gameMode", "value", 4)
			config.save("user://prefs.cfg")
