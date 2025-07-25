# Noir Base64 Example

This example demonstrates how to use the `noir_base64` library in Noir to encode and decode base64 strings, with explicit support for short and long test cases.  
The project is updated for Noir `1.0.0-beta.6` and uses only the `noir_base64` library.

## Prerequisites

- [Noir](https://noir-lang.org/) `>=1.0.0-beta.6`
- [nargo](https://noir-lang.org/docs/getting_started/nargo/)
- Git

## Setup

1. **Clone the repo** (if not already):

   ```sh
   git clone https://github.com/noir-lang/noir-examples.git
   cd noir-examples/lib_examples/base64_example
   ```

2. **Install dependencies**  
   Ensure your `Nargo.toml` includes the following:

   ```toml
   [dependencies]
   noir_base64 = { tag = "v0.4.2", git = "https://github.com/noir-lang/noir_base64.git" }
   ```

3. **Test inputs**  
   The `src/test_inputs.nr` file should contain:

   ```noir
   pub const TEST_INPUT_SHORT: str<12> = "The quick br";
   pub const TEST_BASE64_ENCODED_SHORT: str<16> = "VGhlIHF1aWNrIGJy";

   pub const TEST_INPUT_LONG: str<88> = "The quick brown fox jumps over the lazy dog, while 42 ravens perch atop a rusty mailbox.";
   pub const TEST_BASE64_ENCODED_LONG: str<120> = "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZywgd2hpbGUgNDIgcmF2ZW5zIHBlcmNoIGF0b3AgYSBydXN0eSBtYWlsYm94Lg==";

   pub const BATCH_INPUTS: [str<12>; 3] = [
       "The quick br",
       "own fox jump",
       "s over lazy "
   ];
   ```

## How to Select Input Length

Noir currently requires you to **explicitly set the input length at compile time**.  
This is done by commenting or uncommenting the relevant lines in `src/main.nr`.

### 1. **Edit `src/main.nr` to select SHORT or LONG input**

Open `src/main.nr` and **uncomment only one block** as shown below:

```noir
mod test_inputs;
use noir_base64;

// === Uncomment ONLY ONE block ===

// --- SHORT INPUT ---
// comptime global TEST_INPUT: str<12> = test_inputs::TEST_INPUT_SHORT;
// comptime global TEST_BASE64_ENCODED: str<16> = test_inputs::TEST_BASE64_ENCODED_SHORT;

// --- LONG INPUT ---
comptime global TEST_INPUT: str<88> = test_inputs::TEST_INPUT_LONG;
comptime global TEST_BASE64_ENCODED: str<120> = test_inputs::TEST_BASE64_ENCODED_LONG;

// === END selection ===

comptime global U: u32 = comptime { TEST_INPUT.as_bytes().len() };
comptime global B: u32 = comptime {
    let mut q = U / 3;
    let r = U - q * 3;
    if (r > 0) { q += 1; }
    q * 4
};

pub global ENCODE_RUNS: u32 = 3;
pub global DECODE_RUNS: u32 = 0;

fn main(input: str<U>, base64_encoded: str<B>) {
    for _ in 0..ENCODE_RUNS {
        let _encoded: [u8; B] = noir_base64::BASE64_ENCODER::encode(input.as_bytes());
    }
    for _ in 0..DECODE_RUNS {
        let _decoded: [u8; U] = noir_base64::BASE64_DECODER::decode(base64_encoded.as_bytes());
    }
}

#[test]
fn test() {
    main(TEST_INPUT, TEST_BASE64_ENCODED);
}
```

- **To use SHORT input:**  
  Uncomment the SHORT block, comment the LONG block.
- **To use LONG input:**  
  Uncomment the LONG block, comment the SHORT block.

> **You cannot use both at the same time. You must recompile when you switch.**

---

## Input Files for Execution

### About Prover TOML files

When running your Noir circuit with `nargo execute`, you must provide input values that match the compile-time string lengths you configured above.

- By default, `nargo execute` uses the file `Prover.toml` in your project directory.
- You can also specify a different input file with the `-p` flag, e.g. `nargo execute -p Prover_SHORT.toml`.

### What should your input TOML files contain?

**The TOML file must exactly match the types and lengths set in your `main.nr`.**

#### If using SHORT input (short block uncommented):
```toml name=Prover.toml
base64_encoded = "VGhlIHF1aWNrIGJy"
input = "The quick br"
```

#### If using LONG input (long block uncommented):
```toml name=Prover.toml
base64_encoded = "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZywgd2hpbGUgNDIgcmF2ZW5zIHBlcmNoIGF0b3AgYSBydXN0eSBtYWlsYm94Lg=="
input = "The quick brown fox jumps over the lazy dog, while 42 ravens perch atop a rusty mailbox."
```

**You can also create `Prover_SHORT.toml` and `Prover_LONG.toml` as convenience files with the same contents as above, and use `-p` to select them.**

---

## How to Compile and Run

### 1. **Compile the circuit**

```sh
nargo compile
```

### 2. **Run with the matching Prover TOML**

- With default `Prover.toml`:
  ```sh
  nargo execute
  ```
- Or, with a specific file:
  ```sh
  nargo execute -p Prover_SHORT.toml
  ```
  or
  ```sh
  nargo execute -p Prover_LONG.toml
  ```

**Always ensure that the uncommented block in `main.nr` matches your selected input file!**

---

## Batch Round-trip Test

The batch round-trip test (in `src/batch_roundtrip.nr`) is run as a Noir unit test and does not require a TOML file for execution.  
To run all project tests (including batch roundtrip):

```sh
nargo test
```

This will execute all `[test]` functions, including the batch roundtrip test, using the hardcoded data in `test_inputs.nr`.

---

## Troubleshooting

- **Type errors about string length:**  
  Double-check that only the correct input block is uncommented and your TOML matches the lengths.
- **For batch tests, ensure batch input and string length constants are correct and match your test data.**
- **If `nargo execute` fails:**  
  Check that the `Prover.toml` (or file passed with `-p`) matches the types and lengths in your current `main.nr` configuration.

---

## References

- [noir_base64 library](https://github.com/noir-lang/noir_base64)
- [base64_example](https://github.com/noir-lang/noir-examples/tree/master/lib_examples/base64_example)
