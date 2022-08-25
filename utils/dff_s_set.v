module dff_s_set #(
	parameter DW  =  32
)
(

	input clk,
	input rst_n,
	input wire hold_flag_i,
	input wire [DW-1:0] set_data,
	input wire [DW-1:0] data_i,
	output reg [DW-1:0] data_o
);

	always@(posedge clk or negedge rst_n) begin //使用quartus综合时报错，提示要将hold_flag_i信号加入敏感信号列表。加入之后，使用modelsim仿真，发现jump_en_o信号有毛刺，用rtl视图检查，jump_en_o信号被综合成锁存器
		if((!rst_n)||(hold_flag_i))
			data_o <= set_data;
		else
			data_o <= data_i;
	end 
	
	
endmodule
	