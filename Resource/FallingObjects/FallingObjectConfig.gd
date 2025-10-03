class_name FallingObjectConfig extends Resource

@export var weightItem: Array[FallingObjectWeightItemConfig]

func Pick() -> ObjectManagerConfig.OBJECT:
    var pickItemList: Array[WeightPickItemBase]
    for item: FallingObjectWeightItemConfig in weightItem:
        pickItemList.append(WeightPickItemBase.new(item.item, item.weight, item.empty))
    return WeightPickMathine.Pick(pickItemList).item
