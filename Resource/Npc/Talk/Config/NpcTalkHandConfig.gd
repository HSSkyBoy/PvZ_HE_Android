class_name NpcTalkHandConfig extends NpcTalkBaseConfig

@export var handScene: PackedScene
@export var shoulderScene: PackedScene
@export var shoulder2Scene: PackedScene
@export var headScene: PackedScene

func Init(data: Dictionary) -> void :
    super.Init(data)
    if data["Arg"].size() >= 1:
        handScene = load(data["Arg"][0])
    if data["Arg"].size() >= 2:
        shoulderScene = load(data["Arg"][1])
    if data["Arg"].size() >= 3:
        shoulder2Scene = load(data["Arg"][2])
    if data["Arg"].size() >= 4:
        headScene = load(data["Arg"][3])
