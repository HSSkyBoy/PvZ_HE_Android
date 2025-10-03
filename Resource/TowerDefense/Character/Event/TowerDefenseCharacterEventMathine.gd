class_name TowerDefenseCharacterEventMathine


static func EventGet(eventName: String) -> TowerDefenseCharacterEventBase:
    match eventName:

        "CreateAddPacket":
            return TowerDefenseCharacterEventCreateAddPacket.new()


    return null
