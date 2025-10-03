extends DialogPopup

func TrueButtonPressed() -> void :
    Close()

func FalseButtonPressed() -> void :
    SceneManager.ChangeScene("MainMenu")
    Close()
