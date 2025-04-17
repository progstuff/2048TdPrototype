extends Control

var mainMenu = null
@onready var languageMenu = $LanguageMenu
@onready var difficultMenu = $DifficultMenu
@onready var optionsMenu = $Options

func _ready() -> void:
	difficultMenu.set_main_menu(self)
	languageMenu.set_main_menu(self)
	
func init(_mainMenu:Control, _world:Node2D):
	mainMenu = _mainMenu
	difficultMenu.set_world(_world)
	
func _on_difficult_button_pressed() -> void:
	languageMenu.visible = false
	optionsMenu.visible = false
	difficultMenu.visible = true
	difficultMenu.update_difficult()

func _on_language_menu_pressed() -> void:
	optionsMenu.visible = false
	difficultMenu.visible = false
	languageMenu.visible = true

func _on_back_button_pressed() -> void:
	show_menu()
	mainMenu.show_menu()

func show_menu():
	optionsMenu.visible = true
	difficultMenu.visible = false
	languageMenu.visible = false
