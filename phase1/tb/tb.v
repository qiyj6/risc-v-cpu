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
        $readmemh("D:/Learning/verilog/cpu/prj/phase2/bin_inst_test_file/generated/rv32ui-p-add.txt", tb.risc_v_cpu1.rom1.rom_mem);
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
        wait(x26 == 32'b1); 
        #(200);     
        if(x27 == 32'b1)begin
            $display("pass");
        end
        else begin
            $display("something wrong!");
            $display("x3 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[3]);
            for (r = 0; r <31; r = r + 1'b1) begin
                 $display("x%2d register value is %d", r, tb.risc_v_cpu1.risc_v_top1.regs1.regs[r]);
            end
        end

    end

endmodule