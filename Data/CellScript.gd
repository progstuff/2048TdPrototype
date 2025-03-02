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
	
	number = _number
	if(_number == 0):
		numberLabel.text = ""
		rect.color = Color(0.8, 0.76, 0.88, 1)
	else:
		numberLabel.text = get_str_lbl(number)
		set_background()
		
func set_background() -> void:		
	var r = number % 10
	
	var background = Color(1, 1, 1, 1)
	if(r == 0):
		background = Color(0.96, 0.36, 0.24, 1)
	elif(r == 2):
		background = Color(0.94, 0.9, 0.85, 1)
	elif(r == 4):
		background = Color(0.93, 0.88, 0.78, 1)
	elif(r == 6):
		background = Color(0.95, 0.7, 0.49, 1)
	elif(r == 8):
		background = Color(0.96, 0.48, 0.38, 1)
	
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
	position = Vector2(-100, -100)
	curState = MOVE_STATE.IDLE
	isMerged = false

func activate():
	visible = true
	curState = MOVE_STATE.IDLE
	moveVector = Vector2.ZERO
	isNeedRemove = false
	isMerged = false
	
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
		elif(curState == MOVE_STATE.REMOVE):
			curState = MOVE_STATE.IDLE
			isMerged = false
			isNeedRemove = true
		position = newPos
	else:
		position = position + moveVector*_delta
