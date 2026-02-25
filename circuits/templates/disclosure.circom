pragma circom 2.1.6;

include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/comparators.circom";

// ─────────────────────────────────────────────────────────────────────────────
// IsNumericType – 1 iff typ ∈ {2, 3}
// ─────────────────────────────────────────────────────────────────────────────
template IsNumericType() {
    signal input typ;
    signal output out;

    component eq2 = IsEqual();
    eq2.in[0] <== typ;
    eq2.in[1] <== 2;

    component eq3 = IsEqual();
    eq3.in[0] <== typ;
    eq3.in[1] <== 3;

    // Boolean OR: a + b - a*b  (safe: they can't both be 1)
    out <== eq2.out + eq3.out - eq2.out * eq3.out;
}

// ─────────────────────────────────────────────────────────────────────────────
// DisclosureLogic – Numeric comparison or hash equality
// ─────────────────────────────────────────────────────────────────────────────
template DisclosureLogic() {
    signal input typ;
    signal input value;
    signal input threshold;
    signal input expectedValueHash;

    component typeCheck = IsNumericType();
    typeCheck.typ <== typ;
    signal isNumeric <== typeCheck.out;

    // ── Numeric Check (Value >= Threshold) ──────────────────────────────────
    // Use 252 bits to safely cover field elements and prevent overflow.
    // Mask inputs with isNumeric to ensure comparator always sees valid data.
    signal maskedValue <== isNumeric * value;
    signal maskedThreshold <== isNumeric * threshold;

    component gte = GreaterEqThan(252);
    gte.in[0] <== maskedValue;
    gte.in[1] <== maskedThreshold;

    // Enforce: IF isNumeric THEN gte.out must be 1
    isNumeric * (1 - gte.out) === 0;

    // ── Hash Equality Check (Poseidon(value) === expectedValueHash) ──────────
    component valueHasher = Poseidon(1);
    valueHasher.inputs[0] <== value;

    signal hashDiff <== valueHasher.out - expectedValueHash;

    // Enforce: IF NOT isNumeric THEN hashDiff must be 0
    (1 - isNumeric) * hashDiff === 0;
}
