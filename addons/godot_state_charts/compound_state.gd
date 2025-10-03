@tool
@icon("compound_state.svg")


class_name CompoundState
extends StateChartState


signal child_state_entered()


signal child_state_exited()


@export_node_path("StateChartState") var initial_state: NodePath:
    get:
        return initial_state
    set(value):
        initial_state = value
        update_configuration_warnings()



var _active_state: StateChartState = null


@onready var _initial_state: StateChartState = get_node_or_null(initial_state)


var _history_states: Array[HistoryState] = []

var _needs_deep_history: bool = false

func _init() -> void :


    if Engine.is_editor_hint():
        child_entered_tree.connect(
            func(child: Node):



            if child is StateChartState and initial_state.is_empty():




                ( func(): initial_state = get_path_to(child)).call_deferred()
        )


func _state_init():
    super ._state_init()


    for child in get_children():
        if child is HistoryState:
            var child_as_history_state: HistoryState = child as HistoryState
            _history_states.append(child_as_history_state)

            _needs_deep_history = _needs_deep_history or child_as_history_state.deep


    for child in get_children():
        if child is StateChartState:
            var child_as_state: StateChartState = child as StateChartState
            child_as_state._state_init()
            child_as_state.state_entered.connect( func(): child_state_entered.emit())
            child_as_state.state_exited.connect( func(): child_state_exited.emit())

func _state_enter(transition_target: StateChartState):
    super ._state_enter(transition_target)




    var target_is_descendant: = false
    if transition_target != null and is_ancestor_of(transition_target):
        target_is_descendant = true

    if not target_is_descendant and not is_instance_valid(_active_state) and _state_active:
        if _initial_state != null:
            if _initial_state is HistoryState:
                _restore_history_state(_initial_state)
            else:
                _active_state = _initial_state
                _active_state._state_enter(null)
        else:
            push_error("No initial state set for state \'" + name + "\'.")

func _state_step():
    super ._state_step()
    if _active_state != null:
        _active_state._state_step()

func _state_save(saved_state: SavedState, child_levels: int = -1):
    super ._state_save(saved_state, child_levels)


    var parent = saved_state.get_substate_or_null(self)
    if parent == null:
        push_error("Probably a bug: The state of \'" + name + "\' was not saved.")
        return

    for history_state in _history_states:
        history_state._state_save(parent, child_levels)

func _state_restore(saved_state: SavedState, child_levels: int = -1):
    super ._state_restore(saved_state, child_levels)


    if active:

        for child in get_children():
            if child is StateChartState and child.active:
                _active_state = child
                break

func _state_exit():

    if _history_states.size() > 0:
        var saved_state = SavedState.new()


        _state_save(saved_state, -1 if _needs_deep_history else 1)


        for history_state in _history_states:




            history_state.history = saved_state


    if _active_state != null:
        _active_state._state_exit()
        _active_state = null
    super ._state_exit()


func _process_transitions(trigger_type: StateChart.TriggerType, event: StringName = "") -> bool:
    if not active:
        return false


    if is_instance_valid(_active_state):
        if _active_state._process_transitions(trigger_type, event):

            if trigger_type == StateChart.TriggerType.EVENT:
                self.event_received.emit(event)
            return true



    return super ._process_transitions(trigger_type, event)


func _handle_transition(transition: Transition, source: StateChartState):


    var target = transition.resolve_target()
    if not target is StateChartState:
        push_error("The target state \'" + str(transition.to) + "\' of the transition from \'" + source.name + "\' is not a state.")
        return












    if target == self:

        _state_exit()
        _state_enter(target)
        return

    if target in get_children():

        if is_instance_valid(_active_state):
            _active_state._state_exit()



        if target is HistoryState:
            _restore_history_state(target)
            return


        _active_state = target
        _active_state._state_enter(target)
        return

    if self.is_ancestor_of(target):

        for child in get_children():
            if child is StateChartState and child.is_ancestor_of(target):


                if _active_state != child:
                    if is_instance_valid(_active_state):
                        _active_state._state_exit()

                    _active_state = child



                    _active_state._state_enter(target)


                child._handle_transition(transition, source)
                return
        return


    get_parent()._handle_transition(transition, source)


func _restore_history_state(target: HistoryState):

    var saved_state = target.history
    if saved_state != null:

        _state_restore(saved_state, -1 if target.deep else 1)
        return


    var default_state = target.get_node_or_null(target.default_state)
    if is_instance_valid(default_state):
        _active_state = default_state
        _active_state._state_enter(null)
        return
    else:
        push_error("The default state \'" + str(target.default_state) + "\' of the history state \'" + target.name + "\' cannot be found.")
        return




func _get_configuration_warnings() -> PackedStringArray:
    var warnings = super ._get_configuration_warnings()


    var child_count = 0
    for child in get_children():
        if child is StateChartState:
            child_count += 1

    if child_count < 1:
        warnings.append("Compound states should have at least one child state.")

    elif child_count < 2:
        warnings.append("Compound states with only one child state are not very useful. Consider adding more child states or removing this compound state.")

    var the_initial_state = get_node_or_null(initial_state)

    if not is_instance_valid(the_initial_state):
        warnings.append("Initial state could not be resolved, is the path correct?")

    elif the_initial_state.get_parent() != self:
        warnings.append("Initial state must be a direct child of this compound state.")

    return warnings
