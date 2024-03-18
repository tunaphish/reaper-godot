extends Node

var State = preload("res://entities/actor.gd").State
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
	if actor.state == State.COUNTER:
		actor.updateStamina(-1)
	elif (actor.state != State.GUARD and actor.state != State.DEAD and actor.state != State.CASTING):
		actor.updateStamina(actor.staminaRegenRate)
	if (actor.getTickingHealth() > 0):
		actor.tickHealth()
	setState(actor)

signal actionQueued()
func queueAction():
	caster.updateStamina(-action.staminaCost)
	caster.updateMagic(-action.magicCost)
	if action.magicCost > caster.magic:
		caster.updateHealth(caster.magic-action.magicCost)
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
	queuedCaster.setState(State.NORMAL)

	for target in queuedTargets: 
		yield(get_tree().create_timer(0.3), "timeout")
		emit_signal("actionExecuted", queuedAction)
		actionExections.call(actionExecution, queuedCaster, target, metadata) 
	queuedCaster.setQueuedAction(null)

signal actorDied()
func setState(actor: Resource):
	if actor.state != State.DEAD and actor.health == 0:
		actor.setState(State.DEAD)
		actor.setQueuedAction(null)
		emit_signal("actorDied")
		return
	if actor.stamina < 0 and actor.state != State.CASTING:
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

signal menuOptionsAppended()
func appendMenuOptions(folder):
	menuOptions.append(folder)
	emit_signal("menuOptionsAppended")

signal potentialTargetsUpdated()
func onActionPressed(id):
	var option = menuOptions.back().options[id]
	if option is Action:
		setAction(option)
		if option.targetType == TargetType.AOE:
			potentialTargets = [battleEntity.enemies, battleEntity.party]
			emit_signal("potentialTargetsUpdated")
		elif option.targetType == TargetType.SINGLE or option.targetType == TargetType.MULTI:
			potentialTargets = getActors()
			emit_signal("potentialTargetsUpdated")
		elif option.targetType == TargetType.SELF:
			targets = [caster]
		elif option.targetType == TargetType.ALL:
			targets = getActors()
	if option is Folder: 
		appendMenuOptions(option)

func onPotentialTargetPressed(id):
	var potentialTarget = potentialTargets[id];
	if potentialTarget is Array: 
		targets = potentialTarget
		return 
	if action.targetType == TargetType.MULTI: 
		multiTargets.append(potentialTarget)
		if multiTargets.size() >= action.metadata["multihit"]:
			targets = multiTargets
		else: 
			emit_signal("potentialTargetsUpdated")
		return
	targets = [potentialTarget]	
	
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
	appendMenuOptions(memberEntity.folder)