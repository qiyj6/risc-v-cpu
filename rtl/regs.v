module regs(
	input wire clk,
	input wire rst_n,
	//from id
	input wire reg_wen,
	input wire [4:0] reg1_raddr_i,
	input wire [4:0] reg2_raddr_i,
	input wire [4:0] reg_waddr_i,
	input wire [31:0] reg_wdata_i,
	
	//to id
	output reg [31:0] reg1_rdata_o,
	output reg [31:0] reg2_rdata_o
);

	reg [31:0] regs[0:31];
	integer i;
	
	always @(*)begin
		if(!rst_n)
			reg1_rdata_o = 32'b0;
		else if(reg1_raddr_i == 5'b0)
			reg1_rdata_o = 32'b0;
		else if(reg_wen && reg1_raddr_i == reg_waddr_i) //consider the read and write confliction rd 
			reg1_rdata_o = reg_wdata_i;
		else
			reg1_rdata_o = regs[reg1_raddr_i];
	end 
	
	always @(*)begin
		if(!rst_n)
			reg2_rdata_o = 32'b0;
		else if(reg2_raddr_i == 5'b0)
			reg2_rdata_o = 32'b0;
		else if(reg_wen && reg2_raddr_i == reg_waddr_i) //consider the read and write confliction 
			reg2_rdata_o = reg_wdata_i;
		else
			reg2_rdata_o = regs[reg2_raddr_i];
	end 
	
	always @(posedge clk or negedge rst_n) begin
		if(!rst_n) begin
			for(i=0;i<32;i=i+1)begin
					regs[i] <= 32'b0;
			end
		end
		else if((reg_wen)&&(reg_waddr_i!=5'b0))begin //can't write to 0x00000 reg
			regs[reg_waddr_i] <= reg_wdata_i;
		end
		else
			;
	end

endmodule