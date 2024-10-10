
sig Node {

}

sig Member in Node {
    nxt: lone Member,
    qnxt : Node -> lone Node,
    outbox: set Msg
}

one sig Leader in Member {
    lnxt: Node -> lone Node
}

sig LQueue in Member {

}

abstract sig Msg {
    sndr: Node,
    rcvrs: set Node
}

sig SentMsg, SendingMsg, PendingMsg extends Msg {}


fact MemberRing {
    /* From one member you can get to all others 
    through the next pointer */
    all m1, m2: Member | m1 in m2.^nxt

    // TODO - without forall?
}

fact LeaderCandidatesAreMembers {
    /* all nodes in the leader queue are members */
    Leader.lnxt.Node in LQueue

    // TODO - how do we relate it to LQueue?
}

fact NoMemberInQueue {
    /* no member is in the queue of another member */
    // all m: Member | no m.qnxt.Member

    all m: Member | no (m.qnxt.Node & Member)

    // (Member.qnxt.Node & Member) ?????
}

fact {
    /* non-member nodes are not allowed to queue in more than one member queue
        at a time. */
    all m1, m2: Member | 
        m1 != m2 => no (m1.qnxt.Node & m2.qnxt.Node)
}

pred nonMembersQueued {
    all n: Node | n !in Member => one m: Member | n in m.qnxt.Node
}

run {#Node=5 && #Member=2 && nonMembersQueued} for 5