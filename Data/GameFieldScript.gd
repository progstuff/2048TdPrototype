extends Node2D
signal max_value_changed()
signal need_restart()

@export var fieldRowsCnt = 4
@export var fieldColumnsCnt = 4

@export var cellHeightPx = 100
@export var cellWidthPx = 100
@export var borderWidthPx = 4
@export var shiftSpeed = 3200
var startLeft = 6 * 13

var fieldRect = null
var cellManager = null
var cellsNode = null
var gridCellsNode = null

var isShift = false
var cellCoords = {} # Словарь индекс -> координата
var cells = {} # Словарь индекс -> ячейка
var prevCells = {} # Словарь индекс -> ячейка
var shiftedCells = {}

var moveVector = Vector2.ZERO

var fieldUpBorder = 0
var fieldLeftBorder = 0
var fieldRightBorder = 0
var fieldDownBorder = 0

var isProcess = false
var maxNumbers = Array()

var swiping = false
var startPos:Vector2
var curPos:Vector2
var length = 50

var startNumber = 1

func _input(event):
	if isProcess:
		return
	if event.is_action_pressed("up"):
		move_up()
	elif event.is_action_pressed("down"):
		move_down()
	elif event.is_action_pressed("left"):
		move_left()
	elif event.is_action_pressed("right"):
		move_right()
	elif Input.is_action_just_pressed("click"):
		if !swiping:
			if is_pnt_in_area(get_global_mouse_position()):
					swiping = true
					startPos = get_global_mouse_position()
					
	elif Input.is_action_pressed("click"):
		if swiping:
			curPos = get_global_mouse_position()
			if startPos.distance_to(curPos) >= length:
				swiping = false
				var dx = curPos.x - startPos.x
				var dy = curPos.y - startPos.y
				if abs(dy) > abs(dx):
					if(dy > 0):
						move_down()
					else:
						move_up()
				else:
					if(dx > 0):
						move_right()
					else:
						move_left()
	else:
		swiping = false

func is_pnt_in_area(pnt: Vector2) -> bool:
	var globalPos = global_position
	var mousePos = pnt
	var leftX = globalPos.x + fieldRect.position.x
	var rightX = leftX + get_width() - 10
	var upY = globalPos.y + fieldRect.position.y
	var downY = upY + get_height() - 10
	if(mousePos.x > leftX and mousePos.x < rightX):
		if(mousePos.y > upY and mousePos.y < downY):
			return true
	return false
	
func get_width() -> int:
	return fieldRect.size.x

func get_height() -> int:
	return fieldRect.size.y
	
func init(_rowsCnt: int, _columnsCnt: int, _cellSize: int):
	startNumber = 1
	init_values()
	
	cellHeightPx = _cellSize
	cellWidthPx = _cellSize
	fieldRowsCnt = _rowsCnt
	fieldColumnsCnt = _columnsCnt
	
	var viewportRect = get_viewport_rect()
	var height = cellWidthPx * fieldRowsCnt
	var y = viewportRect.size.y - 80 - height
	position.x = startLeft + 8
	position.y = y
	
	var rectWidth = fieldColumnsCnt*cellHeightPx + borderWidthPx*2
	var rectHeight = fieldRowsCnt*cellWidthPx + borderWidthPx*2
	fieldRect.set_size(Vector2(rectWidth, rectHeight))
	fieldRect.position.x = -borderWidthPx*2
	fieldRect.position.y = -borderWidthPx*2
	clear_field()
	add_cells()
	
	fieldRightBorder = cellWidthPx * (fieldRowsCnt - 1)
	fieldDownBorder = cellHeightPx * (fieldColumnsCnt - 1)
	
	update_max()

func get_cell_size() -> Vector2i:
	var cellWidth = cellHeightPx - borderWidthPx*2
	var cellHeight = cellHeightPx - borderWidthPx*2
	return Vector2i(cellWidth, cellHeight)

func clear_field():
	isShift = false
	for cell in cellsNode.get_children():
		cellsNode.remove_child(cell)
	cellCoords.clear()
	
	for cell in gridCellsNode.get_children():
		gridCellsNode.remove_child(cell)
		cellManager.remove_cell(cell)
	
	for cellIndex in cells:
		cellManager.remove_cell(cells[cellIndex])
	cells.clear()

func init_values():
	if(cellManager == null):
		cellManager = $CellManager
		
	if(cellsNode == null):
		cellsNode = $CellsNode
	
	if(fieldRect == null):
		fieldRect = $FieldRect
		
	if(gridCellsNode == null):
		gridCellsNode = $GridCells

func add_cells():
	for i in range(0, fieldRowsCnt):
		for j in range(0, fieldColumnsCnt):
			var x = j*cellWidthPx
			var y = i*cellHeightPx
			var pos = Vector2i(x, y)
			var index = Vector2i(i, j)
			cellCoords[index] = pos
			var cell = cellManager.create_cell(0, pos, index)
			cell.set_size(get_cell_size())
			gridCellsNode.add_child(cell)
	
	var usedInd = {}
	var needGenerate = true
	while(needGenerate):
		var rowInd = randi_range(0, fieldRowsCnt-1)
		var columnInd = randi_range(0, fieldColumnsCnt-1)
		var ind = Vector2i(rowInd, columnInd)
		if usedInd.has(ind):
			continue
		usedInd[ind] = true
		var number = 2
		var pos = cellCoords.get(ind)
		var cell = cellManager.create_cell(number, pos, ind)
		cell.set_size(get_cell_size())
		cellsNode.add_child(cell)
		cells[ind] = cell
		if(cells.size() == 2):
			break

# движение
func start_move_cells(_moveVector:Vector2):
	
	prevCells.clear()
	shiftedCells.clear()
	for i in range(0, fieldRowsCnt):
		for j in range(0, fieldColumnsCnt):
			if(cells.has(Vector2i(i, j))):
				var cell = cells[Vector2i(i, j)]
				cell.set_move_state(_moveVector)
				prevCells[Vector2i(i, j)] = cell.number

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
							var newCellColumn = j - shiftColumn
							var newCellInd =  Vector2i(i, newCellColumn)
							#
							cell.set_new_pos(cellCoords[newCellInd])
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
							var newCellColumn = j + shiftColumn
							var newCellInd =  Vector2i(i, newCellColumn)
							#
							cell.set_new_pos(cellCoords[newCellInd])
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
							var newCellRow = i - shiftRow
							var newCellInd =  Vector2i(newCellRow, j)
							#
							cell.set_new_pos(cellCoords[newCellInd])
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
							var newCellRow = i + shiftRow
							var newCellInd =  Vector2i(newCellRow, j)
							#
							cell.set_new_pos(cellCoords[newCellInd])
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
		
		#Поиск отличий
		var isNeedNewCell = false
		for cellIndex in prevCells:
			if(!cells.has(cellIndex)):
				isNeedNewCell = true
				break
			var number = prevCells[cellIndex]
			var cell = cells[cellIndex]
			if(number != cell.number):
				isNeedNewCell = true
				
		if isNeedNewCell:
			addNewElement()
		
		isProcess = false
		update_max()

func _biggest(a:int, b:int) -> bool:
	return a > b
	
func update_max():
	var numbers = Array()
	for cellIndex in cells:
		var cell = cells[cellIndex]
		if(cell == null):
			continue
		numbers.append(cell.number)
	numbers.sort_custom(_biggest)
	while(numbers.size() < fieldRowsCnt):
		numbers.append(2)
	maxNumbers = numbers
	max_value_changed.emit()
	
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
	var number = startNumber # сюда выбор числа
	number = pow(2, number)
	var pos = cellCoords.get(cellIndex)
	var cell = cellManager.create_cell(number, pos, cellIndex)
	cell.set_size(get_cell_size())
	cellsNode.add_child(cell)
	cells[cellIndex] = cell
				
func _on_wall_wall_damaged() -> void:
	if(!isProcess):
		for cellIndex in cells:
			var cell = cells[cellIndex]
			if(cell == null):
				continue
			if(cell.number == maxNumbers[0]):
				if(cell.number == 2):
					if(cells.size() > 1):
						cells.erase(cellIndex)
						cellManager.remove_cell(cell)
						cellsNode.remove_child(cell)
				else:
					cell.set_number(cell.number/2)
				break
		update_max()
	if(cells.is_empty()):
		need_restart.emit()

func restart() -> void:
	init(fieldRowsCnt, fieldColumnsCnt, cellWidthPx)
	
func double_two() -> void:
	for cellIndex in cells:
		var cell = cells[cellIndex]
		if(cell.number == 2):
			cell.double_cell()

func remove_min_cell() -> void:
	if(cells.size() == 1):
		return
	
	var minCellInd = null
	var minVal = null
	for cellIndex in cells:
		var cell = cells[cellIndex]
		if(minCellInd == null):
			minCellInd = cellIndex
			minVal = cell.number
		else:
			if(minVal > cell.number):
				minCellInd = cellIndex
				minVal = cell.number
	if(minVal > 2):
		return
		
	var removedCell = cells[minCellInd]
	cells.erase(minCellInd)
	cellsNode.remove_child(removedCell)
	cellManager.remove_cell(removedCell)
				
func remove_all_cells():
	if(cells.size() <= 4):
		return
	
	var temp = []
	for cellIndex in cells:
		var cell = cells[cellIndex]
		temp.append([cellIndex, cell.number])
			
	temp.sort_custom(func(a, b): return a[1] > b[1])
	
	for i in range(4, temp.size()):
		var ind = temp[i][0]
		var removedCell = cells[ind]
		cells.erase(ind)
		cellsNode.remove_child(removedCell)
		cellManager.remove_cell(removedCell)	
	
func remove_two_four_cells():
	var ind = []
	for cellIndex in cells:
		var cell = cells[cellIndex]
		if(cell.number == 2 or cell.number == 4):
			ind.append(cellIndex)
	for cellInd in ind:
		var removedCell = cells[cellInd]
		cells.erase(cellInd)
		cellsNode.remove_child(removedCell)
		cellManager.remove_cell(removedCell)	

func level_four():
	startNumber = 2
	double_two()
