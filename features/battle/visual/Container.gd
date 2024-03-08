extends PanelContainer

const memberHudScene = preload("res://features/battle/visual/MemberHud.tscn")
const enemyHudScene = preload("res://features/battle/visual/EnemyHud.tscn")
const ActionMenu = preload("res://features/battle/visual/ActionMenu.tscn")

onready var closeSound = $Close 

var battleEntity: Battle
var battle

var menus = []

func setup(initBattleEntity: Battle, initBattle):
	battleEntity = initBattleEntity
	battle = initBattle

	battle.connect("menuOptionsAppended", self, "_create_menu")

	var partyBarNode = $VStack/PartyBar
	for member in battleEntity.party:
		var memberHud = memberHudScene.instance()
		memberHud.memberEntity = member
		partyBarNode.add_child(memberHud);
		memberHud.connect("memberPressed", self, "_on_memberPressed")
	
	var enemyBarNode = $VStack/EnemyBar
	for enemy in battleEntity.enemies:
		var enemyHud = enemyHudScene.instance()
		enemyHud.enemyEntity = enemy
		enemyBarNode.add_child(enemyHud)
	
	return self

func _on_memberPressed(memberEntity): 
	battle.appendMenuOptions(memberEntity.folder)

# Bug 1: Clicking outside modal closes all popups
# Bug 2: Nested menus still clickable
const INITIAL_ACTION_MENU_POSITION = Vector2(290,580);
func _create_menu():
	var actionMenu = ActionMenu.instance()
	actionMenu.folder = battle.menuOptions.back()
	add_child(actionMenu)
	menus.append(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size())) # needs to be updated in case menu sizes increase or some thang
	actionMenu.connect("id_pressed", battle, "_on_action_pressed")
	actionMenu.connect("menuClosed", self, "_on_menuClosed")

func _on_menuClosed(): 
	closeSound.play()
	battle.menuOptions.pop_back()
	menus.pop_back()
