mod batch_roundtrip;
mod test_inputs;
use noir_base64;

// === Uncomment ONLY ONE block ===

// --- SHORT INPUT ---
//comptime global TEST_INPUT: str<12> = test_inputs::TEST_INPUT_SHORT;
//comptime global TEST_BASE64_ENCODED: str<16> = test_inputs::TEST_BASE64_ENCODED_SHORT;

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