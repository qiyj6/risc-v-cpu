module open_risc_v(
	input clk,
	input rst_n,
	input wire [31:0] inst_i,
	output wire [31:0] inst_addr_o
);

	//pc to rom & if_id
	wire [31:0] pc_reg_pc_o;
	//if to if_id
	// wire [31:0] if_inst_addr_o;
	// wire [31:0] if_inst_o;
	//if_id to id
	wire [31:0] if_id_inst_addr_o;
	wire [31:0] if_id_inst_o;
	//regs to id
	wire [31:0] regs_reg1_rdata_o;
	wire [31:0] regs_reg2_rdata_o;
	//id to regs
	wire [4:0] id_rs1_addr_o;
	wire [4:0] id_rs2_addr_o;
	//id to id_ex
	wire [31:0] id_inst_o;
	wire [31:0] id_inst_addr_o;
	wire [31:0] id_op1_o;
	wire [31:0] id_op2_o;
	wire [4:0] 	id_rd_addr_o;
	wire 		id_reg_wen;
	//from id_ex to ex
	wire [31:0] id_ex_inst_o;
	wire [31:0] id_ex_inst_addr_o;
	wire [31:0] id_ex_op1_o;
	wire [31:0] id_ex_op2_o;
	wire [4:0] 	id_ex_rd_addr_o;
	wire 		id_ex_reg_wen_o;
	//from ex to regs
	wire [4:0] 	ex_rd_addr_o;
	wire [31:0] ex_rd_data_o;
	wire 		ex_rd_wen_o;

	//from ex to ctrl
	wire [31:0] ex_jump_addr_o;
	wire 		ex_jump_en_o;
	wire 		ex_hold_flag_o;
	// from ctrl to pc_reg
	wire [31:0] ctrl_jump_addr_o;
	wire 		ctrl_jump_en_o;
	//from ctrl to if_id & id_ex
	wire 		ctrl_hold_flag_o;
	//from mem to ex
	wire [31:0] 	mem_rd_data_o;

	//from id to  mem
	wire 			id_mem_rd_req_o;
	wire[31:0] 		id_mem_rd_addr_o;

	//from ex to mem
	wire [31:0] 	ex_mem_wr_addr_o;
	wire [3:0]		ex_mem_wr_sel_o ;
	wire 			ex_mem_wr_req_o ;
	wire [31:0]		ex_mem_wr_data_o;


	pc_reg pc_reg1(
		.clk   		 (clk),
		.rst_n 		 (rst_n),
		.jump_addr_i (ctrl_jump_addr_o),
		.jump_en_i	 (ctrl_jump_en_o),
		.pc_o		 (pc_reg_pc_o)
	);

	assign inst_addr_o = pc_reg_pc_o; 


	if_id if_id1(
		.clk			 (clk),
		.rst_n			 (rst_n),
		.inst_i			 (inst_i),
		.inst_addr_i	 (pc_reg_pc_o),
		.hold_flag_i	 (ctrl_hold_flag_o),
		.inst_addr_o	 (if_id_inst_addr_o),
		.inst_o			 (if_id_inst_o) 
	);


	regs regs1(
		.clk			(clk),
		.rst_n			(rst_n),
		.reg_wen		(ex_rd_wen_o),
		.reg1_raddr_i	(id_rs1_addr_o),
		.reg2_raddr_i	(id_rs2_addr_o),
		.reg_waddr_i	(ex_rd_addr_o),
		.reg_wdata_i	(ex_rd_data_o),
		
		.reg1_rdata_o	(regs_reg1_rdata_o),
		.reg2_rdata_o	(regs_reg2_rdata_o)
	);


	id id1(
		//from if_id
		.inst_i		 	(if_id_inst_o),
		.inst_addr_i	(if_id_inst_addr_o),

		//to regs	
		.rs1_addr_o		(id_rs1_addr_o),
		.rs2_addr_o		(id_rs2_addr_o),
		//from regs			
		.rs1_data_i		(regs_reg1_rdata_o),
		.rs2_data_i		(regs_reg2_rdata_o),

		//to id_ex	
		.inst_o			(id_inst_o),
		.inst_addr_o	(id_inst_addr_o),
		.op1_o			(id_op1_o),
		.op2_o			(id_op2_o),
		.rd_addr_o		(id_rd_addr_o),
		.reg_wen		(id_reg_wen),

		//to mem
		.mem_rd_req_o(id_mem_rd_req_o),
		.mem_rd_addr_o(id_mem_rd_addr_o)	
	);

	ram ram1(
       .clk  	(clk)						,
	   .rst_n  	(rst_n)						,
       .wen  	(ex_mem_wr_sel_o)			,
	   .w_addr_i(ex_mem_wr_addr_o) 			,
	   .w_data_i(ex_mem_wr_data_o)			,
	   .ren 	(id_mem_rd_req_o)			,
	   .r_addr_i(id_mem_rd_addr_o) 			,
       .r_data_o(mem_rd_data_o)	
);


	id_ex id_ex1(
		.clk			(clk),
		.rst_n			(rst_n),
		.inst_i			(id_inst_o),			//from id
		.inst_addr_i	(id_inst_addr_o),
		.op1_i			(id_op1_o), 
		.op2_i			(id_op2_o),
		.rd_addr_i		(id_rd_addr_o), 
		.reg_wen_i		(id_reg_wen),
		.hold_flag_i	(ctrl_hold_flag_o),		//from ctrl
		.inst_o			(id_ex_inst_o),			//to ex
		.inst_addr_o	(id_ex_inst_addr_o),
		.op1_o			(id_ex_op1_o), 
		.op2_o			(id_ex_op2_o),
		.rd_addr_o		(id_ex_rd_addr_o), 
		.reg_wen_o 		(id_ex_reg_wen_o)
	);

	ex ex1(
		//from id_ex
		.inst_i			(id_ex_inst_o), 
		.inst_addr_i	(id_ex_inst_addr_o),
		.op1_i			(id_ex_op1_o),
		.op2_i			(id_ex_op2_o),
		.rd_addr_i		(id_ex_rd_addr_o),
		.rd_wen_i		(id_ex_reg_wen_o),

		//to regs
		.rd_addr_o		(ex_rd_addr_o),
		.rd_data_o		(ex_rd_data_o),
		.rd_wen_o		(ex_rd_wen_o),

		.jump_addr_o				(ex_jump_addr_o),
		.jump_en_o					(ex_jump_en_o),
		.hold_flag_o				(ex_hold_flag_o),

		.mem_rd_data_i(mem_rd_data_o),
		.mem_wr_addr_o(ex_mem_wr_addr_o),
		.mem_wr_sel_o (ex_mem_wr_sel_o),
		.mem_wr_req_o (ex_mem_wr_req_o),
		.mem_wr_data_o(ex_mem_wr_data_o)
	);

	ctrl ctrl1(
		.jump_addr_i	    (ex_jump_addr_o),	
		.jump_en_i	    	(ex_jump_en_o),
		.hold_flag_ex_i		(ex_hold_flag_o),
		.jump_addr_o	    (ctrl_jump_addr_o),	
		.jump_en_o	    	(ctrl_jump_en_o),
		.hold_flag_o		(ctrl_hold_flag_o)
	);

endmodule