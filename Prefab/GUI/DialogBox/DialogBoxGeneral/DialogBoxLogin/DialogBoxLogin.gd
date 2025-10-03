extends DialogPopup

@onready var emailLineEdit: LineEdit = %EmailLineEdit
@onready var passwordLineEdit: LineEdit = %PasswordLineEdit

func LoginButtonPressed() -> void :
    if emailLineEdit.text == "":
        BroadCastManager.BroadCastFloatCreate("LOGIN_ERROR_EMAIL_EMPTY", Color.RED)
        return
    if passwordLineEdit.text == "":
        BroadCastManager.BroadCastFloatCreate("LOGIN_ERROR_PASSWORD_EMPTY", Color.RED)
        return
    var login: bool = await MultiPlayerManager.Login(emailLineEdit.text, passwordLineEdit.text)
    if login:
        Close()

func RegistButtonPressed() -> void :
    await DialogCreate("Regist").close
    if MultiPlayerManager.IsConnect():
        Close()

func CancleButtonPressed() -> void :
    Close()
