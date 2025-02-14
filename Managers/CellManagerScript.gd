extends Node
var pool = {}

var cell = load("res://Managers/CellScene.tscn")

func create_cell(_number: int, _position: Vector2):
	if(!pool.has(_number)):
		pool[_number] = Array()
	
	var data = pool[_number].pop_front()
	if(data == null):
		data = cell.instantiate()
		data.init(_number, _position)
	
	return data

func remove_cell(_cell: CellElement):
	var number = _cell.number
	if(!pool.has(number)):
		pool[number] = Array()
		
	_cell.deactivate()
	pool[number].push_back(_cell)
		
