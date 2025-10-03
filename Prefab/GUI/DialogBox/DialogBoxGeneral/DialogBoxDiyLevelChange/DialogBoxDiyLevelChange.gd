extends DialogPopup

signal play()

func TrueButtonPressed() -> void :
    play.emit()
    Close()

func FalseButtonPressed() -> void :
    Close()
