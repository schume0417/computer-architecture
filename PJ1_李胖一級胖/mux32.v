module MUX32(
	data_o,
    data1_i,
    data2_i,
    data3_i,
    select_i
);

input	[31:0]	data1_i;
input	[31:0]	data2_i;   //MEM_WB
input	[31:0]	data3_i;   //EX_MEM
output	[31:0]	data_o;
input	[1:0]	select_i;

reg		[31:0]	tmp_data_o;

always @(select_i or data1_i or data2_i or data3_i) begin

	if (select_i == 2'b10)
		tmp_data_o = data3_i;
	else if (select_i == 2'b01)
		tmp_data_o = data2_i;
	else 
		tmp_data_o = data1_i;

end
assign data_o = tmp_data_o;

endmodule
