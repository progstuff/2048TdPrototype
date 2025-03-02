extends Node2D

signal coin_clicked_signal
var coinScene = load("res://Data/CoinScene.tscn")

@onready var coins = $Coins
var deletedCoins = []

func _ready() -> void:
	pass

func create_coin(_pos: Vector2):
	var coin = null
	if(deletedCoins.is_empty()):
		coin = coinScene.instantiate()
	else:
		coin = deletedCoins.pop_back()
	coin.init(self, _pos)
	coins.add_child(coin)

func remove_coin(_coin: CoinElement):
	coins.remove_child(_coin)
	_coin.deactivate()
	deletedCoins.append(_coin)

func remove_coin_after_click(_coin: CoinElement):
	coins.remove_child(_coin)
	_coin.deactivate()
	deletedCoins.append(_coin)
	coin_clicked_signal.emit()

func remove_coins():
	for coin in coins.get_children():
		remove_coin(coin)
