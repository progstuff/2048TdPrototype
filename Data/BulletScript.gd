extends Node2D
class_name BulletElement

var lvl = 1
var speed = 100 #скорость в пикс в сек
var power = pow(2, lvl)
var startY = 0
var isActive = false
@onready var rect = $ColorRect

func _ready() -> void:
	pass

func init(_lvl: int, _pos: Vector2):
	startY = _pos.y
	position = _pos
	change_lvl(_lvl)
	speed = 20*lvl
	
	activate()
	
func change_lvl(_lvl: int) -> void:
	lvl = _lvl
	
	if rect == null:
		rect = $ColorRect
	if(lvl == 0):
		rect.color = Color(0.8, 0, 0, 1)
	elif(lvl == 1):
		rect.color = Color(0, 0.8, 0, 1)
	elif(lvl == 2):
		rect.color = Color(0, 0, 0.8, 1)
	elif(lvl == 3):
		rect.color = Color(0.8, 0.8, 0, 1)
	elif(lvl == 4):
		rect.color = Color(0, 0.8, 0.8, 1)
		
	power = pow(2, lvl)
	
func activate():
	visible = true
	isActive = true

func deactivate():
	visible = false
	position = Vector2(-100, -100)
	isActive = false

func get_power() -> int:
	return power
	
func _process(_delta: float) -> void:
	if isActive:
		var shift = speed * _delta
		position.x = position.x + shift
		position.y = startY - rect.size.y/2
