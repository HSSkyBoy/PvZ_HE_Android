class_name WeightPickMathine

static func Pick(items: Array[WeightPickItemBase]) -> WeightPickItemBase:
    if items.size() > 0:
        var weightTotal: int = 0
        for item in items:
            weightTotal += item.weight

        if weightTotal > 0:
            var r: int = randi() %weightTotal
            for item in items:
                r -= item.weight
                if r <= 0:
                    return item
        else:
            return null
    return null
