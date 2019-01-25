module IF_ID(
	clk_i,
    pc_i,
    Instruction_Memory_i,
    Hazard_Detection_i,  //stall
    Flush_i,
    instr_o,
    addr_o,  //beq
    stall_i
); 

input			clk_i;
input			stall_i;
input	[31:0]	pc_i;
input	[31:0]	Instruction_Memory_i;
input			Hazard_Detection_i;
input			Flush_i;
output	[31:0]	instr_o;
output	[31:0]	addr_o;

reg 	[31:0]	temp_instr_o;
reg		[31:0]	temp_addr_o;
reg		[31:0]	instr_o;
reg		[31:0]	addr_o;


always@(posedge clk_i) begin
	if (Hazard_Detection_i | stall_i)	begin
		//temp_instr_o <= instr_o;
		instr_o <= instr_o;
		//temp_addr_o <= addr_o;
		addr_o <= addr_o;
	end
	else if (Flush_i)	begin
		//temp_instr_o <= 0;
		instr_o <= 0;
		//temp_addr_o <= 0;
		addr_o <= 0;
	end
	else begin
		//temp_instr_o <= Instruction_Memory_i;
		instr_o <= Instruction_Memory_i;
		//temp_addr_o <= pc_i;
		addr_o <= pc_i;
	end


end
//assign  instr_o = temp_instr_o;
//assign  addr_o = temp_addr_o;
endmodule