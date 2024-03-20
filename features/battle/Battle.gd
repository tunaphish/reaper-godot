extends Node

const EmotionKey = preload("res://entities/emotion/emotion.gd").EmotionKey
const State = preload("res://entities/actor.gd").State
const battleEntity: Battle = preload("res://entities/battle/testBattle.tres")
const Container = preload("res://features/battle/visual/Container.tscn");

func _ready():
	var container = Container.instance().setup(battleEntity, self);
	add_child(container)

const TargetType = preload("res://entities/action/action.gd").TargetType
var actionExections = preload("res://entities/action/actionExecutions.gd").new()
var menuOptions = []
var potentialTargets
var multiTargets = []
var targets
var caster
var action
const TICK = .25 #4 ticks per second
var timer: float = 0

var menuTimer

func _process(delta):
	if menuTimer != null:
		menuTimer += delta

	timer += delta
	if (timer < TICK):
		return
	timer = 0

	if enemiesAreDead():
		pass
	if partyIsDead():
		pass

	if (caster and action and targets):
		queueAction()

	for actor in getActors():
		updateStats(actor)

func updateStats(actor):
	if actor.state == State.REFLECT:
		actor.updateMagic(-1)
	elif actor.state == State.COUNTER:
		actor.updateStamina(-1)
	elif (actor.state != State.GUARD and actor.state != State.DEAD and actor.state != State.CASTING):
		if actor.emotionalState.get(EmotionKey.ANXIETY, 0) > 0 and menuOptions.size() > 0 and caster == actor: 
			actor.updateStamina(-menuOptions.size())
		else:
			actor.updateStamina(actor.staminaRegenRate)
	if (actor.getTickingHealth() > 0):
		actor.tickHealth()
	setState(actor)

signal actionQueued()
func queueAction():
	var flow = 0 
	for member in battleEntity.party:
		if member.state == State.ACTION:
			if !action.isMagicalAction():
				flow = min(member.flow + 1, 3)
			else: 
				flow = member.flow
	caster.setFlow(flow)

	var magicCost 
	match flow:
		0: magicCost = action.magicCost
		1: magicCost = int(action.magicCost * 0.75)
		2: magicCost = int(action.magicCost * 0.50)
		3: magicCost = 0
	caster.updateStamina(-action.staminaCost)
	caster.updateMagic(-magicCost)
	if magicCost > caster.magic:
		caster.receiveDamage(magicCost-caster.magic)
	
	var actionTimer = get_tree().create_timer(action.castTimeInMs/1000.0)
	var metadata = { "menuTimer": menuTimer, "menusNavigated": menuOptions.size() }	
	actionTimer.connect("timeout", self, "executeAction", [action, caster, targets, metadata])
	menuTimer = null
	caster.setState(action.queueState)
	caster.setQueuedAction(action)
	emit_signal("actionQueued")

signal actionExecuted(action)
func executeAction(queuedAction, queuedCaster, queuedTargets, metadata):
	if queuedCaster.state == State.DEAD: 
		return

	for i in range(queuedTargets.size()):
		var target = queuedTargets[i]
		if !queuedAction.isMagicalAction() and target.state == State.COUNTER:
			queuedTargets[i] = queuedCaster
		if queuedAction.isMagicalAction() and target.state == State.REFLECT:
			queuedTargets[i] = queuedCaster

	var actionExecution = queuedAction.get_execution_name()
	queuedCaster.setState(State.ACTION)
	yield(get_tree().create_timer(0.7), "timeout") # lower to .3 later
	queuedCaster.setFlow(0)
	queuedCaster.setState(State.NORMAL)
	queuedCaster.setQueuedAction(null)

	for target in queuedTargets: 
		yield(get_tree().create_timer(0.3), "timeout")
		emit_signal("actionExecuted", queuedAction)
		actionExections.call(actionExecution, queuedCaster, target, metadata) 


var NON_EXHAUSTABLE_STATES = [State.ACTION, State.CASTING]
signal actorDied()
func setState(actor: Resource):
	if actor.state != State.DEAD and actor.health == 0:
		actor.setState(State.DEAD)
		actor.setQueuedAction(null)
		emit_signal("actorDied")
		return
	if actor.stamina < 0 and !NON_EXHAUSTABLE_STATES.has(actor.state):
		actor.setState(State.EXHAUSTED)
		return
	if actor.state == State.DEAD and actor.health > 0: 
		actor.setState(State.NORMAL)
		return 
	if actor.state == State.EXHAUSTED and actor.stamina > 0:
		actor.setState(State.NORMAL)


func clearSelections():
	caster = null
	action = null
	targets = null
	menuOptions = []
	potentialTargets = null
	multiTargets = []

func getActors(): 
	return battleEntity.party + battleEntity.enemies

func setAction(newAction):
	action = newAction

func setCaster(memberEntity):
	caster = memberEntity


signal openDisabledMenu()
var disabledStates = [State.DEAD, State.EXHAUSTED, State.CASTING]
var defensiveStates = [State.GUARD, State.COUNTER, State.REFLECT]
func openInitialMenu(memberEntity: Resource):
	menuTimer = 0
	if defensiveStates.has(memberEntity.state):
		memberEntity.setState(State.NORMAL)
	if disabledStates.has(memberEntity.state):
		emit_signal("openDisabledMenu")
		return
	setCaster(memberEntity)
	appendMenuOptions(memberEntity.soul.options, memberEntity.soul.name)


signal menuOptionsAppended(options, title)
# signal doubtMenuTriggered()
func appendMenuOptions(initOptions, title):
	var options = initOptions.duplicate()
	menuOptions.append(options)
	var optionLabels = createOptionlabels(options)
	# var doubtCalculation = min(caster.emotionalState.get(EmotionKey.DOUBT, 0)*0.1, 0.5)
	# if doubtCalculation > randf():
	# 	emit_signal("doubtMenuTriggered")
	# 	return
	emit_signal("menuOptionsAppended", optionLabels, title)


func createOptionlabels(options):
	var optionLabels = []
	for option in options:
		if option is Action: 
			optionLabels.append(option.name + " " + str(option.staminaCost) + "SP " + str(option.magicCost) + "MP")
		if option is Soul:
			optionLabels.append(option.name)
		if option is Actor:
			optionLabels.append(option.name)
		if option is Array: # AOE 
			var label = ""
			for individualTarget in option:
				label += individualTarget.name + ", "
			if label.length() > 0:
				label = label.left(label.length() - 2)
			optionLabels.append(label)
	return optionLabels


func onOptionPressed(id):
	var option = menuOptions.back()[id]
	if option is Action:
		setAction(option)
		if option.targetType == TargetType.AOE:
			appendMenuOptions([battleEntity.enemies, battleEntity.party], "Target")
		elif option.targetType == TargetType.SINGLE or option.targetType == TargetType.MULTI:
			appendMenuOptions(getActors(), "Target")
		elif option.targetType == TargetType.SELF:
			targets = [caster]
		elif option.targetType == TargetType.ALL:
			targets = getActors()
	elif option is Soul: 
		appendMenuOptions(option.options, option.name)
	elif option is Array: 
		targets = option
	elif action.targetType == TargetType.MULTI: 
		multiTargets.append(option)
		if multiTargets.size() >= action.metadata["multihit"]:
			targets = multiTargets
		else: 
			appendMenuOptions(menuOptions.back(), "Target")
	elif option is Actor:
		targets = [option]	


# func createDoubtMenu():
# 	var actionMenu = ActionMenu.instance().setup(["Yes", "No"], "Are you Sure?")
# 	add_child(actionMenu)
# 	menus.append(actionMenu)
# 	actionMenu.setPopupPosition(INITIAL_ACTION_MENU_POSITION - (Vector2(10,10) * menus.size()))
# 	actionMenu.connect("id_pressed", battle, "onDoubtMenuPressed")
# 	actionMenu.connect("menuClosed", self, "onMenuClosed")

#assumes Yes, No order. might change if confusion can apply
# signal doubtedThemself()
# func onDoubtMenuPressed(id): 
# 	if id == 0:
# 		var soul = menuOptions.back()
# 		emit_signal("menuOptionsAppended", soul.options, soul.name)
# 		return 
# 	if id == 1: 
# 		emit_signal("doubtedThemself")
# 		return


func enemiesAreDead():
	for enemy in battleEntity.enemies:
		if enemy.state != State.DEAD:
			return false
	return true


func partyIsDead():
	for member in battleEntity.party:
		if member.state != State.DEAD:
			return false
	return true

