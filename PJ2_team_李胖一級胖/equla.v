module Equal
(
    data1_i,
    data2_i,
    operation_i,
    data_o
);

input	[31:0]	data1_i;
input	[31:0]	data2_i;
output			data_o;

reg				data_o;
reg				temp_data_o;
input	[3:0]	operation_i;



always@ (*) begin
	temp_data_o = 1'b0;
	if (data1_i == data2_i && operation_i == 4'b0111) 
		temp_data_o = 1'b1;  
	else 
		temp_data_o = 1'b0;
	data_o = temp_data_o;
end
//assign  data_o = temp_data_o;
endmodule




