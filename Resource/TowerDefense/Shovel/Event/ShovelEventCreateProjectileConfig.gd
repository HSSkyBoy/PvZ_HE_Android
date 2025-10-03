class_name ShovelEventCreateProjectileConfig extends ShovelEventConfig

@export var everyNum: int = 10

func Execute(character: TowerDefenseCharacter):
    var height: float = character.GetGroundHeight(character.global_position.y)
    for i in floor(character.cost / everyNum):
        var heightOffset: float = randf_range(-10, 40)
        var projectile = FireComponent.CreateProjectilePosition(character, null, height + heightOffset - 20, character.global_position + Vector2(randf_range(-10, 10), -20), Vector2(300.0, 0.0), "SnowPea", -1, character.camp)
        projectile.gridPos.y = character.gridPos.y
