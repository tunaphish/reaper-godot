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
	battle.connect("menuOptionsAppended", self, "onMenuOptionsAppended")
	battle.connect("menuOptionsPopped", self, "onMenuOptionsPopped")
	battle.connect("potentialTargetsUpdated", self, "createTargetMenu")

	battle.connect("actionExecuted", self, "onActionExecuted") 
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


func onActionExecuted(action): 
	actionSoundPlayer.stream = action.sound
	actionSoundPlayer.play()


const INITIAL_ACTION_MENU_POSITION = Vector2(290,580);
func onMenuOptionsAppended(options: Array, title: String, actor: Actor):
	var optionLabels = createOptionlabels(options)
	var actionMenu = ActionMenu.instance().setup(optionLabels, title, actor)
	add_child(actionMenu)
	menus.append(actionMenu)
	actionMenu.setPopupPosition(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size())) 
	actionMenu.connect("id_pressed", battle, "onOptionPressed")


func onMenuOptionsPopped(): 
	closeSound.play()
	var menu = menus.pop_back()
	if menu: 
		menu.queue_free()


func createOptionlabels(options):
	var optionLabels = []
	for option in options:
		if option is Action: 
			optionLabels.append(option.name + " " + str(option.staminaCost) + "SP " + str(option.magicCost) + "MP")
		elif option is Array and option[0] is Item: #item 
			optionLabels.append(option[0].name+ " " + str(option[1]) + "/" + str(option[0].maxCharges) )
			pass
		elif option is Soul:
			optionLabels.append(option.name)
		elif option is Actor:
			optionLabels.append(option.name)
		elif option is Option: 
			optionLabels.append(option.name)
		elif option is Pocket:
			optionLabels.append(option.name)
		elif option is Array: # AOE 
			var label = ""
			for individualTarget in option:
				label += individualTarget.name + ", "
			if label.length() > 0:
				label = label.left(label.length() - 2)
			optionLabels.append(label)
	return optionLabels