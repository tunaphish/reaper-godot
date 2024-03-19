extends PanelContainer

var State = preload("res://entities/actor.gd").State
const MemberHud = preload("res://features/battle/visual/MemberHud.tscn")
const EnemyHud = preload("res://features/battle/visual/EnemyHud.tscn")
const ActionMenu = preload("res://features/battle/visual/ActionMenu.tscn")
const Stage = preload("res://features/battle/visual/stage.tscn")

const defaultSound = preload("res://assets/sounds/attack.wav")

onready var enemyBarNode = $VStack/EnemyBar
onready var stageContainer = $VStack/StageContainer
onready var partyBarNode = $VStack/PartyBar

onready var closeSound = $Close 
onready var actionSoundPlayer = $ActionSoundPlayer
onready var menuDisabledSound = $MenuDisabled
onready var deathSound = $Death

var battleEntity: Battle
var battle

var menus = []

func setup(initBattleEntity: Battle, initBattle):
	battleEntity = initBattleEntity
	battle = initBattle
	return self

func _ready():
	battle.connect("menuOptionsAppended", self, "createActionMenu")
	battle.connect("potentialTargetsUpdated", self, "createTargetMenu")
	battle.connect("actionExecuted", self, "onActionExecuted") 
	battle.connect("actionQueued", self, "onActionQueued")
	battle.connect("openDisabledMenu", self, "onOpenDisabledMenu")
	battle.connect("actorDied", self, "onActorDied")

	for member in battleEntity.party:
		var memberHud = MemberHud.instance().setup(member)
		partyBarNode.add_child(memberHud);
		memberHud.connect("memberPressed", self, "onMemberPressed")
	
	for enemy in battleEntity.enemies:
		var enemyHud = EnemyHud.instance().setup(enemy)
		enemyBarNode.add_child(enemyHud)
	
	var stage = Stage.instance().setup(battleEntity)
	stageContainer.add_child(stage)

func onMemberPressed(memberEntity):
	battle.openInitialMenu(memberEntity)

func onOpenDisabledMenu():
	menuDisabledSound.play()

func onActorDied():
	deathSound.play()


const INITIAL_ACTION_MENU_POSITION = Vector2(290,580);
func createActionMenu(options: Array):
	var optionLabels = []
	for option in options:
		if option is Action: 
			optionLabels.append(option.name + " " + str(option.staminaCost) + "SP " + str(option.magicCost) + "MP")
		if option is Soul:
			optionLabels.append(option.name)
	var actionMenu = ActionMenu.instance().setup(optionLabels)
	add_child(actionMenu)
	menus.append(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size())) 
	actionMenu.connect("id_pressed", battle, "onActionPressed")
	actionMenu.connect("menuClosed", self, "onMenuClosed")

func onActionQueued():
	closeMenus()

func onActionExecuted(action): 
	actionSoundPlayer.stream = action.sound
	actionSoundPlayer.play()

func closeMenus():
	for menu in menus:
		menu.queue_free()
	battle.clearSelections()

func createTargetMenu():
	var optionLabels = []
	for target in battle.potentialTargets: 
		if target is Array: # AOE 
			var label = ""
			for individualTarget in target:
				label += individualTarget.name + ", "
			if label.length() > 0:
				label = label.left(label.length() - 2)
			optionLabels.append(label)
		else: # Single Target
			optionLabels.append(target.name)
	var actionMenu = ActionMenu.instance().setup(optionLabels)
	add_child(actionMenu)
	menus.append(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size()))
	actionMenu.connect("id_pressed", battle, "onPotentialTargetPressed")
	actionMenu.connect("menuClosed", self, "onMenuClosed")


func onMenuClosed(): 
	closeSound.play()
	battle.menuOptions.pop_back()
	menus.pop_back()
