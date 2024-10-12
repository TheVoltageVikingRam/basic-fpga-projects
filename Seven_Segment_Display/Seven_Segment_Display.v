//Verilog code for seven segment display
//Define module

module Seven_Segment_Display(
	input [3:0] bcd, //Define all input ports
	output reg [6:0] display
);


//Define always block, this block is exceuted everytime
//the input BCD values change

always @ (bcd) begin
case (bcd)
4'b0000 : display <= 7'b1111110; //output port 'display' is assigned with
//seven segment equivalent of input BCD(0)

4'b0001 : display <= 7'b0110000; //output port 'diplay is assigned with 
//seven segment equivalent of input BCD(1)

4'b0010 : display <= 7'b1101101; //output port 'display' is assigned with
//seven segment equivalent of input BCD(2)

4'b0011: display <= 7'b1111001; // output port 'display' is assigned with
//seven segment equivalent of input BCD(3)

4'b0100: display <= 7'b0110011; //output port 'display' is assigned with
//seven segment equivalent of input BCD(4)

4'b0101: display <= 7'b1011011; //output port 'display' is assigned with
//sevem segment equivalent of input BCD(5)

4'b0110: display <= 7'b1011111; //outout port 'display' is assigned with
//seven segment equivalent of input BCD(6)

4'b0111: display <= 7'b1110000; //output port 'display' is assigned with
//seven segment equivalent of input BCD(7)

4'b1000: display <= 7'b1111111; //output port display is assigned with
//seven segment equivalent of output BCD(8)

4'b1001: display <= 7'b1111011; //output port 'display' is assigned with 
//seven segment equivalent of output BCD(9)

default : display <= 7'b0000000;
endcase //end of case block
end // end of always block

endmodule
