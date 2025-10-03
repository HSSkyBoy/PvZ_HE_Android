class_name TowerDefenseProjectileEffectBase extends Node2D

@export var eventList: Array[TowerDefenseCharacterEventBase]

var gridPos: Vector2i
var camp: TowerDefenseEnum.CHARACTER_CAMP
var collisionFlag: int

func Init(_gridPos: Vector2i, _camp: TowerDefenseEnum.CHARACTER_CAMP, _collisionFlag: int) -> void :
    gridPos = _gridPos
    camp = _camp
    collisionFlag = _collisionFlag
