`timescale 1ns/100ps
	program automatic test(router_io.TB router_io);
        logic [16:0] tgpioin;
        logic [15:0] tgpioout_0;
        logic [16:0] tgpioout;
        logic paritygen;
        logic tparitysel = 0;
        logic parityres;
        logic [15:0] seed = 0;
        initial begin
            reset();
            send();
            receive();
        end
        
        initial
            repeat(10) 
                gen();

        initial
            repeat(20)
                parity();


////////////////////////////////////////
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

        task automatic gen(); 
            seed = seed + 1;
            tgpioin         = $random(seed);
            tgpioin[16]     = tparitysel? (~(^tgpioin[15:0])): ^tgpioin[15:0];            
            @(router_io.cb);
        endtask: gen

        task send();
            send_addr();
            send_dir();
            repeat(5) 
                send_data();
        endtask: send

        task send_addr();
            router_io.cb.HADDR      <=  32'h04;
            router_io.cb.HTRANS     <=  2'b11;
            router_io.cb.HWRITE     <=  1;
            router_io.cb.HSEL       <=  1;
            router_io.cb.HREADY     <=  1;
            router_io.cb.PARITYSEL  <=  tparitysel;
            @(router_io.cb);
        endtask: send_addr

        task send_dir();
            router_io.cb.HADDR      <=  32'h00;
            router_io.cb.HWDATA     <=  32'b1;
            @(router_io.cb);
        endtask: send_dir

        task send_data();
            router_io.cb.HWDATA     <=  tgpioin;
            @(router_io.cb);
        endtask: send_data
///////////////////////////////////////////////////////////////////
        task receive();
            receive_addr();
            receive_dir();
            repeat(5) 
                receive_data();
        endtask: receive
        
        task receive_addr();
            router_io.cb.HADDR      <=  32'h04;
            router_io.cb.HTRANS     <=  2'b11;
            router_io.cb.HWRITE     <=  1;
            router_io.cb.HSEL       <=  1;
            router_io.cb.HREADY     <=  1;
            router_io.cb.PARITYSEL  <=  tparitysel;
            @(router_io.cb);
        endtask: receive_addr

        task receive_dir();
            router_io.cb.HADDR      <=  32'h00;
            router_io.cb.HWDATA     <=  32'b0;
            @(router_io.cb);
        endtask: receive_dir

        task receive_data();
            router_io.cb.GPIOIN    <=  tgpioout;
            @(router_io.cb); 
        endtask: receive_data

       task automatic parity(); 
            seed        = seed + 1;
            tgpioout_0  = $random(seed); 
            paritygen   = tparitysel? (~(^tgpioout_0[15:0])): ^tgpioout_0[15:0];
            tgpioout    = {paritygen,tgpioout_0};
            @(router_io.cb);
        endtask: parity

	endprogram: test