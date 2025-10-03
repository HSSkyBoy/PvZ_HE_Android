@tool
extends TowerDefensePlant

const SUN_BOMB_EXPLOSION = preload("uid://b73i0bacl5jnh")

@export var eventList: Array[TowerDefenseCharacterEventBase] = []

func IdleEntered() -> void :
    if !inGame:
        return
    if !TowerDefenseManager.currentControl.isGameRunning:
        return
    sprite.SetAnimation("Blow", false, 0.2)
    sprite.AddAnimation("Loop", 0.0, true, 0.2)
    instance.invincible = true

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super .IdleProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func AnimeEvent(command: String, argument: Variant) -> void :
    super .AnimeEvent(command, argument)
    match command:
        "blow":
            var targetList = TowerDefenseManager.GetCharacterTarget(self, false, false)
            for target: TowerDefenseCharacter in targetList:
                if target is TowerDefenseZombie:
                    if target.instance.zombiePhysique >= TowerDefenseEnum.ZOMBIE_PHYSIQUE.HUGE:
                        continue
                if target.instance.unUseBuffFlags == TowerDefenseEnum.CHARACTER_BUFF_FLAGS.ALL:
                    continue
                if target is TowerDefensePlant || target is TowerDefenseGravestone || target is TowerDefenseItem:
                    continue
                if target.instance.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_GROUND:
                    continue
                if target.instance.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.UNDER_WATER:
                    continue
                if target.instance.collisionFlags != 0:
                    target.BlowBack(0.5, 2.0)
                if target.instance.collisionFlags & TowerDefenseEnum.CHARACTER_COLLISION_FLAGS.OFF_GROUND_CHARACTRE:
                    target.Blow()
            AudioManager.AudioPlay("Blover", AudioManagerEnum.TYPE.SFX)
            var height: float = GetGroundHeight(self.global_position.y)
            for id in range(20):
                for line in range(1, TowerDefenseManager.GetMapGridNum().y + 1):
                    var pos: Vector2 = Vector2(-50, TowerDefenseManager.GetMapCellPlantPos(Vector2(0, line)).y)
                    var heightOffset: float = randf_range(-10, 40) + 20
                    var projectile: TowerDefenseProjectile = FireComponent.CreateProjectilePosition(null, null, height + heightOffset, pos + Vector2(0, 20), Vector2(randf_range(400.0, 800.0), 0.0), "SpikeFull", -1, camp)
                    projectile.gridPos.y = line
                await get_tree().create_timer(0.1, false).timeout
            Destroy()
