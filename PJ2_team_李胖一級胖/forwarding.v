module Forwarding(
    forward_MUX2_o,
    forward_MUX3_o,
    ID_EX_rs_i,
    ID_EX_rt_i,
    EX_MEM_rd_i,
    EX_MEM_wb_i,
    MEM_WB_rd_i,
    MEM_WB_wb_i
);

input	[1:0]	EX_MEM_wb_i; 
input			MEM_WB_wb_i;
input	[4:0]	ID_EX_rs_i, ID_EX_rt_i;      //?
input 	[4:0]	EX_MEM_rd_i, MEM_WB_rd_i;    //?
output	[1:0]	forward_MUX2_o, forward_MUX3_o;

reg		[1:0]	tmp2, tmp3;

always @(*) begin
	tmp2 = 2'b00;
	tmp3 = 2'b00;
	if (EX_MEM_wb_i[0] != 0 && EX_MEM_rd_i != 0 && EX_MEM_rd_i == ID_EX_rs_i)
		tmp2 = 2'b10;
	if (EX_MEM_wb_i[0] != 0 && EX_MEM_rd_i != 0 && EX_MEM_rd_i == ID_EX_rt_i)
		tmp3 = 2'b10;
	if (MEM_WB_wb_i != 0 && MEM_WB_rd_i != 0 && MEM_WB_rd_i == ID_EX_rs_i)
		tmp2 = 2'b01;
	if (MEM_WB_wb_i != 0 && MEM_WB_rd_i != 0 && MEM_WB_rd_i == ID_EX_rt_i)
		tmp3 = 2'b01;
end



assign forward_MUX2_o = tmp2;
assign forward_MUX3_o = tmp3;

endmodule
