pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/switcher.circom";

// ─────────────────────────────────────────────────────────────────────────────
// MerkleProof – depth-agnostic, Poseidon(2) nodes
// ─────────────────────────────────────────────────────────────────────────────
template MerkleProof(depth) {
    signal input leaf;
    signal input pathElements[depth];
    signal input pathIndices[depth];
    signal output root;

    component hashers[depth];
    component switchers[depth];
    signal levelHashes[depth + 1];
    levelHashes[0] <== leaf;

    for (var i = 0; i < depth; i++) {
        switchers[i] = Switcher();
        switchers[i].sel <== pathIndices[i];
        switchers[i].L   <== levelHashes[i];
        switchers[i].R   <== pathElements[i];

        hashers[i] = Poseidon(2);
        hashers[i].inputs[0] <== switchers[i].outL;
        hashers[i].inputs[1] <== switchers[i].outR;

        levelHashes[i + 1] <== hashers[i].out;
    }

    root <== levelHashes[depth];
}
