extends Node

const battleEntity: Battle = preload("res://entities/battle/testBattle.tres")
const Container = preload("res://features/battle/visual/Container.tscn");

func _ready():
	var container = Container.instance().setup(battleEntity, self);
	add_child(container)


const TargetType = preload("res://entities/action/action.gd").TargetType
var actionExections = preload("res://entities/action/actionExecutions.gd").new()
var menuOptions = []
var caster
var action
var targets
const TICK = .06 #15ish ticks per second
var timer: float = 0
func _process(delta):
	timer += delta
	if (timer < TICK):
		return
	timer = 0

	#for action in memberEntity.actions:
	#	var actionExecution = action.get_execution_name()
		# spawn a menu
		#actionExections.call(actionExecution, battleEntity, memberEntity, [memberEntity]) # update to actual targets

	for actor in getActors():
		actor.setStamina(actor.getStamina()+actor.staminaRegenRate)
		if (actor.getTickingHealth() > 0):
			actor.tickHealth()

func getActors(): 
	return battleEntity.party + battleEntity.enemies

signal menuOptionsAppended()
func appendMenuOptions(folder):
	menuOptions.append(folder)
	emit_signal("menuOptionsAppended")

func _on_action_pressed(id):
	var option = menuOptions.back().options[id]
	if option is Action:
		if option.targetType == TargetType.SELF:
			targets = [caster]
		elif option.targetType == TargetType.ALL:
			targets = getActors()
		else: # AOE or SINGLE
			# open a target menu 
			pass
	if option is Folder: 
		appendMenuOptions(option)
		
