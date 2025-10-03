class_name TowerDefensePlantfoodBank extends Control

@onready var plantfoodSlotContainer: HBoxContainer = %PlantfoodSlotContainer
@onready var plantfoodButton: TextureButton = %PlantfoodButton
var beginSizeX: int = 314
var sizeInterval: int = 50

signal pick()

func PlantfoodButtonPressed() -> void :
    pick.emit()
