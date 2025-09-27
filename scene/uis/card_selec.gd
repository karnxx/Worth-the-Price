extends CanvasLayer

@onready var label: Label = $HBoxContainer/Panel/Label
@onready var labeld: Label = $HBoxContainer/Panel2/Label
@onready var labedl: Label = $HBoxContainer/Panel3/Label
@onready var button: Button = $HBoxContainer/Panel/Button
@onready var buttond: Button = $HBoxContainer/Panel2/Button
@onready var buttodn: Button = $HBoxContainer/Panel3/Button

var global_sac
var card_debuffs: Array = []  # will hold 3 debuff names (1 per button)

func _ready() -> void:
	global_sac = SacManager
	card_debuffs = global_sac.generate_cards()
	_update_labels()
	
	button.pressed.connect(_on_button_pressed.bind(0))
	buttond.pressed.connect(_on_button_pressed.bind(1))
	buttodn.pressed.connect(_on_button_pressed.bind(2))

func _update_labels():
	label.text = card_debuffs[0]
	labeld.text = card_debuffs[1]
	labedl.text = card_debuffs[2]

func _on_button_pressed(card_index: int) -> void:
	if card_index < card_debuffs.size():
		var debuff_name = card_debuffs[card_index]
		global_sac.apply_debuff(debuff_name)
		match card_index:
			0: button.disabled = true
			1: buttond.disabled = true
			2: buttodn.disabled = true
