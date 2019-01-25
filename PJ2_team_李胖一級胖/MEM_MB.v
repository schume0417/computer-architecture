module MEM_WB(
    clk_i,
    EX_MEM_Wb_i,
    Data_Memory_i,
    addr_data_i,
    instr_i,
    operation_i,
    reg_write_o,  //register control signal
    reg_RDaddr_o,  //register address 
    reg_RDdata_o,  //register data
    forwarding_rd_o,   //forwarding register data
    stall_i
);

input           clk_i;
input           stall_i;
input   [1:0]   EX_MEM_Wb_i;
input	[31:0]	Data_Memory_i, addr_data_i;
input	[3:0]	operation_i;
input   [4:0]  instr_i;
output         reg_write_o;
output  [4:0]  reg_RDaddr_o; 
output  [31:0] reg_RDdata_o;
output  [4:0]  forwarding_rd_o;
//reg     [31:0]  tmp_reg_RDaddr_o;

//reg     [31:0] tmp_reg_RDdata_o;
reg            reg_write_o;
reg     [4:0]  reg_RDaddr_o;
reg     [4:0]  forwarding_rd_o; 
reg     [31:0] reg_RDdata_o;

//assign reg_RDdata_o = tmp_reg_RDdata_o;
//assign reg_write_o = EX_MEM_Wb_i[0];
initial begin
    reg_write_o <= 0;
    reg_RDaddr_o <= 0;
    forwarding_rd_o <= 0;
    reg_RDdata_o <= 0;
end

always @(posedge clk_i) begin

    if (stall_i) begin
    end
    else begin
        if (EX_MEM_Wb_i[1] == 1'b1) begin
            reg_RDdata_o <= Data_Memory_i;
        end
        else begin
            reg_RDdata_o <= addr_data_i;
        end

        reg_write_o <= EX_MEM_Wb_i[0];
        reg_RDaddr_o <= instr_i;
        forwarding_rd_o <= instr_i; 
    end
end

//assign  reg_RDaddr_o = instr_i;
//assign  forwarding_rd_o = instr_i;
//assign reg_RDdata_o = tmp_reg_RDdata_o;



endmodule
