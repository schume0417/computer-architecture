module ID_EX(
    clk_i,
    addr_i,
    operation_i,          //mod
    operation_o,          //mod
    data1_i,
    data2_i,
    Sign_Extend_i,
    instr_i,
    mux2_o,
    mux3_o,
    EX_MEM_WB_o,
    EX_MEM_M_o, 
    forwarding_rs_i,
    forwarding_rs_o,
    forwarding_rt_i,
    forwarding_rt_o,
    instr_o,
    alu_src_i,
    ALUSrc_o,
    Sign_Extend_o
);

input   clk_i;
input   [31:0]  addr_i, data1_i, data2_i, Sign_Extend_i, instr_i;
input   [3:0]   operation_i;
input   [4:0]   forwarding_rs_i, forwarding_rt_i;
output  [4:0]   forwarding_rs_o, forwarding_rt_o;
output  [3:0]   operation_o;
output  [31:0]  instr_o, mux2_o, mux3_o;
output  [2:0]   EX_MEM_M_o;
output  [1:0]   EX_MEM_WB_o;
input           alu_src_i;
output          ALUSrc_o;
reg     [2:0]   temp_EX_MEM_M_o;
reg     [1:0]   temp_EX_MEM_WB_o;
output  [31:0]  Sign_Extend_o;


reg     [2:0]   EX_MEM_M_o;
reg     [1:0]   EX_MEM_WB_o;
reg     [4:0]   forwarding_rs_o, forwarding_rt_o;
reg     [3:0]   operation_o;
reg     [31:0]  instr_o, mux2_o, mux3_o;
reg             ALUSrc_o;
reg     [31:0]  Sign_Extend_o;
/*
assign  forwarding_rs_o = instr_i[19:15];
assign  forwarding_rt_o = instr_i[24:20];
assign  operation_o = operation_i;
assign  instr_o = instr_i;
assign  mux2_o = data1_i;
assign  mux3_o = data2_i;
*/


always @(*) begin
    if (operation_i == 4'b0000 || operation_i == 4'b0001 || 
        operation_i == 4'b0010 || operation_i == 4'b0011 ||
        operation_i == 4'b0100 || operation_i == 4'b1000) 
    begin //reset
        temp_EX_MEM_M_o = 3'b000;    // read write branch
        //EX_MEM_M_o = 3'b000;
        temp_EX_MEM_WB_o = 2'b01;    // memtoreg regwr
        //EX_MEM_WB_o = 2'b01; 
    end
    else if (operation_i == 4'b0101) begin  //ld
        temp_EX_MEM_M_o = 3'b100;
        //EX_MEM_M_o = 3'b100;
        temp_EX_MEM_WB_o = 2'b11;
        //EX_MEM_WB_o = 2'b11;
    end
    else if (operation_i == 4'b0110) begin  //sd
        temp_EX_MEM_M_o = 3'b010;
        //EX_MEM_M_o = 3'b010;
        temp_EX_MEM_WB_o = 2'b00;
        //EX_MEM_WB_o = 2'b00;
    end
    else if (operation_i == 4'b0111) begin  //beq
        temp_EX_MEM_M_o = 3'b001;
        //EX_MEM_M_o = 3'b001;
        temp_EX_MEM_WB_o = 2'b00;
        //EX_MEM_WB_o = 2'b00;
    end
    else begin
        temp_EX_MEM_M_o = 3'b000;
        temp_EX_MEM_WB_o = 2'b00;
    end // else
end


always @(posedge clk_i) begin
    EX_MEM_M_o <= temp_EX_MEM_M_o;
    EX_MEM_WB_o <= temp_EX_MEM_WB_o; 
    forwarding_rs_o <= instr_i[19:15];
    forwarding_rt_o <= instr_i[24:20];
    operation_o <= operation_i;
    instr_o <= instr_i;
	mux2_o <= data1_i;
    mux3_o <= data2_i;
    ALUSrc_o <= alu_src_i;
    Sign_Extend_o <= Sign_Extend_i;
end

//assign EX_MEM_M_o = temp_EX_MEM_M_o;
//assign EX_MEM_WB_o = temp_EX_MEM_WB_o;

endmodule

