extends PanelContainer

const TICK = .06 #15ish ticks per second
var battleEntity: Battle
const memberHudScene = preload("res://features/battle/visual/MemberHud.tscn");
const enemyHudScene = preload("res://features/battle/visual/EnemyHud.tscn");
var timer: float = 0

var actionExections = preload("res://entities/action/actionExecutions.gd").new()
var actionMenuScene = preload("res://features/battle/visual/ActionMenu.tscn")

var folders = []
var caster
# ability
# target

func _ready():
	if !battleEntity:
		battleEntity = preload("res://entities/battle/testBattle.tres")

	var partyBarNode = $BattleContainer/PartyBar
	for member in battleEntity.party:
		var memberHud = memberHudScene.instance()
		memberHud.memberEntity = member
		partyBarNode.add_child(memberHud);
		memberHud.connect("memberPressed", self, "on_memberPressed")
	
	var enemyBarNode = $BattleContainer/EnemyBar
	for enemy in battleEntity.enemies:
		var enemyHud = enemyHudScene.instance()
		enemyHud.enemyEntity = enemy
		enemyBarNode.add_child(enemyHud)

func getActors(): 
	return battleEntity.party + battleEntity.enemies

func _process(delta):
	timer += delta
	if (timer < TICK):
		return
		
	getActors();
	
	for actor in getActors():
		actor.setStamina(actor.getStamina()+actor.staminaRegenRate)
		if (actor.getTickingHealth() > 0):
			actor.tickHealth()
			
	timer = 0
	
const INITIAL_ACTION_MENU_POSITION = Vector2(290,580);
func on_memberPressed(memberEntity): 
	caster = memberEntity

	folders.append(memberEntity.folder)
	var actionMenu = actionMenuScene.instance()
	actionMenu.folder = memberEntity.folder
	add_child(actionMenu)
	actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION) 
	actionMenu.connect("menuClosed", self, "_on_menuClosed")
	actionMenu.connect("id_pressed", self, "_on_id_pressed")

func _on_menuClosed(): 
	folders.pop_back()
	if folders.empty():
		caster = null

# Bug 1: Clicking outside modal closes all popups
# Bug 2: Nested menus still clickable
func _on_id_pressed(id):
	var option = folders.back().options[id]
	if option is Action:
		print(option.name)
		# if self action execute action
		# otherwise open a target menu
	if option is Folder: 
		folders.append(option)
		var actionMenu = actionMenuScene.instance()
		actionMenu.folder = option
		add_child(actionMenu)
		actionMenu.set_popup_position(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * folders.size())) # needs to be updated in case menu sizes increase or some thang
		actionMenu.connect("menuClosed", self, "_on_menuClosed")
		actionMenu.connect("id_pressed", self, "_on_id_pressed")



#for action in memberEntity.actions:
#	var actionExecution = action.get_execution_name()
	# spawn a menu
	#actionExections.call(actionExecution, battleEntity, memberEntity, [memberEntity]) # update to actual targets