`timescale 1ns/100ps

interface router_io(input bit HCLK);
    logic HRESETn;
    logic [31:0] HADDR;
    logic [1:0] HTRANS;
    logic [31:0] HWDATA;
    logic HWRITE;
    logic HSEL;
    logic HREADY;
    logic [16:0] GPIOIN;// 17bit for parity
    
    //Output
    logic HREADYOUT;
    logic [31:0] HRDATA;
    logic [16:0] GPIOOUT;// 17bit for parity
    
    //Parity Check
    logic PARITYSEL;
    logic PARITYERR;


    clocking cb @(posedge HCLK);
        
        default input #1ns output #1ns; //输出在之后1ns 采样，输入在之前1ns 采样
                
            output  HRESETn;
            output  HADDR;
            output  HTRANS;
            output  HWDATA;
            output  HWRITE;
            output  HSEL;
            output  HREADY;
            output  GPIOIN;// 17bit for parity
                
                //Output
            input   HREADYOUT;
            input   HRDATA;
            input   GPIOOUT;// 17bit for parity
            
            //Parity Check
            output  PARITYSEL;
            input   PARITYERR; 
    endclocking: cb

    modport TB(clocking cb, output HRESETn); //should include timing signal and asynchronous signal (reset)
endinterface: router_io

