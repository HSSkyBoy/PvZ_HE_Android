class_name TowerDefensePacketEventChangeCost extends TowerDefensePacketEventBase

enum METHOD{
    ADD, 
    MULTIPLY
}
@export var method: METHOD = METHOD.ADD
@export var value: float = 0.0
@export var _min: int = -1
@export var _max: int = -1

@warning_ignore("unused_parameter")
func Init(data: Dictionary) -> void :
    method = METHOD.get(str(data.get("Method", "ADD")).to_upper())
    value = data.get("Value", 0.0)
    _min = data.get("Min", -1)
    _max = data.get("Max", -1)

@warning_ignore("unused_parameter")
func Execute(packet: TowerDefenseInGamePacketShow) -> void :
    match method:
        METHOD.ADD:
            packet.baseItemCost += int(value)
        METHOD.MULTIPLY:
            packet.baseItemCost = floor(packet.baseItemCost * value)
    if _min != -1:
        if packet.baseItemCost < _min:
            packet.baseItemCost = _min
    if _max != -1:
        if packet.baseItemCost > _max:
            packet.baseItemCost = _max
