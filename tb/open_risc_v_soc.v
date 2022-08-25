module open_risc_v_soc(
    input wire clk,
    input wire rst_n
);

//open_risc_v to rom
wire [31:0] open_risc_v_inst_addr_o;

//rom to open_risc_v
wire [31:0] rom_inst_o;

open_risc_v open_risc_v1(
	.clk            (clk),
	.rst_n          (rst_n),
	.inst_i         (rom_inst_o),
	.inst_addr_o    (open_risc_v_inst_addr_o)
);

rom rom1(
    .clk		(clk					 ),
    .rst_n		(rst_n					 ),
    .w_en_i		(1'b0					 ),
    .w_addr_i	(32'b0					 ),
    .w_data_i	(32'b0					 ),
    .r_en_i		(1'b1					 ),
    .r_addr_i	(open_risc_v_inst_addr_o ),
    .r_data_o	(rom_inst_o				 )
);	

endmodule