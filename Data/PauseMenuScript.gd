extends Control

func _on_close_panel_gui_input(event: InputEvent) -> void:
	if(event.is_action("click")):
		visible = false
		get_tree().paused = false

func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
