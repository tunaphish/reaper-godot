extends Node

const EmotionKey = preload("res://entities/emotion/emotion.gd").EmotionKey
const CovenantKey = preload("res://entities/covenant/covenant.gd").CovenantKey
const State = preload("res://entities/actor.gd").State
const CovenantState = preload("res://entities/actor.gd").CovenantState
const Container = preload("res://features/battle/visual/Container.tscn");
const TargetType = preload("res://entities/targetType.gd").TargetType
var actionExections = preload("res://entities/action/actionExecutions.gd").new()
var itemExecutions = preload("res://entities/item/itemExecutions.gd").new()

const ATTACK_ACTION = preload("res://entities/action/ATTACK.tres")

const YES_OPTION = preload("res://entities/option/yes.tres")
const NO_OPTION = preload("res://entities/option/no.tres")
const DOUBT_OPTIONS = [YES_OPTION, NO_OPTION]

var battleEntity: Battle

func _ready():
	if battleEntity == null:
		battleEntity = preload("res://entities/battle/testBattle.tres")
	var container = Container.instance().setup(battleEntity, self);
	add_child(container)


var menuOptions = []
var multiTargets = []
var targets
var caster
var action
var item
var covenant

var doubtOptions = []
var doubtName = ""
var menuTimer
var individualMenuTimer = 0
var staminaFromVitalityCovenant = {}

var timer: float = 0
const TICK = .333 #3 ticks per second
func _process(delta):
	if menuOptions.size() == 0:
		caster = null # hacky? solution to reset caster 
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

	if (caster and covenant):
		toggleCovenant(covenant, caster)

	if (caster and action and targets):
		queueAction(caster, action, targets)
	
	if (caster and item and targets):
		consumeItem(item, caster, targets)

	for actor in getActors():
		updateStats(actor)

	for actor in getActors():
		checkDecisivenessVow(actor, caster)
		if actor.state != State.CASTING and actor.stamina > actor.maxStamina - actor.getEmotionValue(EmotionKey.EXCITED) * 10 :
			caster = actor
			action = ATTACK_ACTION
			targets = [selectRandomItem(getActors())] 


func updateStats(actor):
	var envyDot = actor.getEmotionValue(EmotionKey.ENVY)
	if actor.state != State.DEAD:
		actor.receiveDamage(envyDot)

	if actor.state == State.REFLECT:
		actor.updateMagic(-1)
	elif actor.state == State.COUNTER:
		actor.updateStamina(-1)
	elif (actor.state != State.GUARD and actor.state != State.DEAD and actor.state != State.CASTING):
		if actor.getEmotionValue(EmotionKey.ANXIETY) > 0 and menuOptions.size() > 0 and caster == actor: 
			actor.updateStamina(-menuOptions.size())
		else:
			actor.updateStamina(actor.staminaRegenRate)
			if actor.covenants.get(CovenantKey.VITALITY) == CovenantState.ACTIVE:
				actor.updateStamina(1)
				staminaFromVitalityCovenant[actor.name] = staminaFromVitalityCovenant.get(actor.name, 0) + 1
	if (actor.getTickingHealth() > 0):
		actor.tickHealth()
	setState(actor)


func queueAction(queuedCaster, queuedAction, queuedTarget):
	clearSelections()
	var flow = 0 
	for member in battleEntity.party:
		if member.state == State.ACTION:
			if !queuedAction.isMagicalAction():
				flow = member.flow + 1
				if member.covenants.get(CovenantKey.COMMITMENT) == CovenantState.ACTIVE:
					flow = flow + 1
				elif member.covenants.get(CovenantKey.COMMITMENT) == CovenantState.BROKEN:
					flow = 0
				flow = min(flow, 3)
			else: 
				flow = member.flow
	queuedCaster.setFlow(flow)

	var magicCost 
	match flow:
		0: magicCost = queuedAction.magicCost
		1: magicCost = int(queuedAction.magicCost * 0.75)
		2: magicCost = int(queuedAction.magicCost * 0.50)
		3: magicCost = 0
	queuedCaster.updateStamina(-queuedAction.staminaCost)
	queuedCaster.updateMagic(-magicCost)
	if magicCost > queuedCaster.magic:
		queuedCaster.receiveDamage(magicCost-queuedCaster.magic)
	
	var actionTimer = get_tree().create_timer(queuedAction.castTimeInMs/1000.0)
	var metadata = { "menuTimer": menuTimer, "menusNavigated": menuOptions.size() }	
	actionTimer.connect("timeout", self, "executeAction", [queuedAction, queuedCaster, queuedTarget, metadata])
	menuTimer = null
	queuedCaster.setState(queuedAction.queueState)
	queuedCaster.setQueuedAction(queuedAction)
	if queuedAction.isMagicalAction():
		breakVitalityVow(queuedCaster)
		return


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
		actionExections.call(actionExecution, queuedCaster, target, metadata) 
		emit_signal("actionExecuted", queuedAction)

func consumeItem(queuedItem, queuedCaster, queuedTargets):
	clearSelections()
	var itemResource = queuedItem[0]
	var charges = queuedItem[1]
	queuedItem[1] = charges-1
	var itemExecution = itemResource.get_execution_name()
	var metadata = {}
	for target in queuedTargets: 
		yield(get_tree().create_timer(0.3), "timeout")
		itemExecutions.call(itemExecution, queuedCaster, target, metadata) #potential for metadata
		emit_signal("actionExecuted", itemResource)
	

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


signal menuOptionsPopped()
func clearSelections():
	caster = null
	action = null
	targets = null
	item = null
	covenant = null 
	multiTargets = []
	while menuOptions.size() > 0:
		popMenuOption()
		yield(get_tree().create_timer(0.1), "timeout")


func popMenuOption():
	individualMenuTimer = 0
	menuOptions.pop_back()
	emit_signal("menuOptionsPopped")


func getActors(): 
	return battleEntity.party + battleEntity.enemies


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
	caster = memberEntity
	appendMenuOptions(memberEntity.soul.options, memberEntity.soul.name)


signal menuOptionsAppended(options, title, caster)
func appendMenuOptions(initOptions, title):
	individualMenuTimer = 0 
	var unfilteredOptions = initOptions.duplicate()
	
	var options = []
	for option in unfilteredOptions:
		if option is Array and option[0] is Item:
			if option[1] > 0:
				options.append(option)
		elif option is Covenant and caster:
			if caster.covenants.get(option.covenantKey, CovenantState.INACTIVE) != CovenantState.BROKEN:
				options.append(option)
		else:
			options.append(option)

	if  caster.getEmotionValue(EmotionKey.DOUBT) * 0.1 > randf():
		doubtOptions = options
		doubtName = name
		options = DOUBT_OPTIONS
		title = "Are you sure?"	
	if caster.getEmotionValue(EmotionKey.CONFUSION) * 0.1 > randf():
		options.shuffle()
	menuOptions.append(options)
	emit_signal("menuOptionsAppended", options, title, caster)


func onOptionPressed(id):
	var option = menuOptions.back()[id]
	if option is Action:
		action = option
		if option.targetType == TargetType.AOE:
			appendMenuOptions([battleEntity.enemies, battleEntity.party], "Target")
		elif option.targetType == TargetType.SINGLE or option.targetType == TargetType.MULTI:
			appendMenuOptions(getActors(), "Target")
		elif option.targetType == TargetType.SELF:
			targets = [caster]
		elif option.targetType == TargetType.ALL:
			targets = getActors()
	elif option is Array and option[0] is Item: #item
		item = option
		if item[0].targetType == TargetType.AOE:
			appendMenuOptions([battleEntity.enemies, battleEntity.party], "Target")
		elif item[0].targetType == TargetType.SINGLE or item[0].targetType == TargetType.MULTI:
			appendMenuOptions(getActors(), "Target")
		elif item[0].targetType == TargetType.SELF:
			targets = [caster]
		elif item[0].targetType == TargetType.ALL:
			targets = getActors()
	elif option is Covenant:
		covenant = option
	elif option is Soul: 
		appendMenuOptions(option.options, option.name)	
	elif option is Pocket: 
		appendMenuOptions(option.items, option.name)
	elif option is Option and option.name == "Yes": 
		appendMenuOptions(doubtOptions, doubtName)
	elif option is Option and option.name == "No": 
		clearSelections()
	elif option is Array: 
		targets = option
	elif option is Actor and item != null: # Item Single Target
		targets = [option]
	elif option is Actor and action.targetType != TargetType.MULTI: # Action Single Target
		targets = [option]
	elif action and action.targetType == TargetType.MULTI: 
		multiTargets.append(option)
		if multiTargets.size() >= action.metadata["multihit"]:
			targets = multiTargets
		else: 
			appendMenuOptions(menuOptions.back(), "Target")


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


func selectRandomItem(array: Array):
    if array.empty():
        return null  
    var random_index = randi() % array.size()
    return array[random_index]


signal vowMade()
signal vowStopped()
signal vowBroken()
func toggleCovenant(queuedCovenant, queuedCaster): 
	clearSelections()
	var covenantState = queuedCaster.covenants.get(queuedCovenant.covenantKey, CovenantState.INACTIVE)
	if covenantState == CovenantState.INACTIVE: 
		queuedCaster.covenants[queuedCovenant.covenantKey] = CovenantState.ACTIVE
		emit_signal("vowMade")
	elif covenantState == CovenantState.ACTIVE: 
		queuedCaster.covenants[queuedCovenant.covenantKey] = CovenantState.INACTIVE
		emit_signal("vowStopped")


func checkDecisivenessVow(actor: Resource, queuedCaster: Resource):
	if queuedCaster == null:
		individualMenuTimer = 0
		return
	if queuedCaster == actor:
		individualMenuTimer += TICK
		if individualMenuTimer > 1.0: 
			breakVow(CovenantKey.DECISIVENESS, actor)


func breakCommitmentVow(actor: Resource):
	breakVow(CovenantKey.COMMITMENT, actor)


func breakVitalityVow(actor: Resource):
	breakVow(CovenantKey.VITALITY, actor)
	var staminaLost = -staminaFromVitalityCovenant.get(actor.name, 0)*2
	actor.updateStamina(staminaLost)


func breakVow(covenantKey: int, actor: Resource):
	if actor.covenants.get(covenantKey) != CovenantState.ACTIVE:
		return 
	actor.covenants[covenantKey] = CovenantState.BROKEN
	clearSelections()
	emit_signal("vowBroken")