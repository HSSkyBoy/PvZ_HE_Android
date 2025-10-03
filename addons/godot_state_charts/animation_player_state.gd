@tool
@icon("animation_player_state.svg")
class_name AnimationPlayerState
extends AtomicState


@export_node_path("AnimationPlayer") var animation_player: NodePath:
    set(value):
        animation_player = value
        update_configuration_warnings()



@export var animation_name: StringName = ""



@export var custom_blend: float = -1.0



@export var custom_speed: float = 1.0


@export var from_end: bool = false

var _animation_player: AnimationPlayer

func _ready():
    if Engine.is_editor_hint():
        return

    super ._ready()
    _animation_player = get_node_or_null(animation_player)

    if not is_instance_valid(_animation_player):
        push_error("The animation player is invalid. This node will not work.")

func _state_enter(transition_target: StateChartState):
    super ._state_enter(transition_target)

    if not is_instance_valid(_animation_player):
        return

    var target_animation = animation_name
    if target_animation == "":
        target_animation = get_name()

    if _animation_player.current_animation == target_animation and _animation_player.is_playing():
        return

    _animation_player.play(target_animation, custom_blend, custom_speed, from_end)

func _get_configuration_warnings():
    var warnings = super ._get_configuration_warnings()
    warnings.append("This node is deprecated and will be removed in a future version.")

    if animation_player.is_empty():
        warnings.append("No animation player is set.")
    elif get_node_or_null(animation_player) == null:
        warnings.append("The animation player path is invalid.")

    return warnings
