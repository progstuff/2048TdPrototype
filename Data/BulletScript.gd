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

func _ready() -> void:
	pass

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
	var r = int(pow(2, lvl))
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
	
func activate():
	visible = true
	position = Vector2(shiftX, 0)
	isActive = true

func deactivate():
	visible = false
	position = Vector2(-10000, -10000)
	isActive = false
	
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
