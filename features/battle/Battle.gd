extends Node

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
signal actionExecuted()
func _process(delta):
	timer += delta
	if (timer < TICK):
		return
	timer = 0
	if (caster and action and targets):
		var actionExecution = action.get_execution_name()
		actionExections.call(actionExecution, battleEntity, caster, targets) 
		caster.setStamina(caster.getStamina() - action.staminaCost)
		caster.setMagic(caster.getMagic() - action.magicCost)
		emit_signal("actionExecuted")


	for actor in getActors():
		actor.setStamina(actor.getStamina()+actor.staminaRegenRate)
		if (actor.getTickingHealth() > 0):
			actor.tickHealth()

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
	
