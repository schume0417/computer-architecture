module Hazard_Detection(
    pc_o,
    branch_o,   //branch happened, handle flush and tell mux pc 
    equal_i,   // branch true
    IF_ID_rs_i,
    IF_ID_rt_i,
    ID_EX_rd_i,   //unknown
    ID_EX_MEM_read_i
);

output	pc_o;
output	branch_o;
input	equal_i;
input	[4:0]	IF_ID_rs_i;
input	[4:0]	IF_ID_rt_i;
input	[4:0]	ID_EX_rd_i;
input	[2:0]	ID_EX_MEM_read_i;
reg		tmp_branch_o;
reg 	tmp_pc_o;

always @(*) begin
	if (equal_i) begin 
		tmp_branch_o <= 1'b1;
		tmp_pc_o <= 1'b1;
	end
	else
		tmp_branch_o <= 1'b0;

	tmp_pc_o <= 1'b0;
	if (ID_EX_MEM_read_i[2] == 1) begin  //MEM
		if ( (ID_EX_rd_i == IF_ID_rs_i) || (ID_EX_rd_i == IF_ID_rs_i) )
			tmp_pc_o <= 1'b1;
	end

	//tmp_branch_o = 0; //debug
	//tmp_pc_o = 0; //debug
end

assign branch_o = tmp_branch_o;
assign pc_o = tmp_pc_o;

endmodule