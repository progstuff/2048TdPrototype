extends Node2D
class_name TowerElement

@onready var rect = $ColorRect
@onready var lvlLbl = $ColorRect/Label
@onready var bullets = $Bullets
@onready var spawnTimer = $SpawnTimer

@export var bulletSpeed = 150
@export var bulletPowerMult = 1
@export var bulletPowerShift = 0

var bulletsSpawnPeriod = 2.0

var towerInd = 0
var bullet = load("res://Data/BulletScene.tscn")

var pool = {}
var lvl = 1

func set_bullet_speed(_speed: float):
	bulletSpeed = _speed
	for blt in bullets.get_children():
		blt.set_start_speed(_speed)
		
func set_bullets_spawn_period(_spawnPeriod: float):
	bulletsSpawnPeriod = _spawnPeriod
	spawnTimer.wait_time = bulletsSpawnPeriod

func get_bullet_spawn_period() -> float:
	return bulletsSpawnPeriod
	
func _ready() -> void:
	pass

func get_width()->int:
	return rect.size.x

func get_height()->int:
	return rect.size.y
		
func init(_lvl: int, _pos: Vector2, _towerInd: int):
	position = _pos
	change_lvl(_lvl)
	towerInd = _towerInd
	set_bullets_spawn_period(bulletsSpawnPeriod)
	start_shooting()

func set_tower_ind(_towerInd: int):
	towerInd = _towerInd

func get_tower_ind() -> int:
	return towerInd
	
func start_shooting():
	spawnTimer.start()
	
func stop_shooting():
	spawnTimer.stop()

func restart():
	stop_shooting()
	for blt in bullets.get_children():
		remove_bullet(blt)
	start_shooting()

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
			
func create_bullet():
	if(!pool.has(lvl)):
		pool[lvl] = Array()
	
	var data = pool[lvl].pop_front()
	if(data == null):
		data = bullet.instantiate()
	
	data.init(lvl, get_width())

	data.set_power_multyplier(bulletPowerMult)
	data.set_power_shift_val(bulletPowerShift)
	data.set_start_speed(bulletSpeed)
		
	return data

func remove_bullet(_bullet: BulletElement):
	var bulletLvl = _bullet.lvl
	if(!pool.has(bulletLvl)):
		pool[bulletLvl] = Array()
	bullets.call_deferred('remove_child', _bullet)
	_bullet.deactivate()
	pool[bulletLvl].push_back(_bullet)
	
func change_lvl(_lvl: int):
	lvl = _lvl
	var r = int(pow(2, lvl))
	lvlLbl.text = str(get_str_lbl(r))
	
	r = r % 10
	var background = Color(0, 0, 0, 1)
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
	
	if(lvl == 0):
		visible = false
	else:
		visible = true

func _on_spawn_timer_timeout() -> void:
	if(visible):
		var bult = create_bullet()
		bullets.add_child(bult)
		bult.set_tower(self)

func is_pnt_in_area(pnt: Vector2) -> bool:
	var globalPos = global_position
	var mousePos = pnt
	var leftX = globalPos.x + rect.position.x
	var rightX = leftX + get_width() - 10
	var upY = globalPos.y + rect.position.y
	var downY = upY + get_height() - 10
	if(mousePos.x > leftX and mousePos.x < rightX):
		if(mousePos.y > upY and mousePos.y < downY):
			return true
	return false
