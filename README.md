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

## Compilation

The project uses the `circom2` npm package, which allows you to compile circuits without needing to install the Rust-based compiler manually.

To compile the `selective_disclosure.circom` circuit:

```bash
npm run compile
```

This will generate:

- `selective_disclosure.r1cs`: The rank-1 constraint system.
- `selective_disclosure_js/`: A directory containing the WASM witness generator.
- `selective_disclosure.sym`: A symbols file for debugging.

## ZK Workflow (SnarkJS)

After compilation, you can proceed with the trusted setup and proof generation.

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
