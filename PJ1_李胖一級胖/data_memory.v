module Data_Memory(
	clk_i,
	data1_i,        //addr                
    data2_i,       
    Mem_Read_i,
    Mem_Write_i,
    data_o  
);

input			clk_i;
input	[31:0]	data1_i;
input	[31:0]	data2_i;
input 	Mem_Read_i;
input 	Mem_Write_i;
output 	[31:0]	data_o;

reg     [31:0]  data_o;
reg     [7:0]   memory  [0:31];  //debug
//不知道怎麼存memory

always @(data1_i or data2_i or Mem_Read_i or Mem_Write_i) begin
	if (Mem_Write_i)
		memory[data1_i] <= data2_i; 
	if (Mem_Read_i)
		data_o <= memory[data1_i];
	else 
		data_o <= 0;
end


endmodule