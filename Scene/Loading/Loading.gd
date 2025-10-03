extends Control

@onready var loadLabel: Label = %LoadLabel
@onready var offlineButton: MainButton = %OfflineButton
@onready var progressBar: TextureProgressBar = %ProgressBar
@onready var startButton: Button = %StartButton
@onready var sodRollCap: Sprite2D = %SodRollCap

@onready var loadBarSprout: AdobeAnimateSpriteBase = %LoadBarSprout
@onready var loadBarSprout2: AdobeAnimateSpriteBase = %LoadBarSprout2
@onready var loadBarSprout3: AdobeAnimateSpriteBase = %LoadBarSprout3
@onready var loadBarSprout4: AdobeAnimateSpriteBase = %LoadBarSprout4
@onready var loadBarZombieHead: AdobeAnimateSpriteBase = %LoadBarZombieHead

var percentage: float = 0.0

var isStart: bool = false

func _ready() -> void :
	GameSaveManager.Load()
	ResourceManager.loadPercentage.connect(SetPercentage)
	ResourceManager.loadOver.connect(LoadOver)
	loadBarSprout.pause = true
	loadBarSprout.SetAnimation("Idle", false)
	loadBarSprout2.pause = true
	loadBarSprout2.SetAnimation("Idle", false)
	loadBarSprout3.pause = true
	loadBarSprout3.SetAnimation("Idle", false)
	loadBarSprout4.pause = true
	loadBarSprout4.SetAnimation("Idle", false)
	loadBarZombieHead.pause = true
	loadBarZombieHead.SetAnimation("Idle", false)

func _physics_process(delta: float) -> void :
	if progressBar.value >= 0.95:
		sodRollCap.visible = false
		progressBar.value = percentage
	if progressBar.value < percentage:
		if loadBarSprout.pause:
			if progressBar.value >= 0.15:
				AudioManager.AudioPlay("LoadingBarFlower", AudioManagerEnum.TYPE.SFX)
				loadBarSprout.pause = false
		if loadBarSprout2.pause:
			if progressBar.value >= 0.3:
				AudioManager.AudioPlay("LoadingBarFlower", AudioManagerEnum.TYPE.SFX)
				loadBarSprout2.pause = false
		if loadBarSprout3.pause:
			if progressBar.value >= 0.4:
				AudioManager.AudioPlay("LoadingBarFlower", AudioManagerEnum.TYPE.SFX)
				loadBarSprout3.pause = false
		if loadBarSprout4.pause:
			if progressBar.value >= 0.6:
				AudioManager.AudioPlay("LoadingBarFlower", AudioManagerEnum.TYPE.SFX)
				loadBarSprout4.pause = false
		if loadBarZombieHead.pause:
			if progressBar.value >= 0.8:
				AudioManager.AudioPlay("LoadingBarFlower", AudioManagerEnum.TYPE.SFX)
				AudioManager.AudioPlay("LoadingBarZombie", AudioManagerEnum.TYPE.SFX)
				loadBarZombieHead.pause = false
		progressBar.value = lerpf(progressBar.value, percentage, (progressBar.value * 2.0 + 0.5) * delta)
		sodRollCap.position.x = progressBar.value / 1.0 * 315.0
		sodRollCap.position.y = -26.0 + progressBar.value / 1.0 * (40.0 * 0.75)
		sodRollCap.rotation = 2 * TAU * progressBar.value / 1.0
		sodRollCap.scale = Vector2.ONE * (1.0 - progressBar.value / 1.0 * 0.75)

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
	if !isStart:
		if !loadLabel.visible:
			if Input.is_action_just_pressed("Press"):
				AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
				OfflineButtonPressed()

func OnlineButtonPressed() -> void :
	await DialogManager.DialogCreate("Login").close
	if MultiPlayerManager.IsConnect():
		isStart = true
		GameSaveManager.Load()
		SceneManager.ChangeScene("MainMenu", false)

func OfflineButtonPressed() -> void :
	isStart = true
	GameSaveManager.Load()
	SceneManager.ChangeScene("MainMenu", false)

func SetPercentage(_percentage: float, stepName: String) -> void :
	percentage = _percentage
	loadLabel.text = stepName
	if stepName == "LOAD_CHARACTER":
		AudioManager.AudioPlay("MainMenu", AudioManagerEnum.TYPE.MUSIC)

func LoadOver() -> void :
	startButton.disabled = false
	startButton.text = "点击开始"

	loadLabel.visible = false
