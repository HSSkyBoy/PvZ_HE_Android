class_name TowerDefenseCharacterPropertyChangeConfig extends Resource

@export var propertyName: String = ""
@export_storage var value: Variant

func Init(data: Dictionary) -> void :
    propertyName = data.get("PropertyName", "")
    value = data.get("Value", null)

func Export() -> Dictionary:
    return {
        "PropertyName" = propertyName, 
        "Value" = value
    }

func Execute(character: TowerDefenseCharacter) -> void :
    character.set(propertyName, value)
