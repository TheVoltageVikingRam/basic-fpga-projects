`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 02:12:30 PM
// Design Name: 
// Module Name: sub_2bit
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


module sub_2bit(
    input [1:0] A,
    input [1:0] B,
    output [1:0] D,  
    output Borrow
    );

    wire b1; //Borrow between LSB and MSB
    
    assign D[0] = A[0] ^ B[0];
    assign b1 = (~A[0] & B[0]);
    assign D[1] = A[1] ^ B[1] ^ b1;
    assign Borrow = (~A[1] & B[1]) | ((~(A[1] ^ B[1])) & b1);
    
  
endmodule