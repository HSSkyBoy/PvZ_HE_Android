@tool



static func find_parent_state_chart(node: Node) -> StateChart:
    if node is StateChart:
        return node

    var parent = node.get_parent()
    while parent != null:
        if parent is StateChart:
            return parent

        parent = parent.get_parent()
    return null




static func events_of(chart: StateChart) -> Array[StringName]:
    var result: Array[StringName] = []

    _collect_events(chart, result)
    result.sort_custom( func(a, b): return a.naturalnocasecmp_to(b) < 0)
    return result


static func _collect_events(node: Node, events: Array[StringName]):
    if node is Transition:
        if node.event != "" and not events.has(node.event):
            events.append(node.event)

    for child in node.get_children():
        _collect_events(child, events)



static func transitions_of(chart: StateChart) -> Array[Transition]:
    var result: Array[Transition] = []
    _collect_transitions(chart, result)
    return result


static func _collect_transitions(node: Node, result: Array[Transition]):
    if node is Transition:
        result.append(node)

    for child in node.get_children():
        _collect_transitions(child, result)
