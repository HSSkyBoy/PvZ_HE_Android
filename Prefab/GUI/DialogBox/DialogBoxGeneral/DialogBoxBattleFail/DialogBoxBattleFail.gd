extends DialogPopup

@onready var restartButton = %RestartButton
@onready var backButton = %BackButton

func RestartButtonPressed() -> void :
    SceneManager.ReloadScene()
    Close()

func BackButtonPressed() -> void :
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
    Close()
