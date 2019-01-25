`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .rst_i  (Reset),
    .start_i(Start)
);
  
initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end
    
    // Load instructions into instruction memory
    $readmemb("Fibonacci_instruction.txt", CPU.Instruction_Memory.memory); //Fibonacci_instruction
    //debug
    
    // Open output file
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    Clk = 1;
    Reset = 0;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    Reset = 1;
    Start = 1;
        
    
end
  
always@(posedge Clk) begin
    if(counter == 50)    // stop after 30 cycles. //debug
        $stop;

    // put in your own signal to count stall and flush
    if(CPU.Hazard_Detection.pc_o == 1 && CPU.Control.operation_o == 4'b0111)stall = stall + 1;
    if(CPU.Hazard_Detection.branch_o == 1)flush = flush + 1; 
     

    $display("Count %d, Clk %d, Start %d",counter, Clk, Start);
    $display("[CPU]: clk_i=%d, start_i=%d",CPU.clk_i, CPU.start_i);
    $display("[MUX_PC]: add_pc_i = %d, add_branch = %d, select_i = %d, data_o = %d", CPU.MUX_PC.data1_i, CPU.MUX_PC.data2_i, CPU.MUX_PC.select_i, CPU.MUX_PC.data_o);
    $display("[PC]: clk_i=%d, start_i=%d, pc_i=%d, pc_o=%d",CPU.PC.clk_i, CPU.PC.start_i, CPU.PC.pc_i, CPU.PC.pc_o);
    $display("[IF_ID]: pc_i=%d, Instruction_Memory_i=%b", CPU.IF_ID.pc_i, CPU.IF_ID.Instruction_Memory_i);
    $display("[IF_ID]: addr_o=%d, inst_o=%b", CPU.IF_ID.addr_o, CPU.IF_ID.instr_o);
    $display("data1 %d data2 %d adder_shift %d", CPU.ADD.data1_in, CPU.ADD.data2_in, CPU.ADD.data_o);
    $display("[Registers]: RSaddr_i=%d, RTaddr_i=%d, RDaddr_i=%d, RDdata_i=%d, RegWrite_i=%d, RSdata_o=%d, RTdata_o=%d",CPU.Registers.RSaddr_i, CPU.Registers.RTaddr_i, CPU.Registers.RDaddr_i, CPU.Registers.RDdata_i, CPU.Registers.RegWrite_i, CPU.Registers.RSdata_o, CPU.Registers.RTdata_o);
    //$display("[ALU_Control]: fun7=%b, fun3=%b, ALUOp_i=%b, ALUCtrl_o=%b", CPU.ALU_Control.fun7, CPU.ALU_Control.fun3, CPU.ALU_Control.ALUOp_i, CPU.ALU_Control.ALUCtrl_o);
    $display("[Hazard]: stall_o=%d, flush_o=%d", CPU.Hazard_Detection.pc_o, CPU.Hazard_Detection.branch_o);
    $display("[ID_EX]: opeation_i=%b, ALUSrc_i=%d", CPU.ID_EX.operation_i, CPU.ID_EX.alu_src_i);
    $display("[ID_EX]: RSdata_i=%d, RTdata_i=%d, RSaddr_i=%d, RTaddr_i=%d, instr_i=%b, Sign_Extend_i=%d", CPU.ID_EX.data1_i, CPU.ID_EX.data2_i, CPU.ID_EX.forwarding_rs_i, CPU.ID_EX.forwarding_rt_i, CPU.ID_EX.instr_i , CPU.ID_EX.Sign_Extend_i);
    $display("[ID_EX]: operation_o=%b, ALUSrc_o=%d", CPU.ID_EX.operation_o, CPU.ID_EX.ALUSrc_o);
    $display("[ID_EX]: RSdata_o=%d, RTdata_o=%d, RSaddr_o=%d, RTaddr_o=%d, instr_o=%b, Sign_Extend_o=%d,", CPU.ID_EX.mux2_o, CPU.ID_EX.mux3_o, CPU.ID_EX.forwarding_rs_o, CPU.ID_EX.forwarding_rt_o, CPU.ID_EX.instr_o, CPU.ID_EX.Sign_Extend_o);
    $display("[ALU]: data1_i=%d, data2_i=%d, ALUCtrl_i=%b, data_o=%d, Zero_o=%d", CPU.ALU.data1_i, CPU.ALU.data2_i, CPU.ALU.ALUCtrl_i, CPU.ALU.data_o, CPU.ALU.Zero_o);
    $display("[EX_MEM]: ALU_i=%d, RTdata_i=%d, inst_i=%b, RegWrite_signal_i=%b, Memsignal_i=%b", CPU.EX_MEM.alu_i, CPU.EX_MEM.mux3_i, CPU.EX_MEM.instr_i, CPU.EX_MEM.ID_EX_Wb_i, CPU.EX_MEM.ID_EX_M_i);
    $display("[EX_MEM]: ALU_o=%d, RTdata_o=%d, inst_o=%d, RegWrite_signal_o=%b, Mem_write_o=%d, Mem_read_o=%d", CPU.EX_MEM.addr_data_o, CPU.EX_MEM.write_data_o, CPU.EX_MEM.forwarding_rd_o,CPU.EX_MEM.MEM_WB_Wb_o, CPU.EX_MEM.Mem_Write_o, CPU.EX_MEM.Mem_Read_o);
    $display("[MEM_WB]: Data_Memory_i=%d, addr_data_i=%d, RDaddr_i=%d, RegWrite_i=%b", CPU.MEM_WB.Data_Memory_i, CPU.MEM_WB.addr_data_i, CPU.MEM_WB.instr_i , CPU.MEM_WB.EX_MEM_Wb_i);
    $display("[MEM_WB]: reg_RDdata_o=%b, reg_RDaddr_o=%b, RegWrite_o=%d", CPU.MEM_WB.reg_RDdata_o, CPU.MEM_WB.reg_RDaddr_o, CPU.MEM_WB.reg_write_o);
    $display("[Forward]: Sselect_o=%b, Tselect_o=%b", CPU.Forwarding.forward_MUX2_o, CPU.Forwarding.forward_MUX3_o);
    

    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %d, Flush = %d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
    
      
end

  
endmodule
