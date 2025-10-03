class_name ShovelEventRecycleConfig extends ShovelEventConfig

@export var percentage: float = 0.2
@export var destroy: bool = true

func Execute(character: TowerDefenseCharacter):
    character.Recycle(percentage, destroy)
