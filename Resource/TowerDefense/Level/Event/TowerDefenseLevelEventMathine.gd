class_name TowerDefenseLevelEventMathine

const eventList: Dictionary = {

    "LEVLE_EVENT_GRAVESTONE_CREATE_RANDOM": "GravestoneCreateRandom", 
    "LEVLE_EVENT_GRAVESTONE_SPAWN_ZOMBIE": "GravestoneSpawnZombie", 

    "LEVLE_EVENT_CURRENTMAP_USE_STRIPE": "CurrentMapUseStripe", 
    "LEVLE_EVENT_CURRENTMAP_CHARACTER_CLEAR": "CurrentMapCharacterClear", 
    "LEVLE_EVENT_MAP_CHANGE": "MapChange", 
    "LEVLE_EVENT_TIPS_PLAY": "TipsPlay", 
    "LEVLE_EVENT_SET_GAME_MODE": "SetGameMode", 
    "LEVLE_EVENT_CREATE_PROTAL": "CreateProtal", 
    "LEVLE_EVENT_CHAGE_PROTAL_POS": "ChangeProtalPos", 
}

static func EventGet(eventName: String) -> TowerDefenseLevelEventBase:
    match eventName:

        "ConditionNpcTalkFinish":
            return TowerDefenseLevelEventConditionNpcTalkFinish.new()


        "GravestoneCreateRandom":
            return TowerDefenseLevelEventGravestoneCreateRandom.new()
        "GravestoneSpawnZombie":
            return TowerDefenseLevelEventGravestoneSpawnZombie.new()



        "CurrentMapFunctionExecute":
            return TowerDefenseLevelEventCurrentMapFunctionExecute.new()
        "CurrentMapUseStripe":
            return TowerDefenseLevelEventCurrentMapUseStripe.new()
        "CurrentMapCharacterClear":
            return TowerDefenseLevelEventCurrentMapCharacterClear.new()
        "MapChange":
            return TowerDefenseLevelEventMapChange.new()



        "AddPacket":
            return TowerDefenseLevelEventAddPacket.new()



        "TipsPlay":
            return TowerDefenseLevelEventTipsPlay.new()



        "SetGameMode":
            return TowerDefenseLevelEventSetGameMode.new()



        "CreateProtal":
            return TowerDefenseLevelEventCreateProtal.new()
        "ChangeProtalPos":
            return TowerDefenseLevelEventChangeProtalPos.new()


    return null
