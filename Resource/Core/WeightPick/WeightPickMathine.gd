class_name WeightPickMathine

static func Pick(items: Array[WeightPickItemBase]) -> WeightPickItemBase:
    var weightTotal: int = 0
    for item in items:
        weightTotal += item.weight

    var r: int = randi() %weightTotal
    for item in items:
        r -= item.weight
        if r <= 0:
            return item

    return null
