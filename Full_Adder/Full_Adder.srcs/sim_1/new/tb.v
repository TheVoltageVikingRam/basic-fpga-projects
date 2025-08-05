`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 06:58:47 PM
// Design Name: 
// Module Name: tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb();


reg x,y,c_in;
wire s, c_out;

full_adder dut (
    .x(x),
    .y(y),
    .c_in(c_in),
    .s(s),
    .c_out(c_out)
);

initial begin
    $display("x y c_in | s c_out");
    $display("-------------------");
    
    x=0; y=0; c_in=0; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);
    
    x=0; y=0; c_in=1; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);


    x=0; y=1; c_in=0; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);

    x=0; y=0; c_in=1; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);

    x=1; y=0; c_in=0; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);
    
    x=1; y=0; c_in=1; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);
    
    x=1; y=1; c_in=0; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);
    
    x=1; y=1; c_in=1; #10;
    $display("%b %b %b | %b %b", x, y, c_in, s, c_out);
    
    $finish;
    
    
end



    
endmodule
