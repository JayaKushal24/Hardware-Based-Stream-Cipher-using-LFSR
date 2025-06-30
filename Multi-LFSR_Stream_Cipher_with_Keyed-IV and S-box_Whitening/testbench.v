`timescale 1ns / 1ps

module tb_top;

    reg clk=0;
    reg rst;

    reg [7:0] key1=8'b10101010;
    reg [7:0] key2=8'b11001100;
    reg [7:0] key3=8'b11110000;
    reg [7:0] iv1=8'b00001111;
    reg [7:0] iv2=8'b00110011;
    reg [7:0] iv3=8'b01010101;
    reg [7:0] original_data=8'b10100101;
    reg [7:0] encrypted_data;
    reg [7:0] decrypted_data;
    reg [7:0] data_in;
    wire [7:0] data_out;

    top uut (   .clk(clk),  .rst(rst),  .key1(key1),    .key2(key2),    .key3(key3),    .iv1(iv1),  
                .iv2(iv2),  .iv3(iv3),  .data_in(data_in),              .data_out(data_out)     );

    always #5 clk= ~clk;

    integer i;

    initial begin
        $display("Time\tOriginal\tEncrypted\tDecrypted");
        //encryption
        rst=1; 
        #10 rst=0;
        data_in=original_data;
        #100;
        encrypted_data=data_out;
        $display("%0t\t%b\t%b",$time,original_data,encrypted_data);

        //decryption
        rst=1; 
        #10 rst=0;
        data_in=encrypted_data;
        #100;
        decrypted_data=data_out;
        $display("%0t\t\t\t\t%b\t%b",$time,encrypted_data,decrypted_data);

        $display("\nFinal Check:");
        $display("Original Data : %b",original_data);
        $display("Encrypted Data: %b",encrypted_data);
        $display("Decrypted Data: %b",decrypted_data);

        if (decrypted_data == original_data)     $display("Decryption Successful");
        else                                     $display("Decryption Failed");
        $finish;
    end

endmodule
