`timescale 1ns/1ns
`define time_period 20 

module tb;

    reg clk;
    reg rst_n;

    wire [31:0] x3 = tb.risc_v_cpu1.risc_v_top1.regs1.regs[3];
    wire [31:0] x26 = tb.risc_v_cpu1.risc_v_top1.regs1.regs[26];
    wire [31:0] x27 = tb.risc_v_cpu1.risc_v_top1.regs1.regs[27];

    integer r;

    risc_v_cpu risc_v_cpu1(
        .clk     (clk),
        .rst_n   (rst_n)
    );

    always #(`time_period/2) clk = ~clk;

    initial begin
        clk <= 1;
        rst_n <= 0;
        #30;
        rst_n <= 1;

    end

    //rom init
    initial begin
        //I type inst tb                        all pass
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-srai.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-slti.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-sltiu.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-ori.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-xori.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-srli.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-andi.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-slli.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-srli.txt", tb.risc_v_cpu1.rom1.rom_mem);


        //branch type inst tb                   all pass
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-bne.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-beq.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-bge.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-bgeu.txt", tb.risc_v_cpu1.rom1.rom_mem);
        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-blt.txt", tb.risc_v_cpu1.rom1.rom_mem);
        $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-bltu.txt", tb.risc_v_cpu1.rom1.rom_mem);

        // $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-lui.txt", tb.risc_v_cpu1.rom1.rom_mem);
    end

    initial begin
        // while(1) begin
        //     @(posedge clk) begin
        //         $display("x27 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[27]);
        //         $display("x28 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[28]);
        //         $display("x29 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[29]);
        //         $display("-------------------------------------------------------------------");
        //     end
        // end
        wait((x26 == 32'b1)||(x27 == 32'b1)); 
        #(200);     
        if((x26 == 32'b1)&&(x27 == 32'b1))begin
            $display("-------------------------------------------------------------------");
            $display("--------------------------------pass!------------------------------");
            $display("-------------------------------------------------------------------");
        end
        else begin
            $display("-------------------------------------------------------------------");
            $display("--------------------------something wrong!-------------------------");
            $display("-------------------------------------------------------------------");
            $display("x3 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[3]);
            for (r = 0; r <31; r = r + 1'b1) begin
                 $display("x%2d register value is %d", r, tb.risc_v_cpu1.risc_v_top1.regs1.regs[r]);
            end
        end

    end

endmodule