class_name TowerDefensePacketEventMathine

const eventList: Dictionary = {

}

static func EventGet(eventName: String) -> TowerDefensePacketEventBase:
    match eventName:
        "ChangePacket":
            return TowerDefensePacketEventChangePacket.new()
        "ChangeCost":
            return TowerDefensePacketEventChangeCost.new()
        "Delete":
            return TowerDefensePacketEventDelete.new()
    return null
