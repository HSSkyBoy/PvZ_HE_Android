class_name TowerDefenseCharacterOverride extends Resource

@export var scale: float = -1
@export var hitpointScale: float = -1
@export var walkSpeedScale: Vector2 = Vector2(-1, -1)
@export var animeSpeedScale: Vector2 = Vector2(-1, -1)
@export var armor: Array = []

func Init(data: Dictionary) -> void :
    scale = data.get("Scale", -1)
    hitpointScale = data.get("HitpointScale", -1)

    var walkSpeedScaleGet = data.get("WalkSpeedScale", [-1, -1])
    if walkSpeedScaleGet is Array:
        if walkSpeedScaleGet.size() == 2:
            walkSpeedScale = Vector2(walkSpeedScaleGet[0], walkSpeedScaleGet[1])
        elif walkSpeedScaleGet.size() == 1:
            walkSpeedScale = Vector2(walkSpeedScaleGet[0], walkSpeedScaleGet[0])
    if walkSpeedScaleGet is float:
        walkSpeedScale = Vector2.ONE * walkSpeedScaleGet
    var animeSpeedScaleGet = data.get("AnimeSpeedScale", [-1, -1])
    if animeSpeedScaleGet is Array:
        if animeSpeedScaleGet.size() == 2:
            animeSpeedScale = Vector2(animeSpeedScaleGet[0], animeSpeedScaleGet[1])
        elif animeSpeedScaleGet.size() == 1:
            animeSpeedScale = Vector2(animeSpeedScaleGet[0], animeSpeedScaleGet[0])
    if animeSpeedScaleGet is float:
        animeSpeedScale = Vector2.ONE * animeSpeedScaleGet

    armor = data.get("Armor", [])

func Export() -> Dictionary:
    return {
        "Scale": scale, 
        "HitpointScale": hitpointScale, 
        "WalkSpeedScale": [walkSpeedScale.x, walkSpeedScale.y], 
        "AnimeSpeedScale": [animeSpeedScale.x, animeSpeedScale.y], 
        "Armor": armor, 
    }

func ExecuteCharacter(character: TowerDefenseCharacter) -> void :
    if scale != -1:
        character.transformPoint.scale = scale * Vector2.ONE

    if hitpointScale != -1:
        character.instance.hitpointScale = hitpointScale

    if character is TowerDefenseZombie:
        if walkSpeedScale != Vector2(-1, -1):
            character.walkSpeedScale *= randf_range(walkSpeedScale.x, walkSpeedScale.y)

    if animeSpeedScale != Vector2(-1, -1):
        character.timeScale *= randf_range(animeSpeedScale.x, animeSpeedScale.y)

    if !armor.is_empty():
        for armorName in armor:
            character.instance.ArmorAdd(armorName)
