extends Node2D
class_name BulletElement

var lvl = 1
var startSpeed = 150 #скорость в пикс в сек
var speed
var startY = 0
var isActive = false
var shiftX = 0

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
var tower = null

var powerMultyplier = 1
var powerShiftVal = 0
var damageMult = 1

var poison = null
var freeze = null

func _ready() -> void:
	pass

func is_poisoned():
	return poison != null

func get_poison() -> Node:
	return poison

func set_poison(_poisonParams: Node):
	poison = _poisonParams
	set_poison_color()

func is_freezed():
	return freeze != null

func get_freeze() -> Node:
	return freeze

func set_freeze(_freezeParams: Node):
	freeze = _freezeParams
	set_freeze_color()
		
func set_power_multyplier(_multyplier: float):
	powerMultyplier = _multyplier

func set_power_shift_val(_shiftVal: float):
	powerShiftVal = _shiftVal

func get_power_multyplier() -> float:
	return powerMultyplier

func get_power_shift_val() -> float:
	return powerShiftVal
	
func calculate_power() -> float:
	return (lvl * powerMultyplier + powerShiftVal) * damageMult
	
func set_start_speed(_speed: int):
	startSpeed = _speed
	speed = startSpeed

func get_start_speed() -> float:
	return startSpeed
	
func init(_tower: Node2D, _lvl: int, _shiftX: int):
	if(sprite == null):
		sprite = $Sprite2D
	if(animationPlayer == null):
		animationPlayer = $AnimationPlayer
	tower = _tower
	damageMult = tower.get_bullet_attack_damage_mult()
	change_lvl(_lvl)
	speed = startSpeed
	shiftX = _shiftX
	activate()

func set_tower(_tower: TowerElement):
	tower = _tower
	
func change_lvl(_lvl: int) -> void:
	lvl = _lvl
	set_color()

func set_poison_color():

	if(poison != null):
		var background = Color8(0, 255, 0, 255)
		sprite.modulate = background

func set_freeze_color():

	if(freeze != null):
		var background = Color8(0, 0, 255, 255)
		sprite.modulate = background
		
func set_color():
	
	if(poison != null):
		set_poison_color()
		return
	
	if(freeze != null):
		set_freeze_color()
		return
	
	if(damageMult > 1):
		sprite.modulate = Color8(255, 0, 0, 255)
		return
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
	sprite.modulate = background
	
func activate():
	visible = true
	position = Vector2(shiftX, 0)
	isActive = true
	animationPlayer.play("shoot")

func deactivate():
	visible = false
	position = Vector2(-10000, -10000)
	isActive = false
	poison = null
	freeze = null
	animationPlayer.stop()
	
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
