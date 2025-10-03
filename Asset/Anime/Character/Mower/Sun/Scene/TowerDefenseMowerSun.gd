@tool
extends TowerDefenseMower

func InWater() -> void :
    super.InWater()
    CreateSplash()
    Destroy()
