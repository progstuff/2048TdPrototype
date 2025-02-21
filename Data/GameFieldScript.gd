extends Node2D

@export var fieldRowsCnt = 4
@export var fieldColumnsCnt = 4

@export var cellHeightPx = 50
@export var cellWidthPx = 50
@export var borderWidthPx = 2
@export var shiftSpeed = 1000

var cellManager = null
var cellsNode = null

var isShift = false
var cellCoords = {} # Словарь индекс -> координата
var cells = {} # Словарь индекс -> ячейка
var shiftedCells = {}

var moveVector = Vector2.ZERO

var fieldUpBorder = 0
var fieldLeftBorder = 0
var fieldRightBorder = 0
var fieldDownBorder = 0

var isProcess = false

func _input(event):
	if event.is_action_pressed("up"):
		move_up()
	elif event.is_action_pressed("down"):
		move_down()
	elif event.is_action_pressed("left"):
		move_left()
	elif event.is_action_pressed("right"):
		move_right()
	elif event.is_action_pressed("restart"):
		init()

func _ready():
	init()

func get_width() -> int:
	return (cellWidthPx + borderWidthPx) * fieldColumnsCnt
	
func init():
	
	init_values()
	clear_field()
	add_cells()
	
	fieldRightBorder = cellWidthPx * (fieldRowsCnt - 1)
	fieldDownBorder = cellHeightPx * (fieldColumnsCnt - 1)

func get_cell_size() -> Vector2i:
	var cellWidth = cellHeightPx - borderWidthPx*2
	var cellHeight = cellHeightPx - borderWidthPx*2
	return Vector2i(cellWidth, cellHeight)

func clear_field():
	isShift = false
	for cell in cellsNode.get_children():
		cellsNode.remove_child(cell)
		
	cellCoords.clear()

	for cellIndex in cells:
		cellManager.remove_cell(cells[cellIndex])
	cells.clear()

func init_values():
	if(cellManager == null):
		cellManager = $CellManager
		
	if(cellsNode == null):
		cellsNode = $CellsNode

func add_cells():
	for i in range(0, fieldRowsCnt):
		for j in range(0, fieldColumnsCnt):
			var x = j*cellWidthPx
			var y = i*cellHeightPx
			cellCoords[Vector2i(i, j)] = Vector2i(x, y)
	
	for key in cellCoords.keys():
			
		var rowInd = key.x
		var columnInd = key.y
		var index = Vector2i(rowInd, columnInd)
		
		var isNeed = randi_range(0, 100) >= 60
		
		if(!isNeed):
			continue
		var number = randi_range(1, 2)
		number = pow(2, number)
		
		var pos = cellCoords.get(index)
		var cell = cellManager.create_cell(number, pos, index)
		cell.set_size(get_cell_size())
		cellsNode.add_child(cell)
		cells[index] = cell

# движение
func start_move_cells(_moveVector:Vector2):
	
	shiftedCells.clear()
	for i in range(0, fieldRowsCnt):
		for j in range(0, fieldColumnsCnt):
			if(cells.has(Vector2i(i, j))):
				var cell = cells[Vector2i(i, j)]
				cell.set_move_state(_moveVector)

func move_left() -> void:
	if(isProcess):
		return
	isProcess = true
	moveVector = Vector2(-1, 0) * shiftSpeed
	start_move_cells(moveVector)
	
	for i in range(0, fieldRowsCnt):
		for j in range(0, fieldColumnsCnt):
			var index = Vector2i(i, j)
			
			if(!cells.has(index)):
				continue
			var shiftedCell = cells[index]
			var shiftColumn = 0

			for k in range(j-1, -1, -1):
				var shiftedJ = k
				var shiftedIndex = Vector2i(i, shiftedJ)
				# пустая ячейка
				if(!shiftedCells.has(shiftedIndex)):
					shiftColumn += 1
					continue
				else:
					var cell = shiftedCells[shiftedIndex]
					# номера не равны
					if(shiftedCell.number != cell.number):
						break
					else:
						#было выполнено объединение
						if(shiftedCell.isMerged or cell.isMerged):
							break
						else:
							shiftColumn += 1
							shiftedCell.set_merge_state()
							cell.set_remove_state()
							#
							var newColumn = j - shiftColumn
							var newInd =  Vector2i(i, newColumn)
							#
							cell.set_new_pos(cellCoords[newInd])
							break
			#		
			var newColumn = j - shiftColumn
			var newInd =  Vector2i(i, newColumn)
			#
			shiftedCells[newInd] = shiftedCell
			shiftedCell.set_new_pos(cellCoords[newInd])
	
	isShift = true
	
			
func move_right() -> void:
	if(isProcess):
		return
	isProcess = true
	moveVector = Vector2(1, 0) * shiftSpeed
	start_move_cells(moveVector)
	
	for i in range(0, fieldRowsCnt):
		for j in range(fieldColumnsCnt-1, -1, -1):
			var index = Vector2i(i, j)
			
			if(!cells.has(index)):
				continue
			var shiftedCell = cells[index]
			var shiftColumn = 0

			for k in range(j+1, fieldColumnsCnt):
				var shiftedJ = k
				var shiftedIndex = Vector2i(i, shiftedJ)
				# пустая ячейка
				if(!shiftedCells.has(shiftedIndex)):
					shiftColumn += 1
					continue
				else:
					var cell = shiftedCells[shiftedIndex]
					# номера не равны
					if(shiftedCell.number != cell.number):
						break
					else:
						#было выполнено объединение
						if(shiftedCell.isMerged or cell.isMerged):
							break
						else:
							shiftColumn += 1
							shiftedCell.set_merge_state()
							cell.set_remove_state()
							#
							var newColumn = j + shiftColumn
							var newInd =  Vector2i(i, newColumn)
							#
							cell.set_new_pos(cellCoords[newInd])
							break
			#		
			var newColumn = j + shiftColumn
			var newInd =  Vector2i(i, newColumn)
			#
			shiftedCells[newInd] = shiftedCell
			shiftedCell.set_new_pos(cellCoords[newInd])
	
	isShift = true
	
func move_up() -> void:
	if(isProcess):
		return
	isProcess = true
	moveVector = Vector2(0, -1) * shiftSpeed
	start_move_cells(moveVector)
	
	for j in range(0, fieldColumnsCnt):
		for i in range(0, fieldRowsCnt):
			var index = Vector2i(i, j)
			
			if(!cells.has(index)):
				continue
			var shiftedCell = cells[index]
			var shiftRow = 0

			for k in range(i-1, -1, -1):
				var shiftedI = k
				var shiftedIndex = Vector2i(shiftedI, j)
				# пустая ячейка
				if(!shiftedCells.has(shiftedIndex)):
					shiftRow += 1
					continue
				else:
					var cell = shiftedCells[shiftedIndex]
					# номера не равны
					if(shiftedCell.number != cell.number):
						break
					else:
						#было выполнено объединение
						if(shiftedCell.isMerged or cell.isMerged):
							break
						else:
							shiftRow += 1
							shiftedCell.set_merge_state()
							cell.set_remove_state()
							#
							var newRow = i - shiftRow
							var newInd =  Vector2i(newRow, j)
							#
							cell.set_new_pos(cellCoords[newInd])
							break
			#		
			var newRow = i - shiftRow
			var newInd =  Vector2i(newRow, j)
			#
			shiftedCells[newInd] = shiftedCell
			shiftedCell.set_new_pos(cellCoords[newInd])
	
	isShift = true
	
func move_down() -> void:
	if(isProcess):
		return
	isProcess = true
	moveVector = Vector2(0, 1) * shiftSpeed
	start_move_cells(moveVector)
	
	for j in range(0, fieldColumnsCnt):
		for i in range(fieldRowsCnt-1, -1, -1):
			var index = Vector2i(i, j)
			
			if(!cells.has(index)):
				continue
			var shiftedCell = cells[index]
			var shiftRow = 0

			for k in range(i+1, fieldRowsCnt):
				var shiftedI = k
				var shiftedIndex = Vector2i(shiftedI, j)
				# пустая ячейка
				if(!shiftedCells.has(shiftedIndex)):
					shiftRow += 1
					continue
				else:
					var cell = shiftedCells[shiftedIndex]
					# номера не равны
					if(shiftedCell.number != cell.number):
						break
					else:
						#было выполнено объединение
						if(shiftedCell.isMerged or cell.isMerged):
							break
						else:
							shiftRow += 1
							shiftedCell.set_merge_state()
							cell.set_remove_state()
							#
							var newRow = i + shiftRow
							var newInd =  Vector2i(newRow, j)
							#
							cell.set_new_pos(cellCoords[newInd])
							break
			#		
			var newRow = i + shiftRow
			var newInd =  Vector2i(newRow, j)
			#
			shiftedCells[newInd] = shiftedCell
			shiftedCell.set_new_pos(cellCoords[newInd])
	
	isShift = true
	
func _process(_delta: float) -> void:
	
	if(!isShift):
		return
		
	var isNeedStop = true
	for cellIndex in cells:
		var cell = cells[cellIndex]
		cell.move(_delta)
		if(!cell.is_idle_state()):
			isNeedStop = false
	
	if(isNeedStop):
		isShift = false
		
		for cellIndex in cells:
			var cell = cells[cellIndex]
			if(cell.is_need_remove()):
				cellsNode.remove_child(cell)
				cellManager.remove_cell(cell)
		cells.clear()
		
		for cellIndex in shiftedCells:
			var cell = shiftedCells[cellIndex]
			cells[cellIndex] = cell
			cell.set_index(cellIndex)
			
		shiftedCells.clear()
		addNewElement()
		
		isProcess = false
		
func addNewElement():
	var emptyCells = []
	
	for cellIndex in cellCoords:
		if(cells.has(cellIndex)):
			continue
		emptyCells.append(cellIndex)
	
	var n = emptyCells.size()
	if(n == 0):
		return
	
	var ind = randi_range(0, n-1)
	var cellIndex = emptyCells[ind]
	var number = 1 # сюда выбор числа
	number = pow(2, number)
	var pos = cellCoords.get(cellIndex)
	var cell = cellManager.create_cell(number, pos, cellIndex)
	cell.set_size(get_cell_size())
	cellsNode.add_child(cell)
	cells[cellIndex] = cell
				
		
		
