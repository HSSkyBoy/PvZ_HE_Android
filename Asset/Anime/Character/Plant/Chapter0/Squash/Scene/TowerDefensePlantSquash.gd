@tool
extends TowerDefensePlant

@onready var attackComponent: AttackComponent = %AttackComponent

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

var savePos: Vector2

var over: bool = false

func _ready() -> void :
    super ._ready()
    if Engine.is_editor_hint():
        return
    instance.invincible = true
    await get_tree().physics_frame
    instance.invincible = false

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale
    if attackComponent.CanAttack():
        state.send_event("ToReady")

func ReadyEntered() -> void :
    AudioManager.AudioPlay("SquasHmm", AudioManagerEnum.TYPE.SFX)
    instance.invincible = true
    savePos = attackComponent.target.global_position
    if savePos < global_position:
        sprite.SetAnimation("LookLeft", false, 0.2)

    else:
        sprite.SetAnimation("LookRight", false, 0.2)


@warning_ignore("unused_parameter")
func ReadyProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 2.0

func ReadyExited() -> void :
    pass

func JumpEntered() -> void :
    destroy.emit(self)
    instance.maskFlags = 0
    itemLayer = TowerDefenseEnum.LAYER_GROUNDITEM.PROJECTILE
    gravity = 0.0
    sprite.SetAnimation("JumpUp", false, 0.2)
    await get_tree().create_timer(0.3, false).timeout
    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(self, ^"z", 120.0, 0.4)
    tween.tween_property(self, ^"global_position:x", savePos.x, 0.4)

@warning_ignore("unused_parameter")
func JumpProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 3.0

func JumpExited() -> void :
    pass

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "JumpUp":
            await get_tree().create_timer(0.4, false).timeout
            sprite.SetAnimation("JumpDown", false, 0.2)
            var tween = create_tween()
            tween.set_ease(Tween.EASE_OUT)
            tween.set_trans(Tween.TRANS_EXPO)
            tween.tween_property(self, ^"z", 0.0, 0.1)
        "JumpDown":
            if over:
                return
            over = true
            AudioManager.AudioPlay("GargantuarThump", AudioManagerEnum.TYPE.SFX)
            ViewManager.CameraShake(Vector2(randf_range(-1, 1), randf_range(-1, 1)), 5.0, 0.05, 4)
            TowerDefenseExplode.CreateExplode(global_position, Vector2(0.625, 0.2), eventList, [], camp, instance.collisionFlags)
            if is_instance_valid(cell):
                if cell.IsWater():
                    CreateSplash()
                    queue_free()
                    return
            await get_tree().create_timer(0.5, false).timeout
            queue_free()
        "LookLeft":
            await get_tree().create_timer(0.5, false).timeout
            state.send_event("ToJump")
        "LookRight":
            await get_tree().create_timer(0.5, false).timeout
            state.send_event("ToJump")
