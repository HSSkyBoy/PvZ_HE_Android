class_name RangeExecuteComponent extends ComponentBase

@export var rangeType: TowerDefenseEnum.RANGE_TYPE = TowerDefenseEnum.RANGE_TYPE.AREA
@export var executeArea: Area2D
@export var eventList: Array[TowerDefenseCharacterEventBase]
var parent: TowerDefenseCharacter

func _ready() -> void :
    parent = get_parent()

func CanAttack(checkArea: Area2D) -> bool:
    if !checkArea:
        return false
    return TowerDefenseManager.GetCharacterHasTargetFromArea(parent, checkArea)

func Execute() -> void :
    var targetList
    match rangeType:
        TowerDefenseEnum.RANGE_TYPE.AREA:
            targetList = TowerDefenseManager.GetCharacterTargetFromArea(parent, executeArea)
        TowerDefenseEnum.RANGE_TYPE.ROW:
            targetList = TowerDefenseManager.GetCharacterTargetLine(parent)
        TowerDefenseEnum.RANGE_TYPE.ENEMY:
            targetList = TowerDefenseManager.GetCharacterTargetNearFromArea(parent, executeArea)
    for targe in targetList:
        for event: TowerDefenseCharacterEventBase in eventList:
            event.Execute(Vector2.ZERO, targe)
