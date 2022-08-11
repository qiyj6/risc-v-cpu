module pc_reg(
	input wire clk,
	input wire rst_n,
	output reg[31:0] pc_o
);

	always @(posedge clk) begin
		if(!rst_n)
			pc_o <= 0;
		else
			pc_o <= pc_o + 3'd4;
	end

endmodule