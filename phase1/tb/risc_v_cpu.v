module risc_v_cpu(
    input wire clk,
    input wire rst_n
);

//risc_v_top to rom
wire [31:0] risc_v_top_inst_addr_o;

//rom to risc_v_top
wire [31:0] rom_inst_o;

risc_v_top risc_v_top1(
	.clk            (clk),
	.rst_n          (rst_n),
	.inst_i         (rom_inst_o),
	.inst_addr_o    (risc_v_top_inst_addr_o)
);

rom rom1(
	.inst_addr_i	(risc_v_top_inst_addr_o),
	.inst_o			(rom_inst_o)
);

endmodule