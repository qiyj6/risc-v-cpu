`timescale 1ns/1ns
`define time_period 20 

module tb;

    reg clk;
    reg rst_n;

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
        $readmemb("inst_data_ADD.txt", tb.risc_v_cpu1.rom1.rom_mem);
    end

    initial begin
        while(1) begin
            @(posedge clk) begin
                $display("x27 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[27]);
                $display("x28 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[28]);
                $display("x29 register value is %d", tb.risc_v_cpu1.risc_v_top1.regs1.regs[29]);
                $display("-------------------------------------------------------------------");
            end
        end
    end

endmodule