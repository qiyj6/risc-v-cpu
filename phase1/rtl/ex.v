`include "defines.v"
module ex(
	//from id_ex
	input wire[31:0] 	inst_i, 
	input wire[31:0]  	inst_addr_i,
	input wire[31:0] 	op1_i,
	input wire[31:0] 	op2_i,
	input wire[4:0]  	rd_addr_i,
	input wire 			rd_wen_i,

	//to regs
	output reg[4:0] rd_addr_o,
	output reg[31:0]rd_data_o,
	output reg     rd_wen_o,
	output reg [31:0] 	jump_addr_o	,	//to ctrl
	output reg 			jump_en_o	,
	output reg        	hold_flag_o	
);

	wire [6:0] opcode;
	wire [4:0] rd;
	wire [2:0] funct3;
	wire [4:0] rs1;
	wire [4:0] rs2;
	wire [6:0] funct7;
	wire [11:0] imm;
	
	assign opcode 	= 	inst_i[6:0];
	assign rd 		= 	inst_i[11:7];
	assign funct3 	= 	inst_i[14:12];
	assign rs1 		= 	inst_i[19:15];
	assign imm 		= 	inst_i[31:20];
	assign funct7 	= 	inst_i[31:25];
	assign rs2 		= 	inst_i[24:20];

	//branch 
	wire[31:0] 	jump_imm;
	wire       	op1_i_equal_op2_i;
	wire		op1_i_lt_op2_i;
	wire		op1_i_ltu_op2_i;

	assign jump_imm = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0};
	assign op1_i_equal_op2_i = (op1_i == op2_i)? 1'b1: 1'b0;						//			BEQ  	BNE
	assign op1_i_ltu_op2_i	 =	(op1_i < op2_i)? 1'b1: 1'b0;						//unsigned	BLTU  	BGEU
	assign op1_i_lt_op2_i	 =	(($signed(op1_i)) < ($signed(op2_i)))? 1'b1: 1'b0;	//signed	BLT  	BGE


	//type I	
	wire [31:0] SRA_mask;

	assign SRA_mask = (32'hffff_ffff) >> op2_i[4:0];

	always@(*) begin
		case(opcode)
			`INST_TYPE_I:begin
				jump_addr_o	= 	32'b0;
				jump_en_o	=	1'b0;
				hold_flag_o	=	1'b0;				
				case(funct3)
					`INST_ADDI:begin
						rd_data_o = op1_i + op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_SLTI:begin
						rd_data_o = {31'b0,op1_i_lt_op2_i};
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_SLTIU:begin
						rd_data_o = {31'b0,op1_i_ltu_op2_i};
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_XORI:begin
						rd_data_o = op1_i ^ op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_ORI:begin
						rd_data_o = op1_i | op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_ANDI:begin
						rd_data_o = op1_i & op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_SLLI:begin
						rd_data_o = op1_i << op2_i[4:0];
						rd_addr_o = rd_addr_i;
						rd_wen_o  = 1'b1;
					end
					`INST_SRI:begin
						if (funct7[5] == 1'b1) begin	//SRAI
							rd_data_o = (((op1_i >> op2_i[4:0]) & SRA_mask)) | (({32{op1_i[31]}}) & (~SRA_mask));
							rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end 
						else begin						//SRLI
							rd_data_o = op1_i >> op2_i[4:0];
							rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end
					end	
					default:begin
						rd_data_o = 32'b0;
						rd_addr_o = 5'b0;
						rd_wen_o  = 1'b0;
					end
				endcase
			end
			
			`INST_TYPE_R_M:begin
				jump_addr_o	= 	32'b0;
				jump_en_o	=	1'b0;
				hold_flag_o	=	1'b0;					
				case(funct3)
					`INST_ADD_SUB:begin
						if(funct7[5] == 1'b0) begin
							rd_data_o = op1_i + op2_i;
							rd_addr_o = rd_addr_i;
							rd_wen_o = 1'b1;
						end
						else begin
							rd_data_o = op1_i - op2_i;
							rd_addr_o = rd_addr_i;
							rd_wen_o = 1'b1;
						end
					end

					`INST_SLL:begin
						rd_data_o = op1_i << op2_i[4:0];
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
					end

					`INST_SLT:begin
						rd_data_o = {31'b0,op1_i_lt_op2_i};
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
					end

					`INST_SLTU:begin
						rd_data_o = {31'b0,op1_i_ltu_op2_i};
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
					end

					`INST_XOR:begin
						rd_data_o = op1_i ^ op2_i;	
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
					end

					`INST_OR:begin
						rd_data_o = op1_i | op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
					end

					`INST_AND:begin
						rd_data_o = op1_i & op2_i;
						rd_addr_o = rd_addr_i;
						rd_wen_o = 1'b1;
					end
					
					`INST_SR:begin
						if (funct7[5] == 1'b1) begin	//SRA
							rd_data_o = (((op1_i >> op2_i[4:0]) & SRA_mask)) | (({32{op1_i[31]}}) & (~SRA_mask));
							rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end 
						else begin						//SRL
							rd_data_o = op1_i >> op2_i[4:0];
							rd_addr_o = rd_addr_i;
							rd_wen_o  = 1'b1;							
						end
					end	

					default:begin
						rd_data_o = 32'b0;
						rd_addr_o = 5'b0;
						rd_wen_o = 1'b0;
					end
				endcase
			end

			`INST_TYPE_B:begin
				rd_data_o = 32'b0;
				rd_addr_o = 5'b0;
				rd_wen_o  = 1'b0;
				case (funct3)
					`INST_BEQ:begin
						jump_addr_o	= 	(inst_addr_i + jump_imm) & ({32{(op1_i_equal_op2_i)}});
						jump_en_o	=	op1_i_equal_op2_i;
						hold_flag_o	=	1'b0;
					end
					`INST_BNE:begin
						jump_addr_o	= 	(inst_addr_i + jump_imm) & ({32{(~op1_i_equal_op2_i)}});//不能用jump_en_o信号来进行与操作。输出信号不要再参与控制其他信号，否则会形成逻辑环路！！
						jump_en_o	=	~op1_i_equal_op2_i;
						hold_flag_o	=	1'b0;
					end
					`INST_BLT:begin
						jump_addr_o	= 	(inst_addr_i + jump_imm) & ({32{(op1_i_lt_op2_i)}});
						jump_en_o	=	op1_i_lt_op2_i;
						hold_flag_o	=	1'b0;						
					end
					`INST_BGE:begin		
						jump_addr_o	= 	(inst_addr_i + jump_imm) & ({32{(~op1_i_lt_op2_i)}});
						jump_en_o	=	~op1_i_lt_op2_i;
						hold_flag_o	=	1'b0;						
					end
					`INST_BLTU:begin	
						jump_addr_o	= 	(inst_addr_i + jump_imm) & ({32{(op1_i_ltu_op2_i)}});
						jump_en_o	=	op1_i_ltu_op2_i;
						hold_flag_o	=	1'b0;						
					end
					`INST_BGEU:begin	
						jump_addr_o	= 	(inst_addr_i + jump_imm) & ({32{(~op1_i_ltu_op2_i)}});
						jump_en_o	=	~op1_i_ltu_op2_i;
						hold_flag_o	=	1'b0;						
					end
					default:begin
						jump_addr_o	= 	32'b0;
						jump_en_o	=	1'b0;
						hold_flag_o	=	1'b0;	
					end 
				endcase
			end

			`INST_JAL:begin
				rd_data_o = inst_addr_i + 32'h4;
				rd_addr_o = rd_addr_i;
				rd_wen_o  = 1'b1;
				jump_addr_o	= 	inst_addr_i + op1_i;
				jump_en_o	=	1'b1;
				hold_flag_o	=	1'b0;
			end

			`INST_JALR:begin
				rd_data_o = inst_addr_i + 32'h4;
				rd_addr_o = rd_addr_i;
				rd_wen_o  = 1'b1;
				jump_addr_o	= 	op1_i + op2_i;
				jump_en_o	=	1'b1;
				hold_flag_o	=	1'b0;
			end

			`INST_LUI:begin
				rd_data_o	= 	op1_i;
				rd_addr_o	= 	rd_addr_i;
				rd_wen_o    = 	1'b1;
				jump_addr_o	= 	32'b0;
				jump_en_o	=	1'b0;
				hold_flag_o	=	1'b0;
			end

			`INST_AUIPC:begin
				rd_data_o = op1_i + op2_i;
				rd_addr_o = rd_addr_i;
				rd_wen_o  = 1'b1;
				jump_addr_o	= 	32'b0;
				jump_en_o	=	1'b0;
				hold_flag_o	=	1'b0;
			end

			default:begin
				rd_data_o = 32'b0;
				rd_addr_o = 5'b0;
				rd_wen_o   = 1'b0;
				jump_addr_o	= 	32'b0;
				jump_en_o	=	1'b0;
				hold_flag_o	=	1'b0;	
			end
		endcase
	end
endmodule