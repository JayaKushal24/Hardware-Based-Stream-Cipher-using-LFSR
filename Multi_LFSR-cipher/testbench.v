`timescale 1ns / 1ps

module testbench;

    reg clk=0;
    reg rst=1;

    wire keystream;
    wire [7:0]LFSR_1_state,LFSR_2_state,LFSR_3_state;

    reg [7:0]original_data=8'b10101011;
    reg [7:0]encrypted_data=8'b0;
    reg [7:0]decrypted_data=8'b0;

    reg [7:0]key1=8'b11000011;
    reg [7:0]key2=8'b10111001;
    reg [7:0]key3=8'b11100110;

    integer i;

    top dut (   .clk(clk),  .rst(rst),  .key1(key1),    .key2(key2),    .key3(key3),    .keystream(keystream),
                .LFSR_1_state(LFSR_1_state),    .LFSR_2_state(LFSR_2_state),    .LFSR_3_state(LFSR_3_state)         );

    always #5 clk = ~clk;

    initial begin
        $display("Time\tOriginal Data\tKeystream\tEncrypted\tDecrypted");
        $monitor("%0t\t%b\t\t%b\t\t%b\t%b",$time,original_data,keystream,encrypted_data,decrypted_data);
        #10 rst=0;

       
        for (i=0;i<8;i=i+1) begin
            #10 encrypted_data[i]=original_data[i] ^ keystream; //encryption
        end
        $display("Encryption done");
        #10 rst=1;
        #10 rst=0;
        for (i=0;i<8;i=i+1) begin
            #10 decrypted_data[i]=encrypted_data[i] ^ keystream; //decryption
        end
        $display("Decryption done");
        

        $display("\nFinal Result:");
        $display("Key1: %b", key1);
        $display("Key2: %b", key2);
        $display("Key3: %b", key3);
        $display("Original Data : %b", original_data);
        $display("Encrypted Data: %b", encrypted_data);
        $display("Decrypted Data: %b", decrypted_data);

        if (original_data == decrypted_data)    $display("Decryption Successful");
        else                                    $display("Decryption Failed");

        #10 $finish;
    end

endmodule
