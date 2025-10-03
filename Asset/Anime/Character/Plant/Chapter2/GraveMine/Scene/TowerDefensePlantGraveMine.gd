@tool
extends TowerDefensePlant

var cell: TowerDefenseCellInstance
var graveStone: TowerDefenseGravestone

var tween: Tween

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    super._ready()
    if !inGame:
        return
    cell = TowerDefenseManager.GetMapCell(gridPos)
    await get_tree().physics_frame
    graveStone = cell.FindSlotParent(self)

func IdleEntered() -> void :
    if !inGame:
        return
    sprite.SetAnimation("Land", false, 0.2)
    sprite.AddAnimation("Idle", 0.0, true, 0.2)
    sprite.position.y = -70

@warning_ignore("unused_parameter")
func IdleProcessing(delta: float) -> void :
    super.IdleProcessing(delta)
    sprite.timeScale = timeScale

func AnimeCompleted(clip: String) -> void :
    super.AnimeCompleted(clip)
    match clip:
        "Land":
            AudioManager.AudioPlay("GraveBusterChomp", AudioManagerEnum.TYPE.SFX)
            tween = create_tween()
            tween.set_parallel(true)
            tween.tween_property(sprite, ^"position:y", -30, 5.0)
            tween.tween_property(graveStone.spriteGroup.material, ^"shader_parameter/surfaceUpPos", 0.7, 5.0)
            await tween.finished
            var sunMinePacket: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig("PlantSunMine")
            if GameSaveManager.GetFeatureValue("Coins"):
                var item = TowerDefenseManager.FallingObjectCreate(global_position, GetGroundHeight(global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                if item:
                    item.gridPos = gridPos
            if is_instance_valid(graveStone):
                graveStone.Destroy()
            await get_tree().physics_frame
            if cell.CanPacketPlant(sunMinePacket):
                var sunMine = sunMinePacket.Plant(gridPos)
                await get_tree().physics_frame
                sunMine.ReadyRise()
            Destroy()

func Destroy(freeInsance: bool = true) -> void :
    if is_instance_valid(graveStone):
        if is_instance_valid(tween):
            tween.kill()
        await get_tree().physics_frame
        if is_instance_valid(graveStone):
            graveStone.SetSpriteGroupShaderParameter("surfaceUpPos", 0.0)
    super.Destroy(freeInsance)
