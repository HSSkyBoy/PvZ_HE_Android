@tool
class_name CharacterDamagePointData extends Resource

@export var damagePointList: Array[CharacterDamagePointConfig]:
    set(_damagePointList):
        damagePointList = _damagePointList
        emit_changed()
        Refresh()

@export var damagePointDictionary: Dictionary = {}
@export var fliterOpenAll: Array[String] = []
@export var fliterCloseAll: Array[String] = []

func Refresh():
    fliterOpenAll.clear()
    fliterCloseAll.clear()
    damagePointDictionary = {}

    damagePointList.sort_custom(
        func(a: CharacterDamagePointConfig, b: CharacterDamagePointConfig):
            if !a || !b:
                return false
            return a.damagePersontage > b.damagePersontage
    )

    for config: CharacterDamagePointConfig in damagePointList:
        if config:
            var fliterOpenGet: Array[String] = Array(Array(config.animeFliterOpen.split("&", false)), TYPE_STRING, "", null)
            var fliterCloseGet: Array[String] = Array(Array(config.animeFliterClose.split("&", false)), TYPE_STRING, "", null)
            damagePointDictionary[config.damagePointName] = {
                "Config": config, 
                "Open": fliterOpenGet, 
                "Close": fliterCloseGet
            }
            if !fliterOpenGet.is_empty():
                fliterOpenAll.append_array(fliterOpenGet)
            if !fliterCloseGet.is_empty():
                fliterCloseAll.append_array(fliterCloseGet)

func ClearDamagePointFliters(sprite: AdobeAnimateSprite):
    sprite.SetFliters(fliterCloseAll, true)
    sprite.SetFliters(fliterOpenAll, false)

func SetDamagePointFliters(sprite: AdobeAnimateSprite, damagePointName: String):
    var data: Dictionary = damagePointDictionary[damagePointName]
    var config: CharacterDamagePointConfig = data["Config"]

    sprite.SetFliters(data["Close"], false)
    sprite.SetFliters(data["Open"], true)

    if config.replaceMediaName:
        sprite.SetReplace(config.replaceMediaName, config.replaceMediaTexture)



func CreateEffect(sprite: AdobeAnimateSprite, damagePointName: String, gridPos: Vector2i = Vector2i(-1, -1)):
    var damagePointConfig: CharacterDamagePointConfig = damagePointDictionary[damagePointName]["Config"]
    if damagePointConfig.animeEffect:
        var effect: TowerDefenseEffectParticlesOnce = TowerDefenseManager.CreateEffectParticlesOnce(damagePointConfig.animeEffect, gridPos)
        var characterNode: Node2D = TowerDefenseManager.GetCharacterNode()
        effect.global_position = sprite.global_position + damagePointConfig.animeEffectOffset
        characterNode.add_child(effect)
