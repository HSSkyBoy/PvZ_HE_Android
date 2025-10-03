extends TowerDefenseAwardBase
const TOWER_DEFENSE_COIN_GOLD = preload("uid://kbif4idtgolo")
const TOWER_DEFENSE_COIN_SILVER = preload("uid://csynbfevdbiju")
var num: int = 250

func Init(value: String) -> void :
    num = value.to_int()

func Pressed() -> void :
    if press:
        return
    press = true
    CreateCoin()
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
    await tween.finished
    Global.currentAwardMode = true
    match Global.enterLevelMode:
        "LevelChoose":
            SceneManager.ChangeScene("LevelChoose")
        "DailyLevel":
            SceneManager.ChangeScene("MainMenu")
        "DiyLevel":
            SceneManager.ChangeScene("LevelEditorStage")
        "LoadLevel":
            SceneManager.ChangeScene("LevelEditorStage")
        "OnlineLevel":
            SceneManager.ChangeScene("LevelEditorStage")

func CreateCoin() -> void :
    while num >= 1000:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_DIAMOND, global_position - Vector2(0, 40), 120, Vector2(randf_range(-100.0, 100.0), -400.0), 980.0)
        item.gridPos.y = 200
        get_tree().create_timer(1.0, false).timeout.connect(item.moveComponent.MoveClear)
        get_tree().create_timer(1.5, false).timeout.connect(item.Collection)
        num -= 1000
        await get_tree().create_timer(0.1, false).timeout
    while num >= 50:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_GOLD, global_position - Vector2(0, 40), 120, Vector2(randf_range(-100.0, 100.0), -400.0), 980.0)
        item.gridPos.y = 200
        get_tree().create_timer(1.0, false).timeout.connect(item.moveComponent.MoveClear)
        get_tree().create_timer(1.5, false).timeout.connect(item.Collection)
        num -= 50
        await get_tree().create_timer(0.1, false).timeout
    while num >= 10:
        var item = TowerDefenseManager.FallingObjectItemCreate(ObjectManagerConfig.OBJECT.COIN_SILVER, global_position - Vector2(0, 40), 120, Vector2(randf_range(-100.0, 100.0), -400.0), 980.0)
        item.gridPos.y = 200
        get_tree().create_timer(1.0, false).timeout.connect(item.moveComponent.MoveClear)
        get_tree().create_timer(1.5, false).timeout.connect(item.Collection)
        num -= 10
        await get_tree().create_timer(0.1, false).timeout
