`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ram Tripathi 
// Create Date: 08/05/2025 06:47:18 PM
// Design Name: 
// Module Name: full_adder
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

module half_adder(
    input x,y,
    output c,s
    );
   
   assign s = x ^ y;
   assign c = x & y;


endmodule       





module full_adder(
    input x,y,c_in,
    output s, c_out
    );
    
    wire c1, s1, c2;
    
    half_adder HA0 (
        .x(x),
        .y(y),
        .c(c1),
        .s(s1)
       
    );
    
    half_adder HA1 (
        .x(c_in),
        .y(s1), 
        .c(c2), 
        .s(s)
    
    );


assign c_out = c1 | c2;
   
endmodule
