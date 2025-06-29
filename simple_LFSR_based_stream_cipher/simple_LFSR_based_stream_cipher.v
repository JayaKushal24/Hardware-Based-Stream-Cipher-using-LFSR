`timescale 1ns / 1ps

module simple_LFSR_based_stream_cipher(
    input wire clk,
    input wire rst,
    output wire lfsr_bit,
    output reg [7:0] state
);
    wire feedback;
    //polynomical chosen is x^8+ x^6 + x^5 + x^4 + 1...2^8-1 cycles =255 cycles
    //tap terms  are x^6 x^5 x^4 and x^0
    assign feedback = state[6]^state[5]^state[4]^state[0]; // taps

    assign lfsr_bit = state[7];

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= 8'b0000_0001; //seed value
        else
            state <= {feedback,state[7:1]};
    end
endmodule
