class_name BuffComponent extends ComponentBase

var parent: TowerDefenseCharacter

@export var buffDictionary: Dictionary[String, TowerDefenseCharacterBuffConfig]

func _ready() -> void :
    parent = get_parent()

func _physics_process(delta: float) -> void :
    if !alive:
        return
    for buffKey: String in buffDictionary.keys():
        if !buffDictionary.has(buffKey):
            continue
        var buff: TowerDefenseCharacterBuffConfig = buffDictionary[buffKey]
        if buff.Step(delta):
            BuffDelete(buffKey)

func BuffHas(key: String) -> bool:
    return buffDictionary.has(key)

func BuffAdd(buffConfig: TowerDefenseCharacterBuffConfig) -> void :
    if buffConfig.refresh && BuffHas(buffConfig.key):
        buffDictionary[buffConfig.key].Refresh(buffConfig)
    else:
        buffDictionary[buffConfig.key] = buffConfig

    buffDictionary[buffConfig.key].character = parent
    buffDictionary[buffConfig.key].Enter()

func BuffDelete(key: String) -> void :
    if !BuffHas(key):
        return
    var buff: TowerDefenseCharacterBuffConfig = buffDictionary[key]
    buff.Exit()
    buffDictionary.erase(key)
