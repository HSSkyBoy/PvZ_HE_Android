class_name TowerDefenseCharacterEventBowlingHurt extends TowerDefenseCharacterEventBase

@export var num: float = 1800.0
@export_enum("Front", "Back") var dir: String = "Front"
@export var burns: bool = true

@warning_ignore("unused_parameter")
func Execute(pos: Vector2, target: TowerDefenseCharacter) -> void :
    Run(pos, target, num, dir)

@warning_ignore("unused_parameter")
func ExecuteDps(pos: Vector2, target: TowerDefenseCharacter, delta: float) -> void :
    Run(pos, target, num * delta, dir)

func ExecuteProject(projectile: TowerDefenseProjectile, target: TowerDefenseCharacter) -> void :
    Run(projectile.global_position, target, num)

static func Run(pos: Vector2, target: TowerDefenseCharacter, _num: float = 1800.0, _dir: String = "Front") -> void :
    var velocity = Vector2((target.global_position.x - pos.x) * randf_range(3.0, 6.0), -200)
    var isSide: bool = false
    var hasShield: bool = false
    if pos.y > target.global_position.y + 5 || pos.y < target.global_position.y - 20:
        isSide = true
    if !isSide:
        if target.HasShield():
            if target.config.name == "ZombiePaper":
                _num = 150
            else:
                _num *= 2.0 / 9.0
            hasShield = true
        elif target.HasHelm():
            _num *= 2.0 / 9.0
    else:
        if target.HasHelm():
            _num *= 2.0 / 9.0
    var __dir: float = 1.0
    if _dir == "Back":
        __dir = -1.0
    if hasShield || (target is TowerDefenseZombie && target.instance.zombiePhysique == TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE):
        var tween = target.create_tween()
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_QUINT)
        tween.tween_property(target, ^"global_position:x", target.global_position.x + 50.0 * __dir, 0.4)
    var finalNum: float = target.Hurt(_num, true, velocity)
    if finalNum > 0:
        var tween = target.create_tween()
        tween.set_ease(Tween.EASE_OUT)
        tween.set_trans(Tween.TRANS_QUINT)
        tween.tween_property(target, ^"global_position:x", target.global_position.x + 100.0 * __dir, 0.4)
