// For the simple example (main.nr)
pub global TEST_INPUT_SHORT: str<12> = "The quick br";
pub global TEST_BASE64_ENCODED_SHORT: str<16> = "VGhlIHF1aWNrIGJy";

pub global TEST_INPUT_LONG: str<88> = "The quick brown fox jumps over the lazy dog, while 42 ravens perch atop a rusty mailbox.";
pub global TEST_BASE64_ENCODED_LONG: str<120> = "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZywgd2hpbGUgNDIgcmF2ZW5zIHBlcmNoIGF0b3AgYSBydXN0eSBtYWlsYm94Lg==";

// For the batch/roundtrip example (batch_roundtrip.nr)
pub global BATCH_INPUTS: [str<12>; 3] = [
    "The quick br",
    "own fox jump",
    "s over lazy "
];