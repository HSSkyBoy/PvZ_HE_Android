extends TextureProgressBar

const REWARD_PROGRESS_TICK = preload("res://Asset/Texture/GUI/DailyChallenge/Award/RewardProgressTick.png")

@onready var tickNode: Control = %TickNode

var awardList: Array
var finish: int = 0
var dayAll: int = 30

func Init(_awardList: Array, _finish: int, _dayAll: int) -> void :
    awardList = _awardList
    finish = _finish
    dayAll = _dayAll

    max_value = dayAll
    value = finish

    for award in _awardList:
        var tickTexture = TextureRect.new()
        tickTexture.texture = REWARD_PROGRESS_TICK
        tickTexture.position.x = award["ConditionArg"][0] / dayAll * size.x
        tickTexture.position.y = 5
        tickNode.add_child(tickTexture)
        var icon = TextureRect.new()
        icon.texture = load(award["Icon"])
        icon.position = - icon.texture.get_size() / 2 - Vector2(0, 35)
        tickTexture.add_child(icon)
        var label = Label.new()
        label.text = str(int(award["ConditionArg"][0]))
        label.add_theme_constant_override("outline_size", 5)
        label.position = Vector2(0, 30)
        tickTexture.add_child(label)

func _ready() -> void :
    pass
