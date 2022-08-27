module dual_ram #( 
	parameter DW = 32,
	parameter AW = 12,
	parameter MEM_NUM = 4096
)
(
	input wire 			clk			,
	input wire 			rst_n			,
	input wire 			w_en_i		,
	input wire[AW-1:0]	w_addr_i	,
	input wire[DW-1:0]  w_data_i	,
	input wire 			r_en_i		,
	input wire[AW-1:0]	r_addr_i	,
	output wire[DW-1:0]  r_data_o	
);	
	
	
	wire[DW-1:0] r_data_wire	;	
	reg 		 rd_equ_wr_flag	;
	reg[DW-1:0]	 w_data_reg		;
	
	assign r_data_o = (rd_equ_wr_flag) ? w_data_reg : r_data_wire;
	
	always @(posedge clk)begin
		if(!rst_n)
			w_data_reg <= 1'b0;
		else
			w_data_reg <= w_data_i;
	end
	
	//切换
	always @(posedge clk)begin
		if(rst_n && w_en_i && r_en_i && (w_addr_i == r_addr_i) )
			rd_equ_wr_flag <= 1'b1;
		else 
			rd_equ_wr_flag <= 1'b0;
	end

	dual_ram_template #(
		.DW (DW),
		.AW (AW),
		.MEM_NUM (MEM_NUM)
    )dual_ram_template_inst
	(
		.clk			(clk		),
		.rst_n			(rst_n		),
		.w_en_i			(w_en_i		),
		.w_addr_i		(w_addr_i	),
		.w_data_i		(w_data_i	),
		.r_en_i			(r_en_i		),
		.r_addr_i		(r_addr_i	),
		.r_data_o       (r_data_wire)
	);

endmodule




module dual_ram_template #(
    parameter   DW      = 32,   
    parameter   AW      = 12,
    parameter   MEM_NUM = 4096
)(
    input wire          clk         ,
    input wire          rst_n       ,
    input wire          w_en_i      ,
    input wire [AW-1:0] w_addr_i    ,
    input wire [DW-1:0] w_data_i    ,
    input wire          r_en_i      ,
    input wire [AW-1:0] r_addr_i    ,
    output reg [DW-1:0] r_data_o
);
    reg [DW-1:0] memory [0:MEM_NUM-1];

    always @(posedge clk ) begin
        if (rst_n&&r_en_i) begin
            r_data_o <= memory[r_addr_i];
        end
    end

    always @(posedge clk ) begin
        if (rst_n&&w_en_i) begin
            memory[w_addr_i] <= w_data_i;
        end
    end


endmodule
    
