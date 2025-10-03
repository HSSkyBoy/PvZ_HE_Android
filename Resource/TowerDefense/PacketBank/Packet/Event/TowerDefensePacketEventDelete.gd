class_name TowerDefensePacketEventDelete extends TowerDefensePacketEventBase

@warning_ignore("unused_parameter")
func Init(data: Dictionary) -> void :
    pass

@warning_ignore("unused_parameter")
func Execute(packet: TowerDefenseInGamePacketShow) -> void :
    packet.queue_free()
