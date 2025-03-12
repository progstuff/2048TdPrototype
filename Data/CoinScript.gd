extends Node2D
class_name CoinElement

@onready var panel = $Panel
var coinSpawner = null

func _ready() -> void:
	pass
	
func deactivate():
	visible = false
	position = Vector2(-1000, -1000)
	
func activate():
	visible = true
	
func init(_coinSpawner, _pos: Vector2):
	if(panel == null):
		panel = $Panel
		
	coinSpawner = _coinSpawner
	var x = panel.get_rect().size.x/2
	var y = panel.get_rect().size.y/2
	position = _pos - Vector2(x, y)
	activate()
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		var isInArea = is_pnt_in_area(get_global_mouse_position())
		if(isInArea):
			if(coinSpawner != null):
				coinSpawner.remove_coin_after_click(self)
				
func is_pnt_in_area(pnt: Vector2) -> bool:
	var globalPos = global_position
	var mousePos = pnt
	var leftX = globalPos.x
	var rightX = leftX + panel.get_rect().size.x
	var upY = globalPos.y
	var downY = upY + panel.get_rect().size.y
	if(mousePos.x > leftX and mousePos.x < rightX):
		if(mousePos.y > upY and mousePos.y < downY):
			return true
	return false
