module EX_MEM(
    clk_i,
    ID_EX_Wb_i,
    ID_EX_M_i,
    MEM_WB_Wb_o,
    alu_i,         
    mux3_i, 
    instr_i, 
    operation_i,
    operation_o,
    Mem_Read_o,      
    Mem_Write_o,     
    write_data_o,   //data memory
    addr_data_o,   //data memory 
    forwarding_rd_o
);

input           clk_i;
input   [2:0]   ID_EX_M_i;
input   [1:0]   ID_EX_Wb_i;
input   [3:0]   operation_i;
input   [31:0]  mux3_i;
input   [31:0]  alu_i;
input   [31:0]  instr_i;

output  [1:0]   MEM_WB_Wb_o;
output          Mem_Read_o;
output          Mem_Write_o;
output  [3:0]   operation_o;
output  [31:0]  addr_data_o;
output  [31:0]  write_data_o;
output  [4:0]   forwarding_rd_o;

reg     [3:0]   operation_o;
reg     [31:0]  addr_data_o;
reg     [4:0]   forwarding_rd_o;
reg     [31:0]  write_data_o;
reg     [1:0]   MEM_WB_Wb_o;
reg             Mem_Read_o;
reg             Mem_Write_o;

//assign  operation_o = operation_i;
//assign  addr_data_o = alu_i;
//assign  forwarding_rd_o = instr_i[11:7];
//assign  write_data_o = mux3_i;
//assign  MEM_WB_Wb_o = ID_EX_Wb_i;

//reg     tmp_Mem_Read_o;
//reg     tmp_Mem_Write_o;
//assign Mem_Read_o = tmp_Mem_Read_o;
//assign Mem_Write_o = tmp_Mem_Write_o;




always @(posedge clk_i) begin
	if (operation_i == 4'b0101)
    begin//lw
		//tmp_Mem_Read_o = 1;
        Mem_Read_o <= 1;
		//tmp_Mem_Write_o = 0;
        Mem_Write_o <= 0;
    end
	if (operation_i == 4'b0110)//sw
	begin
    	//tmp_Mem_Read_o = 0;
        Mem_Read_o <= 0;
		//tmp_Mem_Write_o = 1;
        Mem_Write_o <= 1;
    end

    operation_o <= operation_i;
    addr_data_o <= alu_i;       // lw sw    
    forwarding_rd_o <= instr_i[11:7];
    write_data_o <= mux3_i;
    MEM_WB_Wb_o <= ID_EX_Wb_i;
end

//assign Mem_Read_o = tmp_Mem_Read_o;
//assign Mem_Write_o = tmp_Mem_Write_o;

endmodule
