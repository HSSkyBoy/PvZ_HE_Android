extends Control

@onready var openButton: MainButton = %OpenButton

@onready var guiLayer: CanvasLayer = $GUILayer
@onready var animeFrameRateLabel: Label = %AnimeFrameRateLabel
@onready var animeFrameRateSlider: HSlider = %AnimeFrameRateSlider

@onready var openAllLevelCheckBox: CheckBox = %OpenAllLevelCheckBox
@onready var coinMaxCheckBox: CheckBox = %CoinMaxCheckBox
@onready var sunMaxCheckBox: CheckBox = %SunMaxCheckBox
@onready var packetSelectCheckBox: CheckBox = %PacketSelectCheckBox
@onready var packetOpenAllCheckBox: CheckBox = %PacketOpenAllCheckBox
@onready var packetColdDownCheckBox: CheckBox = %PacketColdDownCheckBox
@onready var openAllCustomCheckBox: CheckBox = %OpenAllCustomCheckBox

@export var debug: bool = false

func _ready() -> void :

    if !debug:
        openButton.visible = false
        process_mode = ProcessMode.PROCESS_MODE_DISABLED
        return
    Init()

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
    if debug && Input.is_action_just_pressed("Command"):
        grab_focus()
        guiLayer.visible = !guiLayer.visible
        get_tree().paused = guiLayer.visible

func Init() -> void :
    animeFrameRateSlider.value = Global.animeFrameRate
    animeFrameRateLabel.text = "动画帧率:%d" % animeFrameRateSlider.value
    animeFrameRateSlider.value_changed.connect(
        func(value: float):
            Global.animeFrameRate = value
            animeFrameRateLabel.text = "动画帧率:%d" % value
    )
    openAllLevelCheckBox.button_pressed = Global.debugOpenAllLevel
    openAllLevelCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugOpenAllLevel = toggle
    )
    coinMaxCheckBox.button_pressed = Global.debugCoinMax
    coinMaxCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugCoinMax = toggle
    )

    sunMaxCheckBox.button_pressed = Global.debugSunMax
    sunMaxCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugSunMax = toggle
    )
    packetSelectCheckBox.button_pressed = Global.debugPacketSelect
    packetSelectCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugPacketSelect = toggle
    )
    packetOpenAllCheckBox.button_pressed = Global.debugPacketOpenAll
    packetOpenAllCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugPacketOpenAll = toggle
    )
    packetColdDownCheckBox.button_pressed = Global.debugPacketColdDown
    packetColdDownCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugPacketColdDown = toggle
    )
    openAllCustomCheckBox.button_pressed = Global.debugOpenAllCustom
    openAllCustomCheckBox.toggled.connect(
        func(toggle: bool):
            Global.debugOpenAllCustom = toggle
    )

func OpenButtonToggled(toggledOn: bool) -> void :
    guiLayer.visible = toggledOn
    get_tree().paused = guiLayer.visible

func TestLevelButtonPressed() -> void :
    TowerDefenseManager.currentLevelConfig = load("uid://bfl6f5wb3lu7m")
    guiLayer.visible = !guiLayer.visible
    get_tree().paused = guiLayer.visible
    Global.enterLevelMode = "LevelChoose"
    SceneManager.ChangeScene("TowerDefense")

func LoadLevelButtonPressed() -> void :
    @warning_ignore("unused_parameter")
    DisplayServer.file_dialog_show("打开关卡文件", "", "", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, ["*.json,*.tres"], 
        func FileOpen(status: bool, selectedPaths: PackedStringArray, selectedFilterIndex: int) -> void :
            if selectedPaths.size() > 0:
                match selectedPaths[0].get_extension():
                    "json":
                        var file = FileAccess.open(selectedPaths[0], FileAccess.READ)
                        var content = file.get_as_text()
                        var json = JSON.new()
                        json.parse(content, true)
                        var config: TowerDefenseLevelConfig = TowerDefenseLevelConfig.new()
                        config.data = json
                        config.Init()
                        json = null
                        TowerDefenseManager.currentLevelConfig = config.duplicate_deep()
                        guiLayer.visible = false
                        get_tree().paused = guiLayer.visible
                        Global.enterLevelMode = "LoadLevel"
                        SceneManager.ChangeScene("TowerDefense")
                        Global.isEditor = false
                    "tres":
                        var res = load(selectedPaths[0])
                        if res is TowerDefenseLevelConfig:
                            TowerDefenseManager.currentLevelConfig = res.duplicate_deep()
                            guiLayer.visible = false
                            get_tree().paused = guiLayer.visible
                            Global.enterLevelMode = "LoadLevel"
                            SceneManager.ChangeScene("TowerDefense")
                            Global.isEditor = false
                        else:
                            BroadCastManager.BroadCastFloatCreate("不是关卡文件", Color.RED)
    )
