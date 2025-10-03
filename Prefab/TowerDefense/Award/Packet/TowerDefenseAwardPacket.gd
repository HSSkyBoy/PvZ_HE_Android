extends TowerDefenseAwardBase

@onready var packet: TowerDefenseInGamePacketShow = %Packet

func Init(packetName: String) -> void :
    var packetConfig: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName)
    packet.Init(packetConfig)
    packet.sprite.pause = true

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
    await tween.finished
    tween = create_tween()
    tween.tween_property(packet, ^"modulate:a", 0.0, 2.0)
    await tween.finished
    SceneManager.ChangeScene("AwardSettlement", true)
