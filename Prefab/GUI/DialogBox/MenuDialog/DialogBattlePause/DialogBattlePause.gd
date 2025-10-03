extends MenuDialogBase

@onready var handbookButton: MainButton = %HandbookButton
@onready var restartButton: MainButton = %RestartButton
@onready var mainMenuButton: MainButton = %MainMenuButton

@onready var levelEditorButton: MainButton = %LevelEditorButton

func _ready() -> void :
    super ._ready()
    if Global.isEditor:
        levelEditorButton.visible = true
        handbookButton.visible = false
        mainMenuButton.visible = false

func HandbookButtonPressed() -> void :
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

func RestartButtonPressed() -> void :
    DialogCreate("ReStart")

func MainMenuButtonPressed() -> void :

    SceneManager.ChangeScene("MainMenu")
    Close()

func LevelEditorButtonPressed() -> void :
    SceneManager.ChangeScene("LevelEditorStage")
    Close()
