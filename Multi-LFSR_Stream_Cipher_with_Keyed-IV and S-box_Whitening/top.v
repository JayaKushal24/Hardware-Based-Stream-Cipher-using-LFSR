`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire rst,
    input wire [7:0] key1,
    input wire [7:0] key2,
    input wire [7:0] key3,
    input wire [7:0] iv1,
    input wire [7:0] iv2,
    input wire [7:0] iv3,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    wire fb1,fb2,fb3,bit1,bit2,bit3;
    reg [7:0] LFSR_1_state;
    reg [7:0] LFSR_2_state;
    reg [7:0] LFSR_3_state;
    //primitve ploynomial list weblink   https://www.partow.net/programming/polynomials/index.html#deg08  
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
    
    wire sbox_input={bit1,bit2,bit3};
    reg [2:0]sbox_output;
    always @(*) begin
        case (sbox_input)
            3'b000: sbox_output = 3'b101;
            3'b001: sbox_output = 3'b011;
            3'b010: sbox_output = 3'b110;
            3'b011: sbox_output = 3'b001;
            3'b100: sbox_output = 3'b111;
            3'b101: sbox_output = 3'b000;
            3'b110: sbox_output = 3'b100;
            3'b111: sbox_output = 3'b010;
        endcase
    end
    //if not sbox,then use a random logic for bit1,bit2,bit3 to get one-bit keystream value
    wire keystream=sbox_output[0];//can be set to 0,1,2
    reg [2:0] bit_count = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            LFSR_1_state<=key1^iv1;
            LFSR_2_state<=key2^iv2;
            LFSR_3_state<=key3^iv3;
        end 
        else begin
            LFSR_1_state<={fb1,LFSR_1_state[7:1]};
            LFSR_2_state<={fb2,LFSR_2_state[7:1]};
            LFSR_3_state<={fb3,LFSR_3_state[7:1]};
            if (bit_count < 8) begin
                data_out[bit_count]<=data_in[bit_count] ^ keystream;
                bit_count<=bit_count+1;
            end
        end
    end

endmodule
