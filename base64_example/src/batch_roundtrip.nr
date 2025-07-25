use noir_base64;
use crate::test_inputs::BATCH_INPUTS;

// --------- Batch Round-trip Base64 Example ---------
// This circuit encodes and decodes several input strings and asserts round-trip correctness.

comptime global BATCH_SIZE: u32 = 3;
comptime global STR_LEN: u32 = 12;      // Each input string is 12 chars for simplicity
comptime global BASE64_LEN: u32 = 16;   // 12 bytes base64-encode to 16 chars

fn encode_and_decode(input: str<STR_LEN>) {
    let encoded: [u8; BASE64_LEN] = noir_base64::BASE64_ENCODER::encode(input.as_bytes());
    let decoded: [u8; STR_LEN] = noir_base64::BASE64_DECODER::decode(encoded);

    assert(input.as_bytes() == decoded);
}

fn main(inputs: [str<STR_LEN>; BATCH_SIZE]) {
    for i in 0..BATCH_SIZE {
        encode_and_decode(inputs[i]);
    }
}

#[test]
fn test_batch_roundtrip() {
    main(BATCH_INPUTS);
}