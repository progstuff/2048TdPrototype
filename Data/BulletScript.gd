extends Node2D
class_name BulletElement

var lvl = 1
var startSpeed = 150 #скорость в пикс в сек
var speed
var startY = 0
var isActive = false
var shiftX = 0
@onready var rect = $ColorRect
var tower = null

var powerMultyplier = 1
var powerShiftVal = 0

var poison = null

func _ready() -> void:
	pass

func is_poisoned():
	return poison != null

func get_poison() -> Node:
	return poison

func set_poison(_poisonParams: Node):
	poison = _poisonParams
	
func set_power_multyplier(_multyplier: float):
	powerMultyplier = _multyplier

func set_power_shift_val(_shiftVal: float):
	powerShiftVal = _shiftVal

func get_power_multyplier() -> float:
	return powerMultyplier

func get_power_shift_val() -> float:
	return powerShiftVal
	
func calculate_power() -> float:
	return lvl * powerMultyplier + powerShiftVal
	
func set_start_speed(_speed: int):
	startSpeed = _speed
	speed = startSpeed

func get_start_speed() -> float:
	return startSpeed
	
func init(_lvl: int, _shiftX: int):
	change_lvl(_lvl)
	speed = startSpeed
	shiftX = _shiftX
	activate()

func set_tower(_tower: TowerElement):
	tower = _tower
	
func change_lvl(_lvl: int) -> void:
	lvl = _lvl
	
	if rect == null:
		rect = $ColorRect

	var r = lvl % 15
	
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
	rect.color = background
	
func activate():
	visible = true
	position = Vector2(shiftX, 0)
	isActive = true

func deactivate():
	visible = false
	position = Vector2(-10000, -10000)
	isActive = false
	poison = null
	
func _process(_delta: float) -> void:
	if isActive:
		var shift = speed * _delta
		position.x = position.x + shift
		position.y = startY
		
		if(tower == null):
			return
		
		var pos = global_position
		var screenWidth = get_viewport_rect().size.x
		if(pos.x >= screenWidth*0.9):
			tower.remove_bullet(self)
