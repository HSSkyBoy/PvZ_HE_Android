extends DialogPopup

signal sale(_item: ShopItem)

var item: ShopItem

func TrueButtonPressed() -> void :
    sale.emit(item)
    Close()

func FalseButtonPressed() -> void :
    Close()
