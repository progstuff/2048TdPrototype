extends Node2D
signal wall_damaged

@onready var towers = $Towers

var tower = load("res://Data/TowerScene.tscn")

var towersCnt = 5
@export var damage = 0

func set_bullet_speed(_speed: float):
	for twr in towers.get_children():
		twr.set_bullet_speed(_speed)
		
func set_bullet_power_mult(_mult: float):
	for twr in towers.get_children():
		twr.bulletPowerMult = _mult

func set_bullet_power_shift(_shift: float):
	for twr in towers.get_children():
		twr.bulletPowerShift = _shift

func set_bullet_period(_period: float):
	for twr in towers.get_children():
		twr.set_bullets_spawn_period(_period)

func get_bullet_period() -> float:
	return towers.get_child(0).get_bullet_spawn_period()
		
func get_bullet_speed() -> float:
	return towers.get_child(0).bulletSpeed

func get_bullet_power_mult() -> float:
	return towers.get_child(0).bulletPowerMult

func get_bullet_power_shift() -> float:
	return towers.get_child(0).bulletPowerShift

		
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("click"):
		for twr in towers.get_children():
			var isInArea = twr.is_pnt_in_area(get_global_mouse_position())
			if(isInArea):
				var twrInd = twr.get_tower_ind()
				change_calibr(twrInd)

func change_calibr(twrInd: int):
	var mainTwr = null
	var otherTwr = null
	for twr in towers.get_children():
		if(twr.get_tower_ind() == twrInd):
			otherTwr = twr
		elif(twr.get_tower_ind() == 0):
			mainTwr = twr
	if(otherTwr == null or mainTwr == null):
		return
	var mainTwrLvl = mainTwr.lvl
	var otherTwrLvl = otherTwr.lvl
	
	mainTwr.set_tower_ind(twrInd)
	mainTwr.change_lvl(otherTwrLvl)
	
	otherTwr.set_tower_ind(0)
	otherTwr.change_lvl(mainTwrLvl)
	
func change_position(newX: int):
	for twr in towers.get_children():
		twr.position.x = newX - twr.get_width()
	
func init(_fieldPos: Vector2, _fieldSize: Vector2, _towersCnt: int):
	position = _fieldPos
	damage = 0
	
	if towers == null:
		towers = $Towers
		
	for tower in towers.get_children():
		towers.remove_child(tower)
		tower.queue_free()
	
	towersCnt = _towersCnt
	var dy = (_fieldSize.y - 4*2) / _towersCnt
	for i in range(0, towersCnt):
		var twr = tower.instantiate()
		towers.add_child(twr)
		twr.init(1, Vector2(-4*2, dy*i + 50 - 32), i)

func restart():
	var ind = 0
	for twr in towers.get_children():
		twr.restart()
		twr.set_tower_ind(ind)
		ind += 1
	damage = 0
		
func get_twr_positions() -> Array:
	var result = Array()
	for tower in towers.get_children():
		var pos = position + tower.position
		pos.y = pos.y + tower.get_height()/2
		result.append(pos)
	return result

func change_lvl(_numbers: Array):

	if(towers == null):
		return
	for tower in towers.get_children():
		var number = _numbers[tower.get_tower_ind()]
		var towerLvl = 0
		if(number != 0):
			towerLvl = log(number)/log(2)
		tower.change_lvl(towerLvl)
		
func _on_wall_area_entered(area: Area2D) -> void:
	if(area.name == "enemy"):
		damage = damage + area.get_parent().maxHealth
		wall_damaged.emit()
