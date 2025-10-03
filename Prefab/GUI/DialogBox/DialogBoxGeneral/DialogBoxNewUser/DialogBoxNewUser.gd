extends DialogPopup

@onready var nameLineEdit = %NameLineEdit
@onready var readyButton = %ReadyButton
@onready var cancelButton = %CancelButton
@onready var readyButtonNewUser = %ReadyButtonNewUser

func _ready() -> void :
    super._ready()
    if GameSaveManager.GetUserCurrent() == "":
        readyButton.visible = false
        cancelButton.visible = false
        readyButtonNewUser.visible = true

func ReadyButtonPressed() -> void :
    var user: String = nameLineEdit.text
    if user.length() > 0:
        if !GameSaveManager.HasUser(user):
            GameSaveManager.AddUser(user)
            GameSaveManager.SetUserCurrent(user)
            GameSaveManager.Save()
            Close()

func CancelButtonPressed() -> void :
    Close()

func ReadyButtonNewUserPressed() -> void :
    var user = nameLineEdit.text
    if user.length() > 0:
        if !GameSaveManager.HasUser(user):
            GameSaveManager.AddUser(user)
            GameSaveManager.SetUserCurrent(user)
            GameSaveManager.Save()
            Close()
