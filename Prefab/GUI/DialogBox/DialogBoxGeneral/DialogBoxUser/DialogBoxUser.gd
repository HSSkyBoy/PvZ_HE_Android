extends DialogPopup

const userItemScene = preload("uid://xo7n1bu85swf")
const userButtonGroup = preload("uid://dge7tb6et4lw7")

@onready var userContainer: VBoxContainer = %UserContainer
@onready var renameButton: MainButton = %RenameButton
@onready var finishButton: MainButton = %FinishButton
@onready var deleteButton: MainButton = %DeleteButton
@onready var cancelButton: MainButton = %CancelButton
@onready var createUserButton: Button = %CreateUserButton
@onready var logOutButton: MainButton = %LogOutButton
@onready var backButton: MainButton = %BackButton

var editUser: String = ""
func _ready() -> void :
    super._ready()
    RefreshUser()



func RefreshUser():
    for node in userContainer.get_children():
        node.queue_free()

    for user in GameSaveManager.GetUserList():
        UserItemCreate(user)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    deleteButton.disabled = GameSaveManager.GetUserList().size() <= 1

func UserItemCreate(user: String):
    var userItem = userItemScene.instantiate() as UserItem
    if GameSaveManager.GetUserCurrent() == user:
        editUser = user
        userItem.button_pressed = true
    userItem.text = user
    userItem.choose.connect(UserChange)
    userItem.button_group = userButtonGroup
    userContainer.add_child(userItem)

func UserChange(user: String) -> void :
    editUser = user

func RenameButtonPressed() -> void :
    var dialog = DialogCreate("RenameUser")
    dialog.changeUser = editUser
    dialog.close.connect(RenameDialogClose)

func RenameDialogClose() -> void :
    RefreshUser()

func FinishButtonPressed() -> void :
    GameSaveManager.SetUserCurrent(editUser)
    GameSaveManager.Save()
    Close()

func DeleteButtonPressed() -> void :
    var dialog = DialogCreate("DeleteUser")
    dialog.deleteUser = editUser
    dialog.close.connect(DeleteDialogClose)

func DeleteDialogClose() -> void :
    if !GameSaveManager.HasUser(editUser):
        userContainer.get_children()[0].button_pressed = true
        editUser = userContainer.get_children()[0].text
        RefreshUser()

func CancelButtonPressed() -> void :
    Close()

func CreateUserButtonPressed() -> void :
    var dialog = DialogCreate("NewUser")
    dialog.close.connect(CreateUserDialogClose)

func CreateUserDialogClose() -> void :
    RefreshUser()
    editUser = GameSaveManager.GetUserCurrent()

func LogOutButtonPressed() -> void :
    MultiPlayerManager.LogOut()
    SceneManager.ChangeScene("Loading", true)
    Close()

func BackButtonPressed() -> void :
    SceneManager.ChangeScene("Loading", true)
    Close()
