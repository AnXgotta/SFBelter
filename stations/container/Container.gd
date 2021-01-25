extends Node2D

onready var inventory = null


func _ready() -> void:
	inventory = load("res://stations/container/Container.tres").duplicate()
	return
