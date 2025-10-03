extends DialogPopup

signal pressDelete()

func TrueButtonPressed() -> void :
    pressDelete.emit()
    Close()

func FalseButtonPressed() -> void :
    Close()
