class_name TowerDefenseConveyorEventEnum

static func EventGet(eventName: String) -> TowerDefenseConveyorEventBase:
    match eventName:
        "AddPacket":
            return TowerDefenseConveyorEventAddPacket.new()
    return null
