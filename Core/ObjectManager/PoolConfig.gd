class_name PoolConfig extends RefCounted

@export var scene: PackedScene
@export var maxNum: int = 100
@export var popCallable: String = ""
@export var pushCallable: String = ""

var stack: Array[Node] = []

func Push(node: Node) -> void :

    if !is_instance_valid(node):
        return


    var parent: Node = node.get_parent()
    if !is_instance_valid(parent):
        node.queue_free()
        return

    if pushCallable != "" and node.has_method(pushCallable):
        node.call(pushCallable)


    await ObjectManager.get_tree().physics_frame
    if !is_instance_valid(node):
        return
    parent = node.get_parent()
    if is_instance_valid(parent):
        parent.remove_child(node)


        if maxNum == -1 || stack.size() < maxNum:
            stack.push_back(node)
        else:
            node.queue_free()

func Pop(parent: Node) -> Node:
    var node: Node

    if stack.size() > 0:
        node = stack.pop_back()
    else:
        node = scene.instantiate()

    var getParent: Node = node.get_parent()
    if getParent:
        node.reparent(parent)
    elif getParent != parent:

        parent.add_child(node)


    if popCallable != "" and node.has_method(popCallable):
        node.call(popCallable)
    return node

func Clear() -> void :
    for node in stack:
        if is_instance_valid(node) and !node.is_queued_for_deletion():
            node.queue_free()
    stack.clear()
