@tool
class_name TowerDefenseZombieConfig extends TowerDefenseCharacterConfig

@export var physique: TowerDefenseEnum.ZOMBIE_PHYSIQUE = TowerDefenseEnum.ZOMBIE_PHYSIQUE.NORMAL
@export var attack: float = 0.0
@export var smashAttack: float = 0.0
@export var impactAudio: String = ""
@export_category("Spawn")
@export var weight: int = 1000
@export var wavePointCost: int = 100
@export var canSpawnPlantfood: bool = true
@export var excludeLineGridType: Array[TowerDefenseEnum.PLANTGRIDTYPE] = []
