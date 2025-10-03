class_name ModLevel extends Resource

var LEVELS: Dictionary = {}

func Init(modPath: String, data: Dictionary) -> void :
    LoadLevel(modPath, data)

@warning_ignore("unused_parameter")
func LoadLevel(modPath: String, data: Dictionary) -> void :
    prints("Load Level")
    LEVELS = data

func GetLevel(currentChoose: String, chapterId: int, levelId: int, difficult: String) -> String:
    if !LEVELS.has(currentChoose):
        return ""
    var chapterList: Array = LEVELS[currentChoose].get("Chapter", [])
    if chapterList.size() <= chapterId:
        return ""
    var levelList: Array = chapterList[chapterId]["Level"]
    if levelList.size() <= levelId:
        return ""
    var difficultDictionary: Dictionary = levelList[levelId]["Level"]
    if !difficultDictionary.has(difficult):
        return ""
    return difficultDictionary[difficult]
