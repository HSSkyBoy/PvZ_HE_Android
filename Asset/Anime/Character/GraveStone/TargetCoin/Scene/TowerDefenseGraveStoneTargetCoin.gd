@tool
extends TowerDefenseGravestone

func DestroySet() -> void :
    if (Global.isEditor && Global.enterLevelMode == "DiyLevel") || Global.enterLevelMode == "LoadLevel":
        return
    if randf() > 0.0025:
        if randf() > 0.5:
            var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_GOLD, global_position, GetGroundHeight(global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
            item.gridPos = gridPos
        else:
            for i in 5:
                var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_SILVER, global_position, GetGroundHeight(global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
                item.gridPos = gridPos
    else:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_DIAMOND, global_position, GetGroundHeight(global_position.y), Vector2(randf_range(-50.0, 50.0), -400.0), 980.0)
        item.gridPos = gridPos
