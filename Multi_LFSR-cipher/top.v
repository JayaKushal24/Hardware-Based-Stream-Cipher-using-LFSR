`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire rst,
    input wire [7:0] key1,
    input wire [7:0] key2,
    input wire [7:0] key3,
    output wire keystream,
    output reg [7:0] LFSR_1_state,
    output reg [7:0] LFSR_2_state,
    output reg [7:0] LFSR_3_state
);
    wire fb1,fb2,fb3,bit1,bit2,bit3;
    
    // LFSR1: x^8 + x^6 + x^5 + x^4 + 1
    //tap terms are x^6 + x^5 + x^4 + x^0
    assign fb1=LFSR_1_state[6] ^ LFSR_1_state[5] ^ LFSR_1_state[4] ^ LFSR_1_state[0];
    assign bit1=LFSR_1_state[7];

    // LFSR2: x^8 + x^7 + x^2 + x + 1
    //tap terms are x^7 + x^2 + x^1 + x^0
    assign fb2=LFSR_2_state[7] ^ LFSR_2_state[2] ^ LFSR_2_state[1] ^ LFSR_2_state[0];
    assign bit2=LFSR_2_state[7];

    //LFSR3: x^8 + x^4 + x^3 + x + 1
    //tap terms are x^4 + x^3 + x^1 + x^0
    assign fb3=LFSR_3_state[4] ^ LFSR_3_state[3] ^ LFSR_3_state[1] ^ LFSR_3_state[0];
    assign bit3=LFSR_3_state[7];

    assign keystream=(bit1 & bit2)^bit3;//nonlinear combination..this logic can be changed
    //in A5/1 majority logic is used,3 LFSRs of different lengths 19,22 and 23 bits
    //majority= (a&b)|(a&c)|(b&c);
    
    //primitve ploynomial list weblink   https://www.partow.net/programming/polynomials/index.html#deg08

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            LFSR_1_state<=key1;
            LFSR_2_state<=key2;
            LFSR_3_state<=key3;
        end else begin
            LFSR_1_state<={fb1,LFSR_1_state[7:1]};
            LFSR_2_state<={fb2,LFSR_2_state[7:1]};
            LFSR_3_state<={fb3,LFSR_3_state[7:1]};
        end
    end

endmodule
