`timescale 1ns / 1ps

module top(
    input clk,
    input rst,
    output lfsr_bit,
    output reg [7:0] state,
    input [7:0] key
);
    wire feedback;
    //polynomical chosen is x^8+ x^6 + x^5 + x^4 + 1...2^8-1 cycles =255 cycles
    //tap terms  are x^6 x^5 x^4 and x^0
    assign feedback = state[6]^state[5]^state[4]^state[0]; // taps

    assign lfsr_bit = state[7];

    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= key; //seed value from user
        else
            state <= {feedback,state[7:1]};
    end
endmodule
