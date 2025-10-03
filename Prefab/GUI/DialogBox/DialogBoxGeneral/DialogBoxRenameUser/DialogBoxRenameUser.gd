extends DialogPopup

@onready var nameLineEdit = %NameLineEdit
@onready var readyButton = %ReadyButton
@onready var cancelButton = %CancelButton

var changeUser: String = "":
    set(_changeUser):
        changeUser = _changeUser
        nameLineEdit.text = changeUser

func _ready() -> void :
    super._ready()

func ReadyButtonPressed() -> void :
    var user: String = nameLineEdit.text
    if user.length() > 0:
        if !GameSaveManager.HasUser(user):
            GameSaveManager.RenameUser(changeUser, user)
            GameSaveManager.SetUserCurrent(user)
            Close()

func CancelButtonPressed() -> void :
    Close()
