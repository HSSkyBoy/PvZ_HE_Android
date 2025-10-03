extends DialogPopup

@onready var nameLineEdit: LineEdit = %NameLineEdit
@onready var emailLineEdit: LineEdit = %EmailLineEdit
@onready var passwordLineEdit: LineEdit = %PasswordLineEdit
@onready var passwordLineEdit2: LineEdit = %PasswordLineEdit2

func _ready() -> void :
    super._ready()

func RegistButtonPressed() -> void :
    if passwordLineEdit.text != passwordLineEdit2.text:
        BroadCastManager.BroadCastFloatCreate("REGIST_ERROR_PASSWORD_NOT_SAME", Color.RED)
        return
    if passwordLineEdit.text.length() < 8:
        BroadCastManager.BroadCastFloatCreate("REGIST_ERROR_PASSWORD_LESS_THAN_EIGHT", Color.RED)
        return
    var regist: bool = await MultiPlayerManager.Regist(emailLineEdit.text, passwordLineEdit.text, nameLineEdit.text)
    if regist:
        Close()

func CancelButtonPressed() -> void :
    Close()
