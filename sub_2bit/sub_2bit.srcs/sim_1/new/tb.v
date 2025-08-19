`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2025 02:21:10 PM
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
    reg [1:0] A,B;
    wire [1:0] D;
    wire Borrow;
    sub_2bit uut (.A(A), .B(B), .D(D), .Borrow(Borrow));
    initial begin 
      $monitor("A=%b, B=%b, => D=%d, Borrow=%b ", A,B,D,Borrow);
      A=2'b00; B=2'b00; #10;
      A=2'b01; B=2'b01; #10;
      A=2'b10; B=2'b01; #10;
      A=2'b11; B=2'b10; #10;
      A=2'b01; B=2'b11; #10;
      A=2'b00; B=2'b10; #10;
      $stop;
    end
endmodule
