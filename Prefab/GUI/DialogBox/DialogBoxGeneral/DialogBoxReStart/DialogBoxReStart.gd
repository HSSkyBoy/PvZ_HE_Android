extends DialogPopup

func TrueButtonPressed() -> void :
    SceneManager.ReloadScene(true)
    Close()

func FalseButtonPressed() -> void :
    Close()
