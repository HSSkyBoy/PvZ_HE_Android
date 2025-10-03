extends DialogBoxBase

const SHOP_ITEM = preload("res://Prefab/GUI/DialogBox/Shop/ShopItem/ShopItem.tscn")

@onready var itemNode: Control = %ItemNode
@onready var pageLabel: Label = %PageLabel

@onready var npcWeiWeiMi: NpcBase = %NpcWeiWeiMi
@onready var animationPlayer: AnimationPlayer = %AnimationPlayer


const IdleNpcTalk: Array[String] = [
    "SHOP_NPC_TALK_IDLE_1", 
    "SHOP_NPC_TALK_IDLE_2", 
    "SHOP_NPC_TALK_IDLE_3", 
    "SHOP_NPC_TALK_IDLE_4", 
]

const itemPos: Array[Vector2] = [
    Vector2(270, 120), 
    Vector2(345, 120), 
    Vector2(420, 120), 
    Vector2(495, 120), 
    Vector2(230, 233), 
    Vector2(305, 233), 
    Vector2(380, 233), 
    Vector2(455, 233), 
]

var config: ShopConfig

var pageNum: int = 1:
    set(_pageNum):
        pageNum = _pageNum
        PageLabelFresh()
var currentPage: int = 0:
    set(_currentPage):
        currentPage = _currentPage
        PageLabelFresh()

var talkTimer: float = 0.0
var talkInterval: float = 20.0
func _ready() -> void :
    super._ready()
    TowerDefenseManager.coinBank.Show(Vector2(900, 557), true)
    config = ResourceManager.SHOPS["WWMShop"]
    config.Init()
    pageNum = config.pageList.size()
    PageFresh()

func _physics_process(delta: float) -> void :
    talkTimer -= delta
    if talkTimer <= 0.0:
        NpcTalk(IdleNpcTalk.pick_random())
        talkTimer = talkInterval

func PageLabelFresh() -> void :
    pageLabel.text = "第%d页，共%d页" % [currentPage + 1, pageNum]

func PageFresh() -> void :
    for node in itemNode.get_children():
        node.queue_free()
    animationPlayer.play("PageChange")
    AudioManager.AudioPlay("ShopClose", AudioManagerEnum.TYPE.SFX)
    await animationPlayer.animation_finished
    var page: ShopPageConfig = config.pageList[currentPage]
    for itemConfigId in page.itemList.size():
        var itemConfig: ShopItemConfig = page.itemList[itemConfigId]
        var item: ShopItem = SHOP_ITEM.instantiate()
        item.position = itemPos[itemConfigId]
        item.talk.connect(NpcTalk)
        item.pressed.connect(ItemPressed)
        itemNode.add_child(item)
        item.Init(itemConfig)

func PreButtonPressed() -> void :
    currentPage = (currentPage - 1 + pageNum) %pageNum
    PageFresh()

func NextButtonpressed() -> void :
    currentPage = (currentPage + 1 + pageNum) %pageNum
    PageFresh()

func MainMenuButtonPressed() -> void :
    TowerDefenseManager.coinBank.Hide.call_deferred()
    Close()

func NpcTalk(text: String) -> void :
    npcWeiWeiMi.Talk(text, "Talk", "")
    talkTimer = talkInterval

func ItemPressed(item: ShopItem) -> void :
    if item.cost > TowerDefenseManager.GetCoin():
        await DialogCreate("ShopCantSale").close
    else:
        var dialog = DialogCreate("ShopSale")
        dialog.item = item
        dialog.sale.connect(Sale)
        await dialog.close

func Sale(item: ShopItem) -> void :
    TowerDefenseManager.UseCoin(item.cost)
    item.Sale()
