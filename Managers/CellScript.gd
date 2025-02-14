extends Node2D
class_name CellElement

@export var number = 2

var numberLabel = null
var rect = null
@export var timer = null
var dist = 100
var curShift = 0
var step = 10

func init(_number: int, _position: Vector2) -> void:
	if(numberLabel == null):
		numberLabel = $Rect/Number
	if(rect == null):
		rect = $Rect
	if(timer == null):
		timer = $Timer
		
	set_number(_number)
	set_background()
	
	position = _position
	visible = true
	
func set_number(_number:int) -> void:
	number = _number
	numberLabel.text = get_str_lbl(number)

func set_background() -> void:		
	var r = number % 10
	
	var background = Color(1, 1, 1, 1)
	if(r == 0):
		background = Color(0.8, 0, 0, 1)
	elif(r == 2):
		background = Color(0, 0.8, 0, 1)
	elif(r == 4):
		background = Color(0, 0, 0.8, 1)
	elif(r == 6):
		background = Color(0.8, 0.8, 0, 1)
	elif(r == 8):
		background = Color(0, 0.8, 0.8, 1)
	
	rect.color = background
	
func get_str_lbl(_number: int) -> String:
	var n = _number
	if(n > 1000):
		var s = ""
		while(n > 1000):
			n = n/1000
			s += "K"
		s = str(n) + s
		return s
	else:
		return str(_number)
		
func deactivate():
	visible = false
	position = Vector2(-100, 100)

func _on_timer_timeout() -> void:
	if(curShift < dist):
		curShift += step
		position.x += step
	else:
		timer.stop()
