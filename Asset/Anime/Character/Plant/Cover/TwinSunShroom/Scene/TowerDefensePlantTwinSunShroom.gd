@tool
extends TowerDefensePlant

@onready var produceComponent: ProduceComponent = %ProduceComponent
@onready var growUpComponent: GrowUpComponent = %GrowUpComponent

@export var produceInterval: float = 25.0
@export var sunNum: int = 25
@export var growUpTime: float = 60.0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()

    produceComponent.produceInterval = produceInterval
    produceComponent.num = sunNum

    growUpComponent.growUpTime[0] = growUpTime

func GowUp(reach: int) -> void :
    match reach:
        0:
            sunNum = 50
            produceComponent.num = sunNum

func Cover(character: TowerDefenseCharacter) -> void :
    if character.config.name == "PlantSunShroom":
        transformPoint.scale = character.transformPoint.scale
        shadowSprite.scale = character.shadowSprite.scale
        saveShadowScale = character.saveShadowScale
        sunNum = character.sunNum
        produceComponent.num = character.produceComponent.num
        growUpComponent.growUpReach = character.growUpComponent.growUpReach
        growUpComponent.timer = character.growUpComponent.timer
