extends TowerDefenseProjectileEffectBase

var projectileList: Array[TowerDefenseProjectile]

var timer: float = 0.0
var over: bool = false

func _ready() -> void :
    AttackCreate()

func _physics_process(delta: float) -> void :
    var freshList: Array[TowerDefenseProjectile] = []
    for projectile in projectileList:
        if is_instance_valid(projectile) && projectile.is_inside_tree():
            freshList.append(projectile)
    projectileList = freshList

    if over:
        if projectileList.size() <= 0:
            queue_free()
            return

    timer += delta
    var size: int = projectileList.size()
    var firstSize: int = floor(projectileList.size() / 2.0)
    var scondSize: int = size - firstSize
    for i in firstSize:
        var process: float = TAU / firstSize * i + timer * 5.0
        var pos = global_position + Vector2(cos(process) * 30, sin(process) * 30)
        var projectile: TowerDefenseProjectile = projectileList[i]
        projectile.projectileBodyNode.rotation = lerp_angle(projectile.projectileBodyNode.rotation, (pos - projectile.global_position).angle(), 5.0 * delta)
        projectile.global_position = lerp(projectile.global_position, pos, 5.0 * delta)
    for i in scondSize:
        var process: float = TAU / scondSize * i + timer
        var pos = global_position + Vector2(cos(process) * 60, sin(process) * 60)
        var projectile: TowerDefenseProjectile = projectileList[firstSize + i]
        projectile.projectileBodyNode.rotation = lerp_angle(projectile.projectileBodyNode.rotation, (pos - projectile.global_position).angle(), 5.0 * delta)
        projectile.global_position = lerp(projectile.global_position, pos, 5.0 * delta)

func AttackCreate() -> void :
    for i in 10:
        for j in 6:
            var dir = 0
            var projectileName = "PeaDefault"
            match j:
                0:
                    dir = 60
                    projectileName = "PeaDefault"
                1:
                    dir = 0
                    projectileName = "FirePea"
                2:
                    dir = -60
                    projectileName = "SnowPea"
                3:
                    dir = 120
                    projectileName = "PeaDefault"
                4:
                    dir = 180
                    projectileName = "FirePea"
                5:
                    dir = 240
                    projectileName = "SnowPea"
            var projectile = FireComponent.CreateProjectilePosition(null, null, 30.0, global_position, Vector2.ZERO, projectileName, -1, camp)
            projectile.checkAll = true
            projectile.gridPos = gridPos
            projectile.tree_exited.connect(
                func():
                    projectileList.erase(projectile)
            )
            projectile.get_tree().create_timer(2.0, false).timeout.connect(
                func():
                    projectileList.erase(projectile)
                    projectile.moveTween = projectile.create_tween()
                    projectile.moveTween.set_ease(Tween.EASE_OUT)
                    projectile.moveTween.set_trans(Tween.TRANS_QUART)
                    projectile.moveTween.set_parallel(true)
                    projectile.moveTween.tween_property(projectile, ^"global_position", global_position, 0.1)
                    projectile.moveTween.tween_property(projectile.projectileBodyNode, ^"rotation", deg_to_rad(dir), 0.1)
                    projectile.velocity = Vector2.from_angle(deg_to_rad(dir)) * 300.0
            )
            projectileList.append(projectile)
        await get_tree().create_timer(0.1).timeout

    over = true
