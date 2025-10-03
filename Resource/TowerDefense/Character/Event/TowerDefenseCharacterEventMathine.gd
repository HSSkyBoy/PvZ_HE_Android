class_name TowerDefenseCharacterEventMathine

static func EventGet(eventName: String) -> TowerDefenseCharacterEventBase:
    match eventName:

        "CreateAddPacket":
            return TowerDefenseCharacterEventCreateAddPacket.new()

        "SunCreate":
            return TowerDefenseCharacterEventSunCreate.new()
        "CraterCreate":
            return TowerDefenseCharacterEventCraterCreate.new()
        "PacketSpawn":
            return TowerDefenseCharacterEventPacketSpawn.new()

    return null
