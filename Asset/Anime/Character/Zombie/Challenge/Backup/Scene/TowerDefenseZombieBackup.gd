@tool
extends TowerDefenseZombie

var walkTime: int = 4
var danceTime: int = 2

var jackson: TowerDefenseCharacter

func DanceEntered() -> void :
    danceTime = 2
    sprite.SetAnimation("ArmRise", true, 0.2)

@warning_ignore("unused_parameter")
func DanceProcessing(delta: float) -> void :
    sprite.timeScale = timeScale * 1.0
    if !sprite.pause && attackComponent.CanAttack():
        Attack()

func DanceExited() -> void :
    pass

func WalkEntered() -> void :
    super .WalkEntered()
    walkTime = 4

func WalkProcessing(delta: float) -> void :
    if is_instance_valid(jackson):
        groundMoveComponent.alive = jackson.groundMoveComponent.alive
    else:
        groundMoveComponent.alive = true
    super .WalkProcessing(delta)

func DieProcessing(delta: float) -> void :
    super .DieProcessing(delta)
    sprite.timeScale = timeScale * 2.0

func AnimeCompleted(clip: String) -> void :
    super .AnimeCompleted(clip)
    match clip:
        "Walk":
            if (TowerDefenseManager.currentControl && !TowerDefenseManager.currentControl.isGameRunning):
                return
            walkTime -= 1
            if ( !die && !nearDie):
                if walkTime <= 0:
                    if !is_instance_valid(jackson) || (is_instance_valid(jackson) && !jackson.groundMoveComponent.alive):
                        state.send_event("ToDance")
            else:
                OutJackson()
                Die()
        "ArmRise":
            danceTime -= 1
            if ( !die && !nearDie):
                if danceTime <= 0:
                    if !is_instance_valid(jackson) || (is_instance_valid(jackson) && !jackson.groundMoveComponent.alive):
                        Walk()
            else:
                OutJackson()
                Die()

func Hypnoses(time: float = -1) -> void :
    super .Hypnoses(time)
    OutJackson()

func OutJackson() -> void :
    if is_instance_valid(jackson):
        if !jackson.instance.hypnoses:
            var pos = jackson.dancerList.find(self)
            if pos != -1:
                jackson.dancerList[pos] = null
            jackson = null
