extends Node

@export var audioVolumDictionary: Dictionary = {}
@export var audioMemberDictionary: Dictionary = {}

var audioStack: Array[Dictionary] = []

signal volumChange(type: AudioManagerEnum.TYPE)

func _ready() -> void :
    audioMemberDictionary[AudioManagerEnum.TYPE.MUSIC] = {}
    audioMemberDictionary[AudioManagerEnum.TYPE.SFX] = {}

    audioVolumDictionary[AudioManagerEnum.TYPE.MUSIC] = GameSaveManager.GetConfigValue("MusicVolum")
    audioVolumDictionary[AudioManagerEnum.TYPE.SFX] = GameSaveManager.GetConfigValue("SfxVolum")

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    var audioPlayList: Array[String] = []
    for audioDictionary: Dictionary in audioStack:
        if audioPlayList.has(audioDictionary["Stream"]):
            continue
        audioPlayList.append(audioDictionary["Stream"])

        var player = MemberFind(audioDictionary["Stream"], audioDictionary["Type"])
        if is_instance_valid(player):
            player.play(audioDictionary["Pos"])
            if audioDictionary["PauseAlive"]:
                player.process_mode = Node.PROCESS_MODE_ALWAYS
            else:
                player.process_mode = Node.PROCESS_MODE_PAUSABLE

    audioStack.clear()

func MemberFind(stream: String, type: AudioManagerEnum.TYPE = AudioManagerEnum.TYPE.SFX) -> AudioStreamPlayerMember:
    var streamRes: AudioStream
    if audioMemberDictionary[type].has(stream) && is_instance_valid(audioMemberDictionary[type][stream]):
        return audioMemberDictionary[type][stream]
    if ResourceManager.AUDIOS.has(stream):
        streamRes = ResourceManager.AUDIOS[stream]
    var modAudioFind: AudioStream = ModManager.FindAudio(stream)
    if modAudioFind != null:
        streamRes = modAudioFind
    if is_instance_valid(streamRes):
        var player = AudioStreamPlayerMember.new()
        player.type = type
        player.stream = streamRes
        player.process_mode = Node.PROCESS_MODE_PAUSABLE
        volumChange.connect(player.VolumChange)
        match type:
            AudioManagerEnum.TYPE.SFX:
                player.max_polyphony = 25
        add_child(player)
        audioMemberDictionary[type][stream] = player
        return audioMemberDictionary[type][stream]
    return null

func VolumSet(type: AudioManagerEnum.TYPE = AudioManagerEnum.TYPE.SFX, valum: float = 1.0) -> void :
    audioVolumDictionary[type] = valum

func VolumGet(type: AudioManagerEnum.TYPE = AudioManagerEnum.TYPE.SFX) -> float:
    return audioVolumDictionary[type]

func AudioStopAll() -> void :
    for memberDictionary: Dictionary in audioMemberDictionary.values():
        for member: String in memberDictionary.keys():
            if !memberDictionary[member]:
                memberDictionary[member] = null
            if memberDictionary[member]:
                memberDictionary[member].queue_free()
                memberDictionary[member] = null
    for node in get_children():
        node.queue_free()

func AudioPlay(stream: String, type: AudioManagerEnum.TYPE = AudioManagerEnum.TYPE.SFX, pos: float = 0.0, once: bool = true, pauseAlive: bool = false) -> AudioStreamPlayerMember:
    var modAudioFind: AudioStream = ModManager.FindAudio(stream)
    if !ResourceManager.AUDIOS.has(stream) && modAudioFind == null:
        return null
    var player: AudioStreamPlayerMember = null
    match type:
        AudioManagerEnum.TYPE.SFX:
            var audioDictionary: Dictionary = {
                "Stream": stream, 
                "Type": type, 
                "Pos": pos, 
                "Once": once, 
                "PauseAlive": pauseAlive
            }
            audioStack.append(audioDictionary)
        AudioManagerEnum.TYPE.MUSIC:
            player = MemberFind(stream, type)
            if pauseAlive:
                player.process_mode = Node.PROCESS_MODE_ALWAYS
            else:
                player.process_mode = Node.PROCESS_MODE_PAUSABLE
            player.play(pos)
    return player
