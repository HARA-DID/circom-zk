# Circom ZK Project

This project demonstrates a Zero-Knowledge Proof (ZKP) workflow using `circom` and `snarkjs`, managed entirely through `npm`.

## Prerequisites

- [Node.js](https://nodejs.org/) (latest LTS recommended)
- `npm` (usually comes with Node.js)

## Installation

To install the necessary dependencies, including the `circom2` WASM compiler and `snarkjs`, run:

```bash
npm install
```

## Project Structure

The project is organized into modular components for better maintainability and reusability:

- `circuits/`
  - `selective_disclosure.circom`: The main circuit entry point.
  - `templates/`
    - `identity.circom`: Identity binding logic (Poseidon).
    - `merkle.circom`: Merkle proof verification.
    - `disclosure.circom`: Selective disclosure logic (Numeric/Hash).
- `package.json`: Contains dependency definitions and improved modular build scripts.
- `.gitignore`: Ensures large binary artifacts and `node_modules` are not tracked.

## Compilation

To compile the modular circuits, run:

```bash
npm run compile
```

This command enters the `circuits/` directory and compiles `selective_disclosure.circom`, resolving all template includes automatically. It generates:

- `circuits/selective_disclosure.r1cs`
- `circuits/selective_disclosure_js/` (WASM witness generator)
- `circuits/selective_disclosure.sym`

## ZK Workflow (SnarkJS)

After compilation, proceed with the trusted setup. The scripts in `package.json` are pre-configured to handle the file paths in the `circuits/` directory.

### 1. Powers of Tau (Phase 1)

If you don't have a `.ptau` file yet, you can generate one:

```bash
# Start a new ceremony
npm run tau-new

# Contribute to the ceremony
npm run tau-contribute

# Prepare phase 2
npm run tau-prepare
```

This will create `pot12_final.ptau`.

### 2. Phase 2 Setup

Run the setup for your specific circuit:

```bash
npm run setup
```

### 3. Contribute to the Ceremony (Phase 2)

```bash
npm run contribute
```

### 4. Export Verification Key

```bash
npm run export-vkey
```

## Project Structure

- `selective_disclosure.circom`: The main circuit file.
- `package.json`: Contains dependency definitions and handy scripts.
- `.gitignore`: Ensures large binary artifacts and `node_modules` are not tracked by Git.
