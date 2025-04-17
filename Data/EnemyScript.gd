extends Node2D
class_name EnemyElement

@onready var enemyImage = $Sprite
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite

@export var maxHealth = 1
var curHealth = maxHealth
@export var startPosition = Vector2.ZERO
@export var moveVector = Vector2(-1, 0)
@export var speed = 30

var isActivated = false
var collider = null
var healthLabel = null
var spawner = null
var rect = null

var isPoisoned = false
var poison = null

var isFreezed = false
var freeze = null

func init(_health: int, _startPosition: Vector2, _speed: int):
	
	if(collider == null):
		collider = $enemy/Collider
	if(healthLabel == null):
		healthLabel = $ColorRect/Health
	if(rect == null):
		rect = $ColorRect
	if(animationPlayer == null):
		animationPlayer = $AnimationPlayer
	if(sprite == null):
		sprite = $Sprite
		
	maxHealth = _health
	curHealth = _health
	startPosition = _startPosition
	startPosition.y = startPosition.y - rect.size.y/2
	healthLabel.text = str(int(curHealth))
	speed = _speed
	
	activate()

func set_poison(_poison:Node):
	poison = _poison
	isPoisoned = true
	
	if(rect == null):
		rect = $ColorRect
	
	rect.color = Color8(0, 255, 0, 255)

func remove_poison():
	poison = null
	isPoisoned = false
	
	if(rect == null):
		rect = $ColorRect
	
	rect.color = Color8(0, 0, 0, 255)

func set_freeze(_freeze:Node):
	freeze = _freeze
	isFreezed = true
	
	if(rect == null):
		rect = $ColorRect
	
	rect.color = Color8(0, 0, 255, 255)
	
func get_poison() -> Node:
	return poison

func remove_freeze():
	freeze = null
	isFreezed = false
	
	if(rect == null):
		rect = $ColorRect
	
	rect.color = Color8(0, 0, 0, 255)
	
func get_freeze() -> Node:
	return freeze
	
func activate():
	visible = true
	position = startPosition
	isActivated = true
	isPoisoned = false
	isFreezed = false
	sprite.modulate = Color8(0, 255, 0)
	animationPlayer.play("walk")
	
func deactivate():
	isActivated = false
	visible = false
	position = Vector2(-2000, -2000)
	isPoisoned = false
	isFreezed = false
	animationPlayer.stop()

func _process(_delta: float) -> void:
	if(!isActivated):
		return
	var deltaR = speed*moveVector*_delta
	if(freeze != null):
		deltaR = deltaR * freeze.get_slow_factor()
	position = position + deltaR
	

func _on_enemy_area_entered(area: Area2D) -> void:
	if spawner == null:
		spawner = get_parent().get_parent()
	if(area.name == "wall"):
		print(position)
		spawner.remove_enemy(self)
	if(area.name == "bullet"):
		var bullet = area.get_parent()
		var damage = bullet.calculate_power()
		damaged(damage)
		
		if(bullet.is_poisoned()):
			var psn = bullet.get_poison()
			psn.add_poison_to_enemy(self)
		
		if(bullet.is_freezed()):
			var psn = bullet.get_freeze()
			psn.add_freeze_to_enemy(self)
		
func is_poisoned() -> bool:
	return isPoisoned

func is_freezed() -> bool:
	return isFreezed
	
func damaged(_damage: float):
	curHealth = curHealth - _damage
	if(curHealth < 1):
		healthLabel.text = "%0.1f" % curHealth
	else:
		healthLabel.text = str(int(curHealth))
	if(curHealth <= 0):
		spawner.remove_enemy(self)
	var h = curHealth/maxHealth
	if(h >= 0.3 and h <= 0.7):
		sprite.modulate = Color8(255, 255, 0)
	elif(h < 0.3):
		sprite.modulate = Color8(255, 0, 0)
		
		
func get_global_center_pos() -> Vector2:
	var x = rect.size.x/2 + global_position.x
	var y = rect.size.y/2 + global_position.y
	return Vector2(x, y)
