extends DialogPopup

var deleteUser: String

func TrueButtonPressed() -> void :
    GameSaveManager.DeleteUser(deleteUser)
    Close()

func FalseButtonPressed() -> void :
    Close()
