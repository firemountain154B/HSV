`timescale 1ns/100ps
`include "router_io.sv"
module router_test_top;
    parameter simulation_cycle = 100;
    bit SystemClock;

    
    router_io top_io(SystemClock); 
    test t(top_io);
    initial begin
        SystemClock = 0;
        forever begin
            #(simulation_cycle/2)
                SystemClock = ~SystemClock;
        end 
    end

    AHBGPIO dut(
        .HCLK       (top_io.HCLK),
        .HRESETn    (top_io.HRESETn),
        .HADDR      (top_io.HADDR),
        .HTRANS     (top_io.HTRANS),
        .HWDATA     (top_io.HWDATA),
        .HWRITE     (top_io.HWRITE),
        .HSEL       (top_io.HSEL),
        .HREADY     (top_io.HREADY),
        .GPIOIN     (top_io.GPIOIN),

        .HREADYOUT  (top_io.HREADYOUT),
        .HRDATA     (top_io.HRDATA),
        .GPIOOUT    (top_io.GPIOOUT),   

        .PARITYSEL  (top_io.PARITYSEL),
        .PARITYERR  (top_io.PARITYERR)
    );
endmodule




