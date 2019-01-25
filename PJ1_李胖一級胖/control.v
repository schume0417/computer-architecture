module Control(
    instr_i,      
    operation_o,
    ALUSrc_o
);

input   [31:0]   instr_i;

reg     [6:0]    fun7;
reg     [6:0]    op;
reg     [2:0]    fun3;  
reg     [3:0]    temp;
output  [3:0]    operation_o;
output           ALUSrc_o;

reg     [3:0]    operation_o;
reg              ALUSrc_o;

//fun7[6:0] = instr_i[31:25];
//fun3[2:0] = instr_i[14:12];
//op[6:0] = instr_i[6:0];

always @(*) begin
    if(instr_i[31:25] == 6'b100000)
        temp = 4'b0001;//sub
    else if(instr_i[14:12] == 3'b111)
        temp = 4'b0010;//and
    else if(instr_i[14:12] == 3'b110)
        temp = 4'b0011;//or
    else if(instr_i[6:0] == 7'b0010011)
        temp = 4'b0000;//addi
    else if(instr_i[31:25] == 7'b0000001)
        temp = 4'b0100;//mul
    else if(instr_i[6:0] == 7'b0000011)
        temp = 4'b0101;//lw
    else if(instr_i[6:0] == 7'b0100011)
        temp = 4'b0110;//sw
    else if(instr_i[6:0] == 7'b1100011)
        temp = 4'b0111;//beq
    //else if() jump ???
    else
        temp = 4'b1000;//add

    operation_o = temp;
    if (instr_i[6:0] == 7'b0010011)
        ALUSrc_o = 1'b1;
    else if (instr_i[6:0] == 7'b0100011)
        ALUSrc_o = 1'b1;
	else if (instr_i[6:0] == 7'b0000011)
		ALUSrc_o = 1'b1;
    else 
        ALUSrc_o = 1'b0;
    //ALUSrc_o = (instr_i[6:0] == 7'b0110011)?1'b0:1'b1;
end

//assign  operation_o = temp;
//assign  ALUSrc_o = (instr_i[6:0] == 7'b0110011)?1'b0:1'b1;
endmodule
