extends Node2D

@onready var rect = $ColorRect
@onready var lvlLbl = $ColorRect/Label
@onready var bullets = $Bullets
@onready var timer = $Timer

var bullet = load("res://Data/BulletScene.tscn")

var pool = {}
var lvl = 1

func _ready() -> void:
	pass

func get_width()->int:
	return rect.size.x
	
func init(_lvl: int, pos: Vector2):
	position = pos
	change_lvl(_lvl)
	start_shooting()

func start_shooting():
	timer.start()
	
func stop_shooting():
	timer.stop()

func create_bullet():
	if(!pool.has(lvl)):
		pool[lvl] = Array()
	
	var data = pool[lvl].pop_front()
	if(data == null):
		data = bullet.instantiate()
	
	data.init(lvl, position + Vector2(rect.size.x, rect.size.y/2))
		
	return data

func remove_bullet(_bullet: BulletElement):
	var bulletLvl = _bullet.lvl
	if(!pool.has(bulletLvl)):
		pool[bulletLvl] = Array()
		
	_bullet.deactivate()
	pool[bulletLvl].push_back(_bullet)
	
func change_lvl(_lvl: int):
	lvl = _lvl
	lvlLbl.text = str(_lvl)
	
	var tm = 2.0 - float(lvl)/30.0
	if(tm < 0):
		tm = float(lvl)/30.0
		
	timer.wait_time = tm
	
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

func _on_timer_timeout() -> void:
	var bult = create_bullet()
	bullets.add_child(bult)
