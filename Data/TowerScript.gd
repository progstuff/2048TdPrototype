extends Node2D
class_name TowerElement

@onready var rect = $ColorRect
@onready var lvlLbl = $ColorRect/Label
@onready var bullets = $Bullets

var needSpawnBullets = false
var curSpawnTime = 0
var spawnWaitTime = 2

@export var bulletSpeed = 150
@export var bulletPowerMult = 1
@export var bulletPowerShift = 0

var bulletsSpawnPeriod = 2.0
var bulletSpawnMult = 1.0

var towerInd = 0
var bullet = load("res://Data/BulletScene.tscn")

var pool = {}
var lvl = 1

func set_normal_shoot_period():
	spawnWaitTime = bulletsSpawnPeriod
	bulletSpawnMult = 1.0

func set_boosted_shoot_period(_bulletSpawnMult: float):
	bulletSpawnMult = _bulletSpawnMult
	spawnWaitTime = bulletsSpawnPeriod / bulletSpawnMult

func get_bullet_spawn_mult() -> float:
	return bulletSpawnMult

func set_bullet_speed(_speed: float):
	bulletSpeed = _speed
	for blt in bullets.get_children():
		blt.set_start_speed(_speed)
		
func set_bullets_spawn_period(_spawnPeriod: float):
	bulletsSpawnPeriod = _spawnPeriod
	spawnWaitTime = bulletsSpawnPeriod

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
	needSpawnBullets = true
	
func stop_shooting():
	needSpawnBullets = false
	curSpawnTime = 0

func restart():
	stop_shooting()
	for blt in bullets.get_children():
		remove_bullet(blt)
	set_normal_shoot_period()
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
	
	r = lvl % 15
	
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
	
	if(lvl == 0):
		visible = false
	else:
		visible = true

func _process(_delta: float) -> void:
	if(!needSpawnBullets):
		curSpawnTime = 0
		return
	
	curSpawnTime += _delta
	if(curSpawnTime >= spawnWaitTime):
		spawn_bullet()
		curSpawnTime = 0
	
func spawn_bullet() -> void:
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
