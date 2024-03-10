extends PanelContainer

const MemberHud = preload("res://features/battle/visual/MemberHud.tscn")
const EnemyHud = preload("res://features/battle/visual/EnemyHud.tscn")
const ActionMenu = preload("res://features/battle/visual/ActionMenu.tscn")

onready var closeSound = $Close 

var battleEntity: Battle
var battle

var menus = []

func setup(initBattleEntity: Battle, initBattle):
	battleEntity = initBattleEntity
	battle = initBattle

	battle.connect("menuOptionsAppended", self, "createActionMenu")
	battle.connect("potentialTargetsUpdated", self, "createTargetMenu")
	battle.connect("actionExecuted", self, "onActionExecuted") 

	var partyBarNode = $VStack/PartyBar
	for member in battleEntity.party:
		var memberHud = MemberHud.instance().setup(member)
		partyBarNode.add_child(memberHud);
		memberHud.connect("memberPressed", self, "_on_memberPressed")
	
	var enemyBarNode = $VStack/EnemyBar
	for enemy in battleEntity.enemies:
		var enemyHud = EnemyHud.instance().setup(enemy)
		enemyBarNode.add_child(enemyHud)
	
	return self

func _on_memberPressed(memberEntity): 
	battle.setCaster(memberEntity)
	battle.appendMenuOptions(memberEntity.folder)

# Bug 1: Clicking outside modal closes all popups
# Bug 2: Nested menus still clickable
const INITIAL_ACTION_MENU_POSITION = Vector2(290,580);
func createActionMenu():
	var options = battle.menuOptions.back().options
	var optionLabels = []
	for option in options:
		if option is Action: 
			optionLabels.append(option.name + " " + str(option.staminaCost) + "SP " + str(option.magicCost) + "MP")
		if option is Folder:
			optionLabels.append(option.name)
	var actionMenu = ActionMenu.instance().setup(optionLabels)
	add_child(actionMenu)
	menus.append(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size())) # needs to be updated in case menu sizes increase or some thang
	actionMenu.connect("id_pressed", battle, "onActionPressed")
	actionMenu.connect("menuClosed", self, "_on_menuClosed")

func onActionExecuted(): 
	# shake targets
	
	closeMenus()

func closeMenus():
	for menu in menus:
		menu.queue_free()
	battle.clearSelections()

func createTargetMenu():
	var optionLabels = []
	for target in battle.potentialTargets: 
		optionLabels.append(target.name)
	var actionMenu = ActionMenu.instance().setup(optionLabels)
	add_child(actionMenu)
	menus.append(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size())) # needs to be updated in case menu sizes increase or some thang
	actionMenu.connect("id_pressed", battle, "onPotentialTargetPressed")
	actionMenu.connect("menuClosed", self, "_on_menuClosed")


func _on_menuClosed(): 
	closeSound.play()
	battle.menuOptions.pop_back()
	menus.pop_back()
