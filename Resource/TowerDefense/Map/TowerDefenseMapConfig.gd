class_name TowerDefenseMapConfig extends Resource

@export var translate: String = ""
@export var mapTexture: Texture2D
@export var mapScene: PackedScene
@export var mapSize: Vector2 = Vector2(1400, 600)
@export var gridNum: Vector2i = Vector2i(9, 5)
@export var gridBeginPos: Vector2 = Vector2(256.0, 45.0)
@export var gridSize: Vector2 = Vector2(80.0, 98.0)
@export var edge: Vector4 = Vector4(200.0, 0.0, 1100.0, 576.0)
@export var cellConfig: Array[TowerDefenseCellConfig]

@export var lineUse: Array[int]
@export var isNight: bool = false
@export var useSunFall: bool = true
