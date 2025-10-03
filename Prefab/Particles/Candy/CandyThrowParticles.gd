extends GPUParticles2D

func _ready():
    restart()
    finished.connect(queue_free)
