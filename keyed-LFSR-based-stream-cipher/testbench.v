`timescale 1ns / 1ps

module testbench;

    reg clk=0;
    reg rst=1;

    wire lfsr_bit;
    wire [7:0]lfsr_state;

    reg [7:0]original_data=8'b10101011;
    reg [7:0]encrypted_data=8'b0;
    reg [7:0]decrypted_data=8'b0;
    reg [7:0] key = 8'b11000011;//encryption key..only the sender and receiver has it.

    integer i;
    top dut (  .clk(clk),  .rst(rst),  .lfsr_bit(lfsr_bit),    .state(lfsr_state) ,     .key(key) );
    always #5 clk = ~clk;

    initial begin
        $display("Time\tOriginal Data\tLFSR_state\tEncrypted data\tDecrypted data");
        $monitor("%0t\t%b\t\t%b\t\t%b\t%b", $time, original_data,lfsr_state,encrypted_data,decrypted_data);
        #10 rst=0;
     
        for (i=0;i<8;i=i+1) begin
            #10 encrypted_data[i]=original_data[i] ^ lfsr_bit;//encryption
        end
        $display("Encryption done");
        #10 rst=1;
        #10 rst=0;
        for (i=0;i<8;i=i+1) begin
            #10 decrypted_data[i]=encrypted_data[i] ^ lfsr_bit;//decryption
        end
        $display("Decryption done");
        
        $display("\nFinal Result:");
        $display("Key: %b",key);
        $display("original_data: %b",original_data);
        $display("encrypted_data: %b",encrypted_data);
        $display("Decrypted_data : %b",decrypted_data);

        if (original_data == decrypted_data)    $display("Decryption Successful");
        else                                    $display("Decryption Failed");

        #10 $finish;
    end

endmodule
