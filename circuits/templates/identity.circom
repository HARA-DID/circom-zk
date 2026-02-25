pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";

// ─────────────────────────────────────────────────────────────────────────────
// IdentityBinding – Poseidon(identitySecret) === publicCommitment
// ─────────────────────────────────────────────────────────────────────────────
template IdentityBinding() {
    signal input secret;
    signal input commitment;

    component hasher = Poseidon(1);
    hasher.inputs[0] <== secret;
    hasher.out === commitment;
}
