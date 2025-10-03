class_name NpcTalkBaseConfig extends Resource

@export var npc: String = ""
@export var text: String = ""
@export var anime: String = ""
@export var audio: String = ""

func Init(data: Dictionary) -> void :
    npc = data["Npc"]
    text = data["Text"]
    anime = data["Anime"]
    audio = data["Audio"]
