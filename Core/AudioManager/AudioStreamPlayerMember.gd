class_name AudioStreamPlayerMember extends AudioStreamPlayer

@export var type: AudioManagerEnum.TYPE = AudioManagerEnum.TYPE.SFX
@export var volumeScale: float = 1.0:
    set(_volumeScale):
        volumeScale = _volumeScale
        VolumRefresh()

func _ready() -> void :
    VolumRefresh()

func VolumChange(_type: AudioManagerEnum.TYPE):
    if _type == type:
        VolumRefresh()

func VolumRefresh() -> void :
    volume_db = -60.0 + AudioManager.audioVolumDictionary[type] * 60.0 * volumeScale
