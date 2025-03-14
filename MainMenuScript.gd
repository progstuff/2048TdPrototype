extends Control

var mainGameScene = null

func _ready() -> void:
	pass

func show_menu():
	get_tree().paused = true
	visible = true
	mainGameScene.visible = false
	
func set_main_game_scene(_mainGameScene: Node2D):
	mainGameScene = _mainGameScene
	
func _on_start_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	mainGameScene.visible = true
	mainGameScene.restart_game()

func _on_shop_button_pressed() -> void:
	pass # Replace with function body.

func _on_exit_button_pressed() -> void:
	get_tree().quit()
