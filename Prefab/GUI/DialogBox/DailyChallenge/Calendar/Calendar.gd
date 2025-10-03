extends Control

const DAILY_CHALLENGE_TODAY_MARKER = preload("uid://cq333hjurbav3")
const BUTTON_SCENE: PackedScene = preload("uid://da2qq6lpmnu45")
const WEEKDAYS: Array = ["日", "一", "二", "三", "四", "五", "六"]
const DATE_BUTTON_GROUP = preload("uid://bptsnmi53e12v")
@onready var panel_container: PanelContainer = $PanelContainer
@onready var grid_dates: GridContainer = $PanelContainer / CalendarContainer / Dates
@onready var label_month_year: Label = $PanelContainer / CalendarContainer / MonthYearContainer / MonthYear
@onready var btn_prev_month: Button = $PanelContainer / CalendarContainer / MonthYearContainer / PrevButton
@onready var btn_next_month: Button = $PanelContainer / CalendarContainer / MonthYearContainer / NextButton
var year: int = 2025
var month: int = 1
var day: int = 1

var days_in_month: int = 0
var first_day_of_week: int = 0

var buttons: Array = [Button]
var selected_button: Button = null

var today: String = ""

signal select(_year: int, _month: int, _day: int)

func _ready() -> void :
    _get_current_date()
    btn_prev_month.pressed.connect(_on_prev_month)
    btn_next_month.pressed.connect(_on_next_month)

    setup_calendar()


func setup_calendar() -> void :
    _clear_calendar()
    _generate_weekdays()
    _generate_dates()
    _update_month_label()
    select.emit(year, month, day)


func _clear_calendar() -> void :
    for child in grid_dates.get_children():
        child.queue_free()
    buttons.clear()
    select.emit(-1, -1, -1)

func _get_current_date() -> void :
    var datetime = Time.get_datetime_dict_from_system()




    year = datetime.year
    month = datetime.month
    day = datetime.day


func _generate_weekdays(use_letters: bool = false) -> void :
    for days in WEEKDAYS:
        var label = Label.new()
        if use_letters:
            days = days.substr(0, 1)
        label.set_text(days)
        label.add_theme_color_override("font_color", Color.BLACK)
        label.add_theme_font_size_override("font_size", 24)
        label.set_horizontal_alignment(HORIZONTAL_ALIGNMENT_CENTER)
        grid_dates.add_child(label)


func _generate_dates() -> void :
    var date = Time.get_datetime_dict_from_unix_time(Time.get_unix_time_from_datetime_dict({
        "year": year, "month": month, "day": 1
    }))
    days_in_month = _get_days_in_month(month, year)
    first_day_of_week = date.weekday

    for _i in range(first_day_of_week):
        var empty_label = Label.new()
        grid_dates.add_child(empty_label)

    var levelDataMap: Dictionary = ResourceManager.DAILY_LEVEL_DATA["LevelDateMap"]
    for days in range(1, days_in_month + 1):
        var button = BUTTON_SCENE.instantiate()
        button.set_text(str(days))
        button.pressed.connect(_on_date_selected.bind(days, button))
        grid_dates.add_child(button)
        buttons.append(button)
        button.button_group = DATE_BUTTON_GROUP
        button.disabled = ResourceManager.DAILY_LEVEL_DATA.is_empty() || !ResourceManager.DAILY_LEVEL_DATA["LevelDateMap"].has("%d-%02d-%02d" % [year, month, days])
        if button.disabled:
            button.focus_mode = Control.FOCUS_NONE
        else:
            var dateString: String = "%d-%02d-%02d" % [year, month, days]
            if levelDataMap.has(dateString):
                var finishFlag: bool = true
                var levelList: Array = levelDataMap[dateString]
                for level: String in levelList:
                    var levelName = "DailyLevel-%s-%s" % [dateString, level]
                    var levelData: Dictionary = GameSaveManager.GetLevelValue(levelName)
                    if levelData.get("Key", {}).get("Finish", 0) <= 0:
                        finishFlag = false
                        break
                if finishFlag:
                    button.finishTexture.visible = true
        if days == Time.get_datetime_dict_from_system().day && year == Time.get_datetime_dict_from_system().year && month == Time.get_datetime_dict_from_system().month:
            today = "%d-%02d-%02d" % [year, month, days]
            button.button_pressed = true
            button.icon = DAILY_CHALLENGE_TODAY_MARKER
            selected_button = button
            selected_button.add_theme_color_override("font_color", selected_button.get_theme_color("font_focus_color"))
        else:
            button.add_theme_color_override("font_hover_pressed_color", Color.BLACK)
            button.add_theme_color_override("font_hover_color", Color.BLACK)
            button.add_theme_color_override("font_disabled_color", Color.BLACK)
            button.add_theme_color_override("font_color", Color.BLACK)
            button.add_theme_color_override("font_focus_color", Color.BLACK)
            button.add_theme_color_override("font_pressed_color", Color.BLACK)

func _get_days_in_month(target_month: int, target_year: int) -> int:
    var next_month = target_month + 1 if target_month < 12 else 1
    var next_year = target_year if target_month < 12 else target_year + 1
    var first_day_next_month = Time.get_unix_time_from_datetime_dict({
        "year": next_year, "month": next_month, "day": 1
    })
    var last_day_of_current_month = Time.get_datetime_dict_from_unix_time(first_day_next_month - 86400)
    return last_day_of_current_month.day


func _on_date_selected(new_day: int, button: Button) -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    day = new_day
    select.emit(year, month, day)



    selected_button = button


func _on_prev_month() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    month -= 1
    if month < 1:
        month = 12
        year -= 1
    setup_calendar()

func _on_next_month() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
    month += 1
    if month > 12:
        month = 1
        year += 1
    setup_calendar()

func _update_month_label() -> void :
    label_month_year.set_text("%d/%s " % [year, _get_month_name(month)])

func _get_month_name(m: int) -> String:
    var months = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
    return months[m - 1]
