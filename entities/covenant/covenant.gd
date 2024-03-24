class_name Covenant extends Option

enum CovenantKey {
    COMMITMENT, 
    DECISIVENESS, 
    VITALITY,
}

export (CovenantKey) var covenantKey
export (String) var vow
export (String) var reward
export (String) var punishment
