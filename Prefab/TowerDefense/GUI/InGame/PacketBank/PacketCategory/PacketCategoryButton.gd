extends Control

signal choose(_category: String)

@export var category: String = "White"

func ButtonPressed() -> void :
    choose.emit(category)
