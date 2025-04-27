extends Control

var mainGameScene = null
@onready var menuItems = $MenuItems
@onready var shop = $Shop
@onready var optionsMenu = $OptionsMenu

func _ready() -> void:
	shop.set_main_menu(self)

func show_menu():
	visible = true
	get_tree().paused = true
	menuItems.visible = true
	mainGameScene.visible = false
	shop.visible = false
	optionsMenu.visible = false
	
func show_shop():
	menuItems.visible = false
	shop.visible = true
	shop.show_first_bonus()

func show_main_menu_items():
	menuItems.visible = true
	shop.visible = false

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
	mainGameScene.restart_game()

func _on_shop_button_pressed() -> void:
	show_shop()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_language_button_pressed() -> void:
	show_language_menu()
