class_name ChangeProjectileComponent extends ComponentBase

@export var projectileConfig: ChangeProjectileConfig
@export var checkArea: Area2D

var parent: TowerDefenseCharacter

var timer: float = 0.0

func _ready():
    parent = get_parent()
    checkArea.area_entered.connect(ChangeProjectile)







func ChangeProjectile(area: Area2D):
    if !alive:
        return
    if parent.die || parent.nearDie:
        return
    var projectile = area.get_parent()
    if projectile is TowerDefenseProjectile:
        for checkProjectile: ChangeProjectileSingleConfig in projectileConfig.changeList:
            if checkProjectile.projectileName == projectile.config.name:
                if projectile.camp == parent.camp:
                    if (projectile.checkAll || projectile.gridPos.y == parent.gridPos.y):
                        projectile.Change(checkProjectile.projectileConfig)
                        if checkProjectile.changeAudio:
                            AudioManager.AudioPlay(checkProjectile.changeAudio, AudioManagerEnum.TYPE.SFX)
                        return
