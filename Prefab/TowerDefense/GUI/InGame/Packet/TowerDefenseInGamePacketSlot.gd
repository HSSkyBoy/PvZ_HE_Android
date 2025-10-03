extends Control
@onready var textureRect: TextureRect = $TextureRect
const PACKET_SILHOUETTE_MOBILE = preload("uid://celgn60f027kl")
func _ready() -> void :
    if GameSaveManager.GetConfigValue("MobilePreset") && SceneManager.currentScene != "LevelEditorStage":
        textureRect.texture = PACKET_SILHOUETTE_MOBILE
        textureRect.size = Vector2(96, 60)
        textureRect.position = Vector2(-48, -30)
        textureRect.modulate.a = 0.5
