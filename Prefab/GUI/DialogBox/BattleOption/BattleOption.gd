extends DialogBoxBase

@onready var plantHealthCheckBox: CheckBox = %PlantHealthCheckBox
@onready var zombieHealthCheckBox: CheckBox = %ZombieHealthCheckBox
@onready var packetUIFrontCheckBox: CheckBox = %PacketUIFrontCheckBox
@onready var mapEffectCheckBox: CheckBox = %MapEffectCheckBox
@onready var backgrounderCheckBox: CheckBox = %BackgrounderCheckBox

func _ready() -> void :
    super._ready()
    plantHealthCheckBox.button_pressed = GameSaveManager.GetConfigValue("ShowPlantHealth")
    zombieHealthCheckBox.button_pressed = GameSaveManager.GetConfigValue("ShowZombieHealth")
    packetUIFrontCheckBox.button_pressed = GameSaveManager.GetConfigValue("PacketUIFront")
    mapEffectCheckBox.button_pressed = GameSaveManager.GetConfigValue("MapEffect")
    backgrounderCheckBox.button_pressed = GameSaveManager.GetConfigValue("Backgrounder")

func PlantHealthCheckBoxToggled(toggledOn: bool) -> void :
    GameSaveManager.SetConfigValue("ShowPlantHealth", toggledOn)
    GameSaveManager.SaveGameConfig()

func ZombieHealthCheckBoxToggled(toggledOn: bool) -> void :
    GameSaveManager.SetConfigValue("ShowZombieHealth", toggledOn)
    GameSaveManager.SaveGameConfig()

func PacketUIFrontCheckBoxToggled(toggledOn: bool) -> void :
    GameSaveManager.SetConfigValue("PacketUIFront", toggledOn)
    GameSaveManager.SaveGameConfig()

func MapEffectCheckBoxToggled(toggledOn: bool) -> void :
    GameSaveManager.SetConfigValue("MapEffect", toggledOn)
    GameSaveManager.SaveGameConfig()

func BackgrounderCheckBoxToggled(toggledOn: bool) -> void :
    GameSaveManager.SetConfigValue("Backgrounder", toggledOn)
    GameSaveManager.SaveGameConfig()

func BackButtonPressed() -> void :
    Close()
