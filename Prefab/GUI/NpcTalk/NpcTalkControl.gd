class_name NpcTalkControl extends Node2D

signal finish()

const NPC_CRAZY_DAVE = preload("uid://cvadcalsore2n")

var npcDictionary: Dictionary = {}

var config: NpcTalkConfig
var currentIndex: int = 0

func Init(_config: NpcTalkConfig) -> void :
    config = _config
    currentIndex = 0
    TalkNext()

func TalkNext() -> void :
    if currentIndex < config.talkList.size():
        var talk: NpcTalkBaseConfig = config.talkList[currentIndex]
        var npc: NpcBase = await GetNpc(talk.npc)
        npc.Talk(talk.text, talk.anime, talk.audio)
        if talk is NpcTalkHandConfig:
            npc.Hand(talk)
        if talk is NpcTalkTutorialConfig:
            TutorialManager.TutorialEnter(talk.tutorial)
            await TutorialManager.tutorialFinish
        if is_instance_valid(npc):
            await npc.talkNext

        currentIndex += 1
        TalkNext()
    else:
        finish.emit()

func GetNpc(npcName: String = "CrazyDave") -> NpcBase:
    if npcDictionary.has(npcName):
        if !is_instance_valid(npcDictionary[npcName]):
            npcDictionary.erase(npcName)
    if !npcDictionary.has(npcName):
        match npcName:
            "CrazyDave":
                var instance = NPC_CRAZY_DAVE.instantiate() as NpcBase
                add_child(instance)
                npcDictionary["CrazyDave"] = instance
                finish.connect(instance.Finish)
                await instance.npcReady
    return npcDictionary[npcName]
