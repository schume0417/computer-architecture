module MUX_PC
(
	data1_i,
	data2_i,
	select_i,
	data_o
);

input	[31:0]		data1_i, data2_i;
input	select_i;
output	[31:0]		data_o;

reg		[31:0]		data_o;

//assign data_o = data1_i; //debug

always @(data1_i or data2_i or select_i) begin
	if (select_i) 
		data_o = data2_i;
	else
		data_o = data1_i;
end

//assign data_o = (select_i == 1'b0)?data1_i:data2_i;   // 0是pc+4

endmodule
