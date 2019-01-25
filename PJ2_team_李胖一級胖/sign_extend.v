module Sign_Extend
(
    data_i,
    data_o
);

input	[31:0]	data_i;
output	[31:0]	data_o;
reg		[11:0]	temp;
always @(*) begin
	if(data_i[6:0] == 7'b0010011) begin//addi
        temp[11:0] = data_i[31:20]; 
    end
	else if(data_i[6:0] == 7'b0100011) begin
        temp[4:0] = data_i[11:7];
        temp[11:5] = data_i[31:25];
    end
    else if(data_i[6:0] == 7'b1100011) begin // beq
    	temp[3:0] = data_i[11:8];
    	temp[9:4] = data_i[30:25];
    	temp[10] = data_i[7];
    	temp[11] = data_i[31];
    end
    else if(data_i[6:0] == 7'b0000011) begin
        temp[11:0] = data_i[31:20]; 
    end
end

assign data_o = {{20{temp[11]}}, temp};

endmodule

