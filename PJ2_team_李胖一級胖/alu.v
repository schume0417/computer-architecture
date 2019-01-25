`timescale 1 ns/ 1 ns

module ALU 
(
	data1_i, 
	data2_i, 
	ALUCtrl_i, 
	data_o, 
	Zero_o
);

input [31:0] data1_i, data2_i;
input [3:0] ALUCtrl_i;
output [31:0] data_o;
output Zero_o;

reg [32:0] temp;
assign data_o = temp[31:0];
assign Zero_o = temp[32];

/* implement here */
always@ (data1_i or data2_i or ALUCtrl_i) begin
	if (ALUCtrl_i == 4'b0001) 
		temp = data1_i - data2_i;  //sub
	else if (ALUCtrl_i == 4'b0010)
		temp = data1_i & data2_i;  //and
	else if (ALUCtrl_i == 4'b0011)
		temp = data1_i | data2_i;  //or
	else if (ALUCtrl_i == 4'b0000)
		temp = data1_i + data2_i;  //addi
	else if (ALUCtrl_i == 4'b0100)
		temp = data1_i * data2_i;  //mul
	else if (ALUCtrl_i == 4'b1000)
		temp = data1_i + data2_i;  //add
	else if (ALUCtrl_i == 4'b0110)
		temp = data1_i + data2_i;  //sw
	else if (ALUCtrl_i == 4'b0101)
		temp = data1_i + data2_i;//lw
	else
		temp = 32'bx;
end
endmodule
