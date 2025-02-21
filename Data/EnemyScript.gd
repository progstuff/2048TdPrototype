extends Node2D
class_name EnemyElement

@export var health = 20
@export var power = 2
@export var startPosition = Vector2.ZERO
@export var moveVector = Vector2(-1, 0)
@export var speed = 10

var isActivated = false
var collider = null
var powerLabel = null
var spawner = null

func init(_power: int, _health: int, _startPosition: Vector2, _speed: int):
	
	if(collider == null):
		collider = $enemy/Collider
	if(powerLabel == null):
		powerLabel = $ColorRect/Power
	
	power = _power
	health = _health
	startPosition = _startPosition
	powerLabel.text = str(power)
	speed = _speed
	
	activate()
	
func activate():
	visible = true
	position = startPosition
	isActivated = true
	
func deactivate():
	isActivated = false
	visible = false
	position = Vector2(-200, -200)
	

func _process(_delta: float) -> void:
	if(!isActivated):
		return
	position = position + speed*moveVector*_delta

func _on_enemy_area_entered(area: Area2D) -> void:
	if spawner == null:
		spawner = get_parent().get_parent()
	if(area.name == "wall"):
		spawner.remove_enemy(self)
	if(area.name == "bullet"):
		var damage = area.get_parent().get_power()
		health = health - damage
		if(health <= 0):
			spawner.remove_enemy(self)
