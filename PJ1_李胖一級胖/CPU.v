module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
wire    [31:0]  addr_result;
wire    [31:0]  inst;
wire    [6:0]   control_a;
wire    [4:0]   control_b;
wire    [4:0]   control_c;
wire    [4:0]   control_d;
wire    [31:0]  control_e;

assign  control_a = inst[6:0];
assign  control_b = inst[19:15];
assign  control_c = inst[24:20];
assign  control_d = inst[11:7];
assign  control_e = inst[31:0];


Control Control(
    .instr_i       (IF_ID.instr_o),
    //.RegDst_o   (MUX_RegDst.select_i),
    .operation_o   (),
    .ALUSrc_o      ()
);

Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'd4),
    .data_o     ()
);

Adder_shift ADD(
    .data1_in   (IF_ID.addr_o),             // IF/ID out
    .data2_in   (Sign_Extend.data_o),      // IMM GEN out (sign extend)
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .select_i   (Hazard_Detection.pc_o),//hazard detection unit out
    .pc_i       (MUX_PC.data_o),        // first mux related
    .pc_o       ()  
);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o), 
    .instr_o    ()
);

Data_Memory Data_Memory(
    .clk_i      (clk_i),
    .data1_i    (EX_MEM.addr_data_o),                        
    .data2_i    (EX_MEM.write_data_o),       
    .Mem_Read_i (EX_MEM.Mem_Read_o),
    .Mem_Write_i(EX_MEM.Mem_Write_o),
    .data_o     ()                          // mem/wb in 2
);

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IF_ID.instr_o[19:15]),
    .RTaddr_i   (IF_ID.instr_o[24:20]),
    .RDaddr_i   (MEM_WB.reg_RDaddr_o), 
    .RDdata_i   (MEM_WB.reg_RDdata_o),    
    .RegWrite_i (MEM_WB.reg_write_o),  
    .RSdata_o   (), 
    .RTdata_o   ()
);

/*
MUX5 MUX_RegDst(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     ()
);
*/


MUX4 MUX_ALUSrc(
    .data1_i    (mux3.data_o),
    .data2_i    (ID_EX.Sign_Extend_o),
    .select_i   (ID_EX.ALUSrc_o),
    .data_o     ()
);
muxhazard muxhazard(
    .data1_i    (Control.operation_o),
    .data2_i    (4'b1111),
    .select_i   (Hazard_Detection.pc_o),
    .data_o     ()
);


MUX_PC MUX_PC(
    .data1_i    (Add_PC.data_o),
    .data2_i    (ADD.data_o),  // beq
    .select_i   (Hazard_Detection.branch_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .data_i     (IF_ID.instr_o),
    .data_o     ()
);

  

ALU ALU(
    .data1_i    (mux2.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ID_EX.operation_o),
    .data_o     (),
    .Zero_o     ()
);



//ALU_Control ALU_Control(
//    .funct_i    (),
//    .ALUOp_i    (ID_EX.ALUOp_o),
//    .ALUCtrl_o  ()
//);

Hazard_Detection Hazard_Detection(
    .pc_o               (),
    .branch_o           (),   //branch happened, handle flush and tell mux pc 
    .equal_i            (Equal.data_o),   // branch
    .IF_ID_rs_i         (IF_ID.instr_o[19:15]),
    .IF_ID_rt_i         (IF_ID.instr_o[24:20]),
    .ID_EX_rd_i         (ID_EX.instr_o[11:7]),
    .ID_EX_MEM_read_i   (ID_EX.EX_MEM_M_o)
);

IF_ID IF_ID(
    .clk_i                  (clk_i),
    .pc_i                   (PC.pc_o),
    .Instruction_Memory_i   (Instruction_Memory.instr_o),
    .Hazard_Detection_i     (Hazard_Detection.pc_o),   // stall
    .Flush_i                (Hazard_Detection.branch_o),
    .instr_o                (),
    .addr_o                 ()  // handle beq, go to add  
); 

ID_EX ID_EX(
    .clk_i          (clk_i),
    .addr_i         (IF_ID.addr_o),
    .operation_i    (muxhazard.data_o),
    .operation_o    (),
    .data1_i        (Registers.RSdata_o),
    .data2_i        (Registers.RTdata_o),
    .Sign_Extend_i  (Sign_Extend.data_o),
    .instr_i        (IF_ID.instr_o),
    .mux2_o         (),
    .mux3_o         (),
    .EX_MEM_WB_o    (),
    .EX_MEM_M_o     (),
    .forwarding_rs_i(IF_ID.instr_o[19:15]),
    .forwarding_rs_o(),
    .forwarding_rt_i(IF_ID.instr_o[24:20]),
    .forwarding_rt_o(),
    .instr_o        (),
    .alu_src_i      (Control.ALUSrc_o),
    .ALUSrc_o       (),
    .Sign_Extend_o  ()
);
EX_MEM EX_MEM(
    .clk_i          (clk_i),
    .operation_i    (ID_EX.operation_o),
    .operation_o    (),
    .ID_EX_Wb_i     (ID_EX.EX_MEM_WB_o),
    .ID_EX_M_i      (ID_EX.EX_MEM_M_o),
    .MEM_WB_Wb_o    (),
    .alu_i          (ALU.data_o),         
    .mux3_i         (mux3.data_o),  
    .instr_i        (ID_EX.instr_o), 
    .Mem_Read_o     (),      
    .Mem_Write_o    (),     
    .write_data_o   (),   //data memory
    .addr_data_o    (),   //data memory 
    .forwarding_rd_o()
);


MEM_WB MEM_WB(
    .clk_i          (clk_i),
    .EX_MEM_Wb_i    (EX_MEM.MEM_WB_Wb_o),
    .Data_Memory_i  (Data_Memory.data_o),
    .addr_data_i    (EX_MEM.addr_data_o),
    .instr_i        (EX_MEM.forwarding_rd_o),
    .operation_i    (EX_MEM.operation_o),
    .reg_write_o    (),  //register control signal
    .reg_RDaddr_o   (),  //register address 
    .reg_RDdata_o   (),  //register data
    .forwarding_rd_o()   //forwarding register data
);

Equal Equal(
    .data1_i    (Registers.RSdata_o),   
    .data2_i    (Registers.RTdata_o),
    .data_o     (),  //1ÊÇ°lÉúequal beq
    .operation_i(Control.operation_o)
);

Forwarding Forwarding(
    .forward_MUX2_o (),
    .forward_MUX3_o (),
    .ID_EX_rs_i     (ID_EX.forwarding_rs_o),
    .ID_EX_rt_i     (ID_EX.forwarding_rt_o),
    .EX_MEM_rd_i    (EX_MEM.forwarding_rd_o),
    .EX_MEM_wb_i    (EX_MEM.MEM_WB_Wb_o),
    .MEM_WB_rd_i    (MEM_WB.forwarding_rd_o),
    .MEM_WB_wb_i    (MEM_WB.reg_write_o)

);

MUX32 mux2(
    .data_o     (),
    .data1_i    (ID_EX.mux2_o),
    .data2_i    (MEM_WB.reg_RDdata_o),
    .data3_i    (EX_MEM.addr_data_o),
    .select_i   (Forwarding.forward_MUX2_o)
);

MUX32 mux3(
    .data_o     (),
    .data1_i    (ID_EX.mux3_o),
    .data2_i    (MEM_WB.reg_RDdata_o),
    .data3_i    (EX_MEM.addr_data_o),
    .select_i   (Forwarding.forward_MUX3_o)
);

endmodule

