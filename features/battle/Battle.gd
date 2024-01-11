extends PanelContainer

const TICK = 1
var battleEntity: Battle
var memberHudScene = preload("res://features/battle/MemberHud.tscn");
var timer: float = 0

func _ready():
	if !battleEntity:
		battleEntity = preload("res://entities/battle/testBattle.tres")

	var partyBarNode = get_node("BattleContainer/PartyBar")
	for member in battleEntity.party:
		var memberHud = memberHudScene.instance()
		memberHud.memberEntity = member
		partyBarNode.add_child(memberHud);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if (timer < TICK):
		return
	
	for member in battleEntity.party:
		member.setStamina(member.getStamina()+1)
		member.setHealth(member.getHealth()-1)
		member.setMagic(member.getMagic()*2)

	timer = 0
	
