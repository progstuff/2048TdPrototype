extends Control

var mainGameScene = null
@onready var menuItems = $MenuItems
@onready var shop = $Shop

func _ready() -> void:
	shop.set_main_menu(self)

func show_menu():
	get_tree().paused = true
	visible = true
	mainGameScene.visible = false
	shop.visible = false

func show_shop():
	menuItems.visible = false
	shop.visible = true

func show_main_menu_items():
	menuItems.visible = true
	shop.visible = false
	
func set_main_game_scene(_mainGameScene: Node2D):
	mainGameScene = _mainGameScene
	
func _on_start_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	mainGameScene.visible = true
	mainGameScene.restart_game()

func _on_shop_button_pressed() -> void:
	show_shop()

func _on_exit_button_pressed() -> void:
	get_tree().quit()
