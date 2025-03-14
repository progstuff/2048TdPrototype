extends Control

var mainScene = null

func init(_mainScene: Node2D):
	mainScene = _mainScene

func show_menu():
	get_tree().paused = true
	visible = true
	
func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	mainScene.restart_game()

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	visible = false
	mainScene.show_main_menu()
