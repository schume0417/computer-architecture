module PC(
    clk_i,
    rst_i,
    start_i,
    pc_i,
    pc_o,
    pcEnable_i,
    stall_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input               stall_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;
input               pcEnable_i;
// Wires & Registers
reg     [31:0]      tmp_pc_o;
reg     [31:0]      pc_o;


always@(posedge clk_i or negedge start_i) begin
    if(~start_i) begin
        //tmp_pc_o = 32'b0;
        pc_o <= 32'b0;
    end
    else begin
        if (pcEnable_i | stall_i)
            //tmp_pc_o = pc_o;
            pc_o <= pc_o;
        else if (start_i)
            //tmp_pc_o = pc_i;
            pc_o <= pc_i;
        else
            //tmp_pc_o = pc_o;
            pc_o <= pc_o;
    end

    //pc_o = tmp_pc_o;
end
//assign pc_o = tmp_pc_o;

endmodule
