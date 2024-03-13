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
var caster
var action
var targets
const TICK = .25 #4 ticks per second
var timer: float = 0
func _process(delta):
	timer += delta
	if (timer < TICK):
		return
	timer = 0

	if enemiesAreDead():
		pass
	if partyIsDead():
		pass

	if (caster and action and targets):
		caster.updateStamina(-action.staminaCost)
		caster.updateMagic(-action.magicCost)
		if action.magicCost > caster.magic:
			caster.updateHealth(caster.magic-action.magicCost)
		queueAction()

	for actor in getActors():
		if (actor.state != State.GUARD and actor.state != State.DEAD and actor.state != State.CASTING):
			actor.updateStamina(actor.staminaRegenRate)
		if (actor.getTickingHealth() > 0):
			actor.tickHealth()
		setState(actor)


signal actionQueued()
func queueAction():
	var actionTimer = get_tree().create_timer(action.castTimeInMs/1000)
	actionTimer.connect("timeout", self, "executeAction", [action, battleEntity, caster, targets])
	caster.setState(State.CASTING)
	caster.setQueuedAction(action)
	emit_signal("actionQueued")

signal actionExecuted(action)
func executeAction(queuedAction, queuedBattleEntity, queuedCaster, queuedTargets):
	var actionExecution = queuedAction.get_execution_name()
	actionExections.call(actionExecution, queuedBattleEntity, queuedCaster, queuedTargets) 
	queuedCaster.setState(State.NORMAL)
	queuedCaster.setQueuedAction(null)
	emit_signal("actionExecuted", queuedAction)

func setState(actor: Resource):
	if actor.health == 0:
		actor.setState(State.DEAD)
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
		if option.targetType == TargetType.AOE: # figure this out later
			potentialTargets = getActors() 
			emit_signal("potentialTargetsUpdated")
		elif option.targetType == TargetType.SINGLE:
			potentialTargets = getActors()
			emit_signal("potentialTargetsUpdated")
		elif option.targetType == TargetType.SELF:
			targets = [self]
		elif option.targetType == TargetType.ALL:
			targets = getActors()
	if option is Folder: 
		appendMenuOptions(option)

func onPotentialTargetPressed(id):
	targets = [potentialTargets[id]]	
	
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
func openInitialMenu(memberEntity: Resource):
	if memberEntity.state == State.GUARD:
		memberEntity.setState(State.NORMAL)
	if memberEntity.state != State.NORMAL:
		emit_signal("openDisabledMenu")
		return
	setCaster(memberEntity)
	appendMenuOptions(memberEntity.folder)