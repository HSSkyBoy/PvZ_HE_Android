class_name UserItem extends Button

signal choose(user: String)

func Pressed() -> void :
    emit_signal("choose", text)
