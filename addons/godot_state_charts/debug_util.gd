

static func path_of(node: Node) -> String:
    if node == null:
        return ""
    if !node.is_inside_tree():
        return node.name + " (not in tree)"
    return str(node.get_path())
