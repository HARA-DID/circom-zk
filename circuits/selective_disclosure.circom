pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
include "templates/identity.circom";
include "templates/merkle.circom";
include "templates/disclosure.circom";

// ─────────────────────────────────────────────────────────────────────────────
// SelectiveDisclosure – main circuit (Modular Version)
// ─────────────────────────────────────────────────────────────────────────────
template SelectiveDisclosure() {

    // ── Private inputs ───────────────────────────────────────────────────────
    signal input typ;
    signal input value;
    signal input salt;
    signal input pathElements[8];
    signal input pathIndices[8];
    signal input identitySecret;

    // ── Public inputs ────────────────────────────────────────────────────────
    signal input key;
    signal input credentialRoot;
    signal input publicCommitment;
    signal input threshold;
    signal input expectedValueHash;

    // 1. IDENTITY BINDING
    component identity = IdentityBinding();
    identity.secret <== identitySecret;
    identity.commitment <== publicCommitment;

    // 2. LEAF CONSTRUCTION
    component leafHasher = Poseidon(4);
    leafHasher.inputs[0] <== key;
    leafHasher.inputs[1] <== typ;
    leafHasher.inputs[2] <== value;
    leafHasher.inputs[3] <== salt;

    // 3. MERKLE ROOT VERIFICATION
    component merkle = MerkleProof(8);
    merkle.leaf <== leafHasher.out;
    for (var i = 0; i < 8; i++) {
        merkle.pathElements[i] <== pathElements[i];
        merkle.pathIndices[i]  <== pathIndices[i];
    }
    merkle.root === credentialRoot;

    // 4. DISCLOSURE LOGIC (Numeric vs Hash)
    component disclosure = DisclosureLogic();
    disclosure.typ <== typ;
    disclosure.value <== value;
    disclosure.threshold <== threshold;
    disclosure.expectedValueHash <== expectedValueHash;
}

component main {public [key, credentialRoot, publicCommitment, threshold, expectedValueHash]} = SelectiveDisclosure();
