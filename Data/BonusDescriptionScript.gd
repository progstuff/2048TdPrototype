extends Control

@onready var title = $PanelContainer/VBoxContainer/Panel/TitleLbl
@onready var description = $PanelContainer/VBoxContainer/MarginContainer/DescriptionLbl

func _ready() -> void:
	pass

func _on_accept_button_pressed() -> void:
	visible = false

func show_description(_title: String, _description: String):
	title.text = _title
	description.text = _description
	visible = true
