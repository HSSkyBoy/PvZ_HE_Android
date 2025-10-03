class_name NpcTalkTutorialConfig extends NpcTalkBaseConfig

@export var tutorial: TutorialConfig

func Init(data: Dictionary) -> void :
    super.Init(data)
    tutorial = load(data["Arg"][0])
