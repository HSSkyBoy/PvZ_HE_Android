@tool
extends TowerDefensePlant

@onready var light: PointLight2D = %Light

func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    super._physics_process(delta)
    light.visible = TowerDefenseManager.GetMapIsNight() && GameSaveManager.GetConfigValue("MapEffect")

func DamagePointReach(damangePointName: String) -> void :
    super.DamagePointReach(damangePointName)
    match damangePointName:
        "Damage2":
            if currentCustom.has("Custom0"):
                sprite.SetFliter("skin2_4", true)
