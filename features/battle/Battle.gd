extends PanelContainer

const TICK = 1
var battleEntity: Battle
const memberHudScene = preload("res://features/battle/visual/MemberHud.tscn");
const enemyHudScene = preload("res://features/battle/visual/EnemyHud.tscn");
var timer: float = 0

func _ready():
	if !battleEntity:
		battleEntity = preload("res://entities/battle/testBattle.tres")

	var partyBarNode = $BattleContainer/PartyBar
	for member in battleEntity.party:
		var memberHud = memberHudScene.instance()
		memberHud.memberEntity = member
		partyBarNode.add_child(memberHud);
	
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
			actor.setTickingHealth(actor.getTickingHealth()-1);
			actor.setHealth(actor.getHealth()-1);
			
	timer = 0
	
