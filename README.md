# 🔐 Multi-LFSR Stream Cipher with Keyed IV and S-Box Whitening


Built a stream cipher from scratch using Verilog. LFSRs provided pseudorandomness, keyed IVs ensured unique keystreams across sessions, and the S-Box added nonlinearity for stronger security. A great hands-on experience in RTL design and hardware cryptography.

## ✨ Key Techniques

🌀 **Multiple LFSRs for Enhanced Security**  
Three LFSRs increase the keystream period and complexity. Their parallel operation and combination make the internal state space exponentially harder to predict or reverse-engineer, protecting against brute-force and correlation attacks.

🔑 **Keyed IV Initialization**  
Even if the same secret key is reused, the inclusion of public 8-bit Initialization Vectors (IVs) ensures that the starting states of the LFSRs are unique for every session. This prevents keystream reuse and defends against known-plaintext and replay attacks.

🧠 **Nonlinear S-Box Whitening**  
The 3-bit output formed by the MSBs of the LFSRs is passed through a small custom S-Box. This introduces **confusion**, breaking any linear relation between LFSR output and keystream, boosting resistance to algebraic and statistical attacks.

## 📁 Folder Structure & Progression

| Folder | Description |
|--------|-------------|
| `simple_LFSR_based_stream_cipher` | Basic single LFSR with fixed taps; generated raw keystream |
| `keyed-LFSR-based-stream-cipher` | Added key input and XORs it with an IV for initialization |
| `Multi_LFSR-cipher` | Introduced 3 parallel LFSRs and combined their MSBs |
| `Multi-LFSR_Stream_Cipher_with_Keyed-IV_and_SBox` | Final version with S-Box for nonlinear whitening and bitwise encryption/decryption |



## ⚙️ Final Design Features

- **3 independent 8-bit LFSRs**
- **Polynomial configurations**: [Primitive Polynomial List](https://www.partow.net/programming/polynomials/index.html#deg08)
  - `LFSR1`: x^8 + x^6 + x^5 + x^4 + 1 (taps: 6, 5, 4, 0)
  - `LFSR2`: x^8 + x^7 + x^2 + x^1 + 1 (taps: 7, 2, 1, 0)
  - `LFSR3`: x^8 + x^4 + x^3 + x^2 + 1 (taps: 4, 3, 1, 0)
- **Keyed IV Initialization**: each LFSR is seeded with `key ^ IV`
- **S-Box Whitening**:
  - MSBs from each LFSR form a 3-bit address to a custom S-Box
  - The output is used as a 1-bit keystream
- **Bit-serial operation**: encrypts or decrypts one bit per clock cycle
- **8-bit message width**: encrypts full byte in 8 cycles

## 🔄 How It Works

1. On `rst`, LFSRs are initialized with `key ^ IV`.
2. Each clock cycle:
   - LFSRs shift based on their feedback logic.
   - MSBs of all 3 LFSRs are passed to a 3-bit S-Box.
   - 1-bit keystream is generated from S-Box output.
   - One bit of `data_in` is XORed with the keystream to form `data_out`.

Running this process for 8 cycles encrypts/decrypts 1 byte.
