extends Node2D
class_name EnemyElement

@export var maxHealth = 20
var curHealth = maxHealth
@export var startPosition = Vector2.ZERO
@export var moveVector = Vector2(-1, 0)
@export var speed = 10

var isActivated = false
var collider = null
var healthLabel = null
var spawner = null
var rect = null

func init(_health: int, _startPosition: Vector2, _speed: int):
	
	if(collider == null):
		collider = $enemy/Collider
	if(healthLabel == null):
		healthLabel = $ColorRect/Health
	if(rect == null):
		rect = $ColorRect
		
	maxHealth = _health
	curHealth = _health
	startPosition = _startPosition
	startPosition.y = startPosition.y - rect.size.y/2
	healthLabel.text = str(int(curHealth))
	speed = _speed
	
	activate()
	
func activate():
	visible = true
	position = startPosition
	isActivated = true
	
func deactivate():
	isActivated = false
	visible = false
	position = Vector2(-2000, -2000)

func _process(_delta: float) -> void:
	if(!isActivated):
		return
	position = position + speed*moveVector*_delta

func _on_enemy_area_entered(area: Area2D) -> void:
	if spawner == null:
		spawner = get_parent().get_parent()
	if(area.name == "wall"):
		print(position)
		spawner.remove_enemy(self)
	if(area.name == "bullet"):
		var damage = area.get_parent().calculate_power()
		curHealth = curHealth - damage
		if(curHealth < 1):
			healthLabel.text = "%0.1f" % curHealth
		else:
			healthLabel.text = str(int(curHealth))
		if(curHealth <= 0):
			spawner.remove_enemy(self)

func get_global_center_pos() -> Vector2:
	var x = rect.size.x/2 + global_position.x
	var y = rect.size.y/2 + global_position.y
	return Vector2(x, y)
