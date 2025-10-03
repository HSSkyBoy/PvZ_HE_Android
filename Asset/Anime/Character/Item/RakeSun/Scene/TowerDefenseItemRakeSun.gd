@tool
extends TowerDefenseItem

@onready var attackComponent: AttackComponent = %AttackComponent

var over: bool = false

func _ready() -> void :
    super._ready()
    HitBoxDestroy()

func IdleEntered() -> void :
    sprite.SetAnimation("Idle", false, 0.2)
    sprite.pause = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    sprite.timeScale = timeScale
    if !over:
        if attackComponent.CanAttack():
            AudioManager.AudioPlay("Bonk", AudioManagerEnum.TYPE.SFX)
            sprite.pause = false
            over = true

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Idle":
            attackComponent.Attack(10000)
            SunCreate(global_position, 50, TowerDefenseEnum.SUN_MOVING_METHOD.GRAVITY, Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
            await get_tree().create_timer(0.5, false).timeout
            Destroy()
