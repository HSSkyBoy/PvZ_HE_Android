class_name TowerDefenseExplode extends Node2D

const TOWER_DEFENSE_EXPLODE = preload("uid://dw6h5q4wxxrjl")

var shape: RectangleShape2D = RectangleShape2D.new()

static func CreateProjectileExplode(pos: Vector2, projectileConfig: TowerDefenseProjectileConfig, exclude: Array[TowerDefenseCharacter], camp: TowerDefenseEnum.CHARACTER_CAMP) -> TowerDefenseExplode:
    var instance = TOWER_DEFENSE_EXPLODE.instantiate()
    instance.global_position = pos
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child(instance)
    instance.InitProjectileExplode(projectileConfig, exclude, camp)
    return instance

func InitProjectileExplode(projectileConfig: TowerDefenseProjectileConfig, exclude: Array[TowerDefenseCharacter], camp: TowerDefenseEnum.CHARACTER_CAMP) -> void :
    if projectileConfig:
        shape.size = TowerDefenseManager.GetMapGridSize() * 2.0 * projectileConfig.rangeSize
    var params = PhysicsShapeQueryParameters2D.new()
    params.shape = shape
    params.collide_with_areas = true
    params.collision_mask = 1
    params.transform = Transform2D(0, global_position)
    await get_tree().physics_frame
    var arr = get_world_2d().direct_space_state.intersect_shape(params, 1000)
    for infor: Dictionary in arr:
        if infor["collider"] is Area2D:
            var area: Area2D = infor["collider"]
            var character = area.get_parent()
            if character is TowerDefenseCharacter:
                if character.camp == camp:
                    continue
                if exclude.has(character):
                    continue
                if !(projectileConfig.collisionFlags & character.instance.maskFlags) && projectileConfig.collisionFlags != -1:
                    continue
                for event in projectileConfig.hitCharacterEventList:
                    event.Execute(character.global_position, character)
                character.ProjectileHurt(null, projectileConfig, true, Vector2.ZERO, true)
    queue_free.call_deferred()

static func CreateExplode(pos: Vector2, size: Vector2, eventList: Array[TowerDefenseCharacterEventBase], exclude: Array[TowerDefenseCharacter], camp: TowerDefenseEnum.CHARACTER_CAMP, collisionFlags: int) -> TowerDefenseExplode:
    var instance = TOWER_DEFENSE_EXPLODE.instantiate()
    instance.global_position = pos
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child(instance)
    instance.InitExplode(size, eventList, exclude, camp, collisionFlags)
    return instance

func InitExplode(size: Vector2, eventList: Array[TowerDefenseCharacterEventBase], exclude: Array[TowerDefenseCharacter], camp: TowerDefenseEnum.CHARACTER_CAMP, collisionFlags: int) -> void :
    shape.size = TowerDefenseManager.GetMapGridSize() * 2.0 * size
    var params = PhysicsShapeQueryParameters2D.new()
    params.shape = shape
    params.collide_with_areas = true
    params.collision_mask = 1
    params.transform = Transform2D(0, global_position)
    await get_tree().physics_frame
    var arr = get_world_2d().direct_space_state.intersect_shape(params, 1000)
    for infor: Dictionary in arr:
        if infor["collider"] is Area2D:
            var area: Area2D = infor["collider"]
            var character = area.get_parent()
            if character is TowerDefenseCharacter:
                if character.camp == camp:
                    continue
                if exclude.has(character):
                    continue
                if !(collisionFlags & character.instance.maskFlags) && collisionFlags != -1:
                    continue
                for event: TowerDefenseCharacterEventBase in eventList:
                    event.Execute(global_position, character)
    queue_free.call_deferred()

static func CreateExplodeLine(line: int, eventList: Array[TowerDefenseCharacterEventBase], exclude: Array[TowerDefenseCharacter], camp: TowerDefenseEnum.CHARACTER_CAMP, collisionFlags: int) -> TowerDefenseExplode:
    var instance = TOWER_DEFENSE_EXPLODE.instantiate()
    var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
    characterNode.add_child(instance)
    instance.InitExplodeLine(line, eventList, exclude, camp, collisionFlags)
    return instance

func InitExplodeLine(line: int, eventList: Array[TowerDefenseCharacterEventBase], exclude: Array[TowerDefenseCharacter], camp: TowerDefenseEnum.CHARACTER_CAMP, collisionFlags: int) -> void :
    await get_tree().physics_frame
    var characterList = TowerDefenseManager.GetCharacterLine(line)
    for character in characterList:
        if character is TowerDefenseCharacter:
            if character.camp == camp:
                continue
            if exclude.has(character):
                continue
            if !(collisionFlags & character.instance.maskFlags) && collisionFlags != -1:
                continue
            for event: TowerDefenseCharacterEventBase in eventList:
                event.Execute(character.global_position + Vector2(randf_range(-25, 25), 0.0), character)
    queue_free.call_deferred()
