@tool
@icon("history_state.svg")
class_name HistoryState
extends StateChartState




@export var deep: bool = false


@export_node_path("StateChartState") var default_state: NodePath:
    set(value):
        default_state = value
        update_configuration_warnings()



var history: SavedState = null


func _state_save(saved_state: SavedState, _child_levels: int = -1) -> void :

    var our_state: = SavedState.new()
    our_state.history = history
    saved_state.add_substate(self, our_state)


func _state_restore(saved_state: SavedState, _child_levels: int = -1) -> void :

    var our_state: = saved_state.get_substate_or_null(self)
    if our_state != null:
        history = our_state.history


func _get_configuration_warnings() -> PackedStringArray:
    var warnings: = super._get_configuration_warnings()


    var parent_state: = get_parent()
    if not parent_state is CompoundState:
        warnings.append("A history state must be a child of a compound state.")


    var default_state_node: = get_node_or_null(default_state)
    if not default_state_node is StateChartState:
        warnings.append("The default state is not set or is not a state.")
    else:

        if not get_parent().is_ancestor_of(default_state_node):
            warnings.append("The default state must be a child of the parent state.")


    if get_child_count() > 0:
        warnings.append("History states cannot have child nodes.")

    return warnings
