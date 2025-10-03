extends DialogPopup

var uri: String = ""

func TrueButtonPressed() -> void :
    OS.shell_open(uri)
    Close()

func FalseButtonPressed() -> void :
    Close()
