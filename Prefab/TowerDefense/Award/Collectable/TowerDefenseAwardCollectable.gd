extends TowerDefenseAwardBase

@onready var sprite: Sprite2D = %Sprite

func Init(collectableName: String) -> void :
    var collectableConfig: CollectableConfig = TowerDefenseManager.GetCollectable(collectableName)
    if collectableConfig.config is ShovelConfig:
        sprite.texture = collectableConfig.config.texture
        sprite.scale = Vector2.ONE * 80.0 / sprite.texture.get_width()
        var shovelName: String = GameSaveManager.GetKeyValue("CurrentShovel")
        if shovelName == "ShovelDefault":
            GameSaveManager.SetKeyValue("CurrentShovel", collectableName)
    if collectableConfig.config is AwardSettlementConfig:
        sprite.texture = collectableConfig.config.texture

func Pressed() -> void :
    if press:
        return
    press = true
    AudioManager.AudioStopAll()
    AudioManager.AudioPlay("Win", AudioManagerEnum.TYPE.MUSIC)
    AudioManager.AudioPlay("AwardLightFill", AudioManagerEnum.TYPE.MUSIC)
    awardPickupGlow.visible = false
    downArrow.visible = false
    awardRay.Emit()
    var camera = get_viewport().get_camera_2d() as Camera2D
    var posTo = camera.get_screen_center_position()
    var tween = create_tween()
    tween.set_parallel(true)
    tween.set_ease(Tween.EASE_OUT)
    tween.set_trans(Tween.TRANS_QUART)
    tween.tween_property(self, ^"global_position", posTo, 5.0)
    tween.tween_property(self, ^"scale", Vector2.ONE * 2.0, 7.0)
    tween.set_parallel(false)
    tween.tween_property(sprite, ^"modulate:a", 0.0, 2.0)
    await tween.finished
    SceneManager.ChangeScene("AwardSettlement", true)
