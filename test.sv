`timescale 1ns/100ps
// random
class Packet;
    rand bit [15:0] rdata;
    bit tparity;
    bit tparitysel;
    function new(bit [2:0] tparitysel = 0);
        this.tparitysel = tparitysel;
    endfunction

    function void paritygen();
        this.tparity = this.tparitysel? (~(^this.rdata[15:0])): ^this.rdata[15:0];
    endfunction
    
endclass : Packet

// program
program automatic test(router_io.TB router_io);
    Packet p;
    bit parity1;
    bit [15:0] rdata;
    initial begin
        reset();
        fork
            send(p);
            check_send(p);
        join_any
        reset();
        fork
            receive(p);
            check_recieve();
        join
        reset();
    end

// reset
    task reset();
            router_io.HRESETn       <= 1'b0  ;

            router_io.cb.HADDR      <=32'h00;
            router_io.cb.HTRANS     <=2'b0;
            router_io.cb.HWDATA     <=32'b0;
            router_io.cb.HWRITE     <=0;
            router_io.cb.HSEL       <=0;
            router_io.cb.HREADY     <=0;
            router_io.cb.GPIOIN     <=17'b00000000000000000;
            router_io.cb.PARITYSEL  <=0;


        #2  router_io.cb.HRESETn    <= 1'b1 ;
        
            @(router_io.cb);
    endtask: reset
// send
    task send(ref Packet p);
        dir_addr();
        send_dir(.model(1));
        repeat(5) 
            send_data(p);
    endtask: send

    task automatic send_data(ref Packet p);
        p = new();
        p.paritygen;

        assert(p.randomize) else $fatal;

        router_io.cb.HWDATA     <=  {16'h0,p.rdata};
        @(router_io.cb);
    endtask: send_data

    task automatic check_send(ref Packet p);
        forever begin
            logic [15:0] reg_rdata;
            reg_rdata = p.rdata;
            $display("befor detect:", router_io.cb.GPIOOUT);
            $display("reg_rdata = %0h", reg_rdata);
            @(router_io.cb.GPIOOUT);
            $display("after detect: GPIOOUT = %0h", router_io.cb.GPIOOUT);
            if ((reg_rdata == router_io.cb.GPIOOUT[15:0]) & (parity1 == router_io.cb.GPIOOUT[16]))
                $display("time = %0t, Send Correct information", $realtime);
            else
                $display("time = %0t, Here is Bug", $time);
        end
    endtask : check_send

// receive
    task receive(ref Packet p);
        dir_addr();
        receive_dir(.model(0));
        repeat(5) 
            receive_data(p);
        recevie_bug(p);
    endtask: receive

    task receive_data(ref Packet p);
        p = new();
        p.paritygen();
        assert(p.randomize) else $fatal;
        router_io.cb.GPIOIN     <=  {15'h0,{p.tparity,p.rdata}};
        @(router_io.cb); 
    endtask: receive_data

    task recevie_bug(ref Packet p);
        p = new(1);
        p.paritygen();
        assert(p.randomize) else $fatal;
        router_io.cb.GPIOIN     <=  {15'h0,{p.tparity,p.rdata}};
        @(router_io.cb); 
    endtask: recevie_bug

    task automatic check_recieve(); 
        logic [15:0] reg_GPIOIN;
        reg_GPIOIN = router_io.cb.GPIOIN[15:0];//Cannot detect the first 0
        @(router_io.cb.GPIOIN);
        if ((reg_GPIOIN == router_io.cb.HRDATA) & (~router_io.cb.PARITYERR))
            $display("$t, Receive Correct information", $realtime);
        else
            $display("$t, Here is Bug", $realtime);
    endtask: check_recieve


// 
    task dir_addr();
        router_io.cb.HADDR      <=  32'h04;
        router_io.cb.HTRANS     <=  2'b11;
        router_io.cb.HWRITE     <=  1;
        router_io.cb.HSEL       <=  1;
        router_io.cb.HREADY     <=  1;
        router_io.cb.PARITYSEL  <=  0;
        @(router_io.cb);
    endtask: dir_addr

    task receive_dir(bit[31:0] model);
        router_io.cb.HADDR      <=  32'h00;
        router_io.cb.HWDATA     <=  model;
        @(router_io.cb);
    endtask: receive_dir

    task send_dir(bit[31:0] model);
        router_io.cb.HADDR      <=  32'h00;
        router_io.cb.HWDATA     <=  model;
        @(router_io.cb);
    endtask: send_dir


endprogram
