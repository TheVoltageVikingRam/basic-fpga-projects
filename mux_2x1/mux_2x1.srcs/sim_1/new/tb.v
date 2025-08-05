`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/05/2025 11:33:54 PM
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
reg I0;
reg I1;
reg S;

wire Y;


mux_2x1 dut (
    .I0(I0),
    .I1(I1),
    .S(S),
    .Y(Y)
);


initial begin
//Test case 1
$monitor("Time = %0t | I0 = %b | I1 = %b | S = %b | Y = %b", $time, I0, I1, S, Y);
I0 =0; I1=0; S=0;
#10;

I0=0; I1=1; S=0;
#10;

I0=1; I1=0; S=0;
#10;

I0=1; I1=1; S=0;
#10;

I0=0; I1=0; S=1;
#10;

I0=0; I1=1; S=1;
#10;

I0=1; I1=0; S=1;
#10;

I0=1; I1=1; S=1;
#10;


end
endmodule
