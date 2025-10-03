extends DialogPopup

func TrueButtonPressed() -> void :
    GameSaveManager.Save()
    get_tree().quit()

func FalseButtonPressed() -> void :
    Close()
