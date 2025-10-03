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
    super ._ready()

    produceComponent.produceInterval = produceInterval
    produceComponent.num = sunNum

    growUpComponent.growUpTime[0] = growUpTime

func GowUp(reach: int) -> void :
    match reach:
        0:
            sunNum = 25
            produceComponent.num = sunNum
