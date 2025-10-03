extends Node

var currentTutoroal: TutorialConfig
var currentStep: int = 0

var stepExe: bool = false

signal tutorialFinish()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if stepExe:
        var step = currentTutoroal.GetTutorialStep(currentStep) as TutorialStepConfig
        if step.Step():
            stepExe = false
            step.Exit()
            if step.broadCastUse:
                if step.broadCastConfig.broadCastTime == -1:
                    BroadCastManager.Next()
                else:
                    await BroadCastManager.broadCastOver

            currentStep += 1
            TutorialExecute()

func TutorialEnter(tutorial: TutorialConfig) -> void :
    currentTutoroal = tutorial
    currentStep = 0
    TutorialExecute()

func TutorialExecute() -> void :
    if currentTutoroal:
        if currentStep >= currentTutoroal.GetStepNum():
            currentTutoroal = null
            BroadCastManager.BraodCastClear()
            tutorialFinish.emit()
            return
        var step = currentTutoroal.GetTutorialStep(currentStep) as TutorialStepConfig
        if step.broadCastUse:
            BroadCastManager.BroadCastAdd(step.broadCastConfig)
        step.Enter()
        stepExe = true

func TutorialClear() -> void :
    currentTutoroal = null
    currentStep = 0
    stepExe = false
    BroadCastManager.BraodCastClear()
