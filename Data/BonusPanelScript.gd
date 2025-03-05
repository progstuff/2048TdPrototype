extends PanelContainer

@onready var container = $VBoxContainer/HBoxContainer

func _ready() -> void:
	pass
	
func choose_bonus():
	for bonus in container.get_children():
		if(bonus.isChoosed):
			visible = false
			break
