extends Node2D
class_name CellElement

var numberLabel = null
var rect = null
# СОСТОЯНИЯ ДВИЖЕНИЯ: ДВИЖЕНИЕ, СЛИЯНИЕ, КОНЕЦ, УДАЛЕНИЕ, ОЖИДАНИЕ
enum MOVE_STATE {MOVE, MERGE, REMOVE, IDLE}

var moveVector = Vector2.ZERO
var index = Vector2i.ZERO
var newPos = Vector2(-1, -1)

@export var curState = MOVE_STATE.IDLE
@export var number = 2
@export var isMerged = false
@export var isNeedRemove = false

func init(_number: int, _position: Vector2, _index: Vector2i) -> void:
	if(numberLabel == null):
		numberLabel = $Rect/Number
	if(rect == null):
		rect = $Rect
		
	set_number(_number)
	
	position = _position
	index = _index
	activate()

func set_index(_index: Vector2i):
	index = _index

func set_new_pos(_newPos: Vector2):
	newPos = _newPos

func set_number(_number:int) -> void:
	var styleBox: StyleBoxFlat = rect.get_theme_stylebox("panel").duplicate()

	number = _number
	if(_number == 0):
		numberLabel.text = ""
		styleBox.set("bg_color", Color(0.8, 0.76, 0.88, 1))
		rect.add_theme_stylebox_override("panel", styleBox)
	else:
		numberLabel.text = get_str_lbl(number)
		set_background()
		
func set_background() -> void:		
	var r = int(log(number)/log(2)) % 15
	
	var background = Color8(255, 255, 255, 255)
	if(r == 1):
		background = Color8(237, 230, 218, 255)
	elif(r == 2):
		background = Color8(236, 227, 200, 255)
	elif(r == 3):
		background = Color8(241, 177, 120, 255)
	elif(r == 4):
		background = Color8(246, 149, 102, 255)
	elif(r == 5):
		background = Color8(248, 126, 96, 255)
	elif(r == 6):
		background = Color8(246, 95, 60, 255)
	elif(r == 7):
		background = Color8(238, 208, 113, 255)
	elif(r == 8):
		background = Color8(238, 206, 98, 255)
	elif(r == 9):
		background = Color8(238, 200, 85, 255)
	elif(r == 10):
		background = Color8(238, 198, 63, 255)
	elif(r == 11):
		background = Color8(236, 194, 47, 255)
	elif(r == 12):
		background = Color8(236, 120, 60, 255)
	elif(r == 13):
		background = Color8(236, 77, 85, 255)
	elif(r == 14):
		background = Color8(236, 65, 40, 255)
		
	var styleBox: StyleBoxFlat = rect.get_theme_stylebox("panel").duplicate()
	styleBox.set("bg_color", background)
	rect.add_theme_stylebox_override("panel", styleBox)
	
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
	position = Vector2(-100, -100)
	curState = MOVE_STATE.IDLE
	isMerged = false

func activate():
	visible = true
	curState = MOVE_STATE.IDLE
	moveVector = Vector2.ZERO
	isNeedRemove = false
	isMerged = false
	if(number > 0):
		$AnimationPlayer.play("Show")
	
func set_size(size: Vector2i):
	rect.set_size(size)

func set_move_state(_moveVector: Vector2):
	curState = MOVE_STATE.MOVE
	moveVector = _moveVector

func set_merge_state():
	isMerged = true
	curState = MOVE_STATE.MERGE

func set_remove_state():
	isMerged = true
	curState = MOVE_STATE.REMOVE
	
func set_idle_state():
	curState = MOVE_STATE.IDLE
	moveVector = Vector2.ZERO

func is_idle_state() -> bool:
	return curState == MOVE_STATE.IDLE
	
func is_remove_state() -> bool:
	return curState == MOVE_STATE.REMOVE

func is_need_remove() -> bool:
	return isNeedRemove

func endCheck(_delta: float) -> bool:
	var isEnd = false
	var pos = position + moveVector*_delta
	if moveVector.y == 0:
		if moveVector.x > 0:
			if(pos.x > newPos.x):
				isEnd = true
		else:
			if(pos.x < newPos.x):
				isEnd = true
	elif moveVector.x == 0:
		if moveVector.y > 0:
			if(pos.y > newPos.y):
				isEnd = true
		else:
			if(pos.y < newPos.y):
				isEnd = true
	return isEnd
	
func move(_delta: float):
	if(curState == MOVE_STATE.IDLE):
		return
	
	if(endCheck(_delta)):
		if(curState == MOVE_STATE.MOVE):
			curState = MOVE_STATE.IDLE
		elif(curState == MOVE_STATE.MERGE):
			curState = MOVE_STATE.IDLE
			set_number(number*2)
			isMerged = false
			$AnimationPlayer.play("Show")
		elif(curState == MOVE_STATE.REMOVE):
			curState = MOVE_STATE.IDLE
			isMerged = false
			isNeedRemove = true
		position = newPos
	else:
		position = position + moveVector*_delta
