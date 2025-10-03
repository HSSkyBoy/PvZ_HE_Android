class_name MenuDialogBase extends DialogBoxBase

@onready var fullScreenCheckBox: CheckBox = %FullScreenCheckBox
@onready var mobilePresetCheckBox: CheckBox = %MobilePresetCheckBox
@onready var musicSlider: HSlider = %MusicHSlider
@onready var sfxSlider: HSlider = %SfxHSlider
@onready var backButton: TextureButton = %BackButton
@onready var animeFrameRateLabel: Label = %AnimeFrameRateLabel
@onready var animeFrameRateSlider: HSlider = %AnimeFrameRateSlider

@onready var fullScreenLabel: Label = %FullScreenLabel
@onready var mobilePresetLabel: Label = %MobilePresetLabel

func _ready() -> void :
    super._ready()
    animeFrameRateSlider.max_value = Global.maxFps
    animeFrameRateSlider.value = Global.animeFrameRate
    animeFrameRateLabel.text = "动画帧率:%d" % animeFrameRateSlider.value
    animeFrameRateSlider.value_changed.connect(
        func(value: float):
            Global.animeFrameRate = value
            animeFrameRateLabel.text = "动画帧率:%d" % value
            GameSaveManager.SetConfigValue("AnimeFrameRate", Global.animeFrameRate)
    )
    if Global.isMobile:
        fullScreenLabel.visible = false
    AudioManager.AudioPlay("GraveButtonPress", AudioManagerEnum.TYPE.SFX)
    musicSlider.call_deferred("set_value", AudioManager.VolumGet(AudioManagerEnum.TYPE.MUSIC))
    sfxSlider.call_deferred("set_value", AudioManager.VolumGet(AudioManagerEnum.TYPE.SFX))
    fullScreenCheckBox.button_pressed = DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN
    mobilePresetCheckBox.button_pressed = GameSaveManager.GetConfigValue("MobilePreset")

func SliderPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)

@warning_ignore("unused_parameter")
func SfxSliderRelease(_valueChange: bool) -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    if _valueChange:
        GameSaveManager.SetConfigValue("SfxVolum", sfxSlider.value)
        AudioManager.volumChange.emit(AudioManagerEnum.TYPE.SFX)

@warning_ignore("unused_parameter")
func MusicSliderRelease(_valueChange: bool) -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    if _valueChange:
        GameSaveManager.SetConfigValue("MusicVolum", musicSlider.value)
        AudioManager.volumChange.emit(AudioManagerEnum.TYPE.MUSIC)

func MusicValueChanged(value: float) -> void :
    AudioManager.VolumSet(AudioManagerEnum.TYPE.MUSIC, value)

func SFXValueChanged(value: float) -> void :
    AudioManager.VolumSet(AudioManagerEnum.TYPE.SFX, value)


func FullScreenCheckBoxPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    if fullScreenCheckBox.button_pressed:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    GameSaveManager.SetConfigValue("FullScreen", fullScreenCheckBox.button_pressed)

func MobilePresetCheckBoxPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    GameSaveManager.SetConfigValue("MobilePreset", mobilePresetCheckBox.button_pressed)
