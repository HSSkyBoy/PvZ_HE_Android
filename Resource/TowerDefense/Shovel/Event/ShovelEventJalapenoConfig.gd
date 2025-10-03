class_name ShovelEventJalapenoConfig extends ShovelEventConfig

@export var destroy: bool = true

func Execute(character: TowerDefenseCharacter):
    if character.cost > 0:
        TowerDefenseCharacter.CreateJalapenoFire(character.gridPos)
        var event: TowerDefenseCharacterEventExplodeHurt = TowerDefenseCharacterEventExplodeHurt.new()
        event.type = "Bomb"
        event.num = character.cost
        event.burns = true
        TowerDefenseExplode.CreateExplodeLine(character.gridPos.y, [event], [], TowerDefenseEnum.CHARACTER_CAMP.PLANT, -1)
    if destroy:
        character.Destroy()
