extends Node2D
class_name EnemyElement

@export var health = 20
@export var power = 2
@export var startPosition = Vector2.ZERO
@export var moveVector = Vector2(-1, 0)
@export var speed = 10

var collider = null
var powerLabel = null

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
	collider.disabled = false
	position = startPosition
	
func deactivate():
	visible = false
	collider.disabled = true
	position = Vector2(-200, -200)

func _process(delta: float) -> void:
	if(collider.disabled):
		return
	position = position + speed*moveVector

func _on_enemy_area_entered(area: Area2D) -> void:
	if(area.name == "wall"):
		get_parent().get_parent().remove_enemy(self)
