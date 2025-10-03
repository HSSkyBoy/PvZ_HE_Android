extends Node

const SCENE_LOADING: PackedScene = preload("res://Core/SceneManager/SceneLoadeing/SceneLoading.tscn")

const SCENES: Dictionary = {
    "Loading": "uid://3q5h8vq3vco5", 
    "MainMenu": "uid://7rqvcn2algju", 
    "TowerDefense": "uid://cttxxkxrktmki", 
    "LevelChoose": "uid://bdn3to4813v1j", 
    "AwardSettlement": "uid://b8de1mhphnwo7", 
    "LevelEditorStage": "uid://bxi6r3quc47lr"
}

signal sceneChange(sceneName: String)

var scaneLoading: SceneLoading

var currentScene: String
var currentStopAllAudio: bool = false
var isLoading: bool = false
var currentSceneLoading: String = ""

var sceneStack: Array[String] = []

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if isLoading:
        if ResourceLoader.load_threaded_get_status(currentSceneLoading) == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
            scaneLoading.Exit()
            get_tree().unload_current_scene()
            get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(currentSceneLoading))
            currentSceneLoading = ""
            isLoading = false
            scaneLoading = null
            if currentStopAllAudio:
                AudioManager.AudioStopAll()

func ChangeScene(scene: String, stopAllAudio: bool = true) -> void :
    get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
    currentStopAllAudio = stopAllAudio

    ObjectManager.Clear()
    if currentScene != scene:
        sceneStack.append(scene)
        currentScene = scene
    scaneLoading = SCENE_LOADING.instantiate() as SceneLoading
    add_child.call_deferred(scaneLoading)
    sceneChange.emit(scene)
    await scaneLoading.enter
    var scenePath: String
    var modSceneFind: String = ModManager.FindScene(scene)
    if modSceneFind != "":
        scenePath = modSceneFind
    elif SCENES.has(scene):
        scenePath = SCENES[scene]

    if ResourceLoader.exists(scenePath):
        ResourceLoader.load_threaded_request(scenePath)
        currentSceneLoading = scenePath
        isLoading = true
        Global.timeScale = 1.0

func ReloadScene(stopAllAudio: bool = true) -> void :
    get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
    currentStopAllAudio = stopAllAudio

    ObjectManager.Clear()
    scaneLoading = SCENE_LOADING.instantiate() as SceneLoading
    add_child.call_deferred(scaneLoading)
    sceneChange.emit(currentScene)
    await scaneLoading.enter
    if SCENES.has(currentScene):
        var scenePath: String = SCENES[currentScene]
        if ResourceLoader.exists(scenePath):
            ResourceLoader.load_threaded_request(scenePath)
            currentSceneLoading = scenePath
            isLoading = true
            Global.timeScale = 1.0

func BackScene() -> void :
    ChangeScene(sceneStack.pop_back())
