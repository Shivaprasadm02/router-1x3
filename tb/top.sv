
module top;

    import router_test_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";

	bit clock;  
	always 
	#10 clock=!clock;     

   router_src_if sin(clock);
   router_dst_if din_0(clock);
   router_dst_if din_1(clock);
   router_dst_if din_2(clock);
   
   //router_base_test test;
   
    router_top DUV(.clk(clock),
					.rstn(sin.resetn),
					.data_in(sin.d_in),
					.pkt_vld(sin.pkt_vld),
					.err(sin.error),
					.busy(sin.busy),
					
					.data_out_0(din_0.d_out),
					.data_out_1(din_1.d_out),
					.data_out_2(din_2.d_out),
					
					.rd_enb_0(din_0.rd_enb),
					.rd_enb_1(din_1.rd_enb),
					.rd_enb_2(din_2.rd_enb),
				
				
					.vld_out_0(din_0.vld_out),
					.vld_out_1(din_1.vld_out),
					.vld_out_2(din_2.vld_out)
					);
			   
    initial
	begin
 
  	uvm_config_db #(virtual router_src_if)::set(null,"*","vif_0",sin);
  	uvm_config_db #(virtual router_dst_if)::set(null,"*","vif_0",din_0);
  	uvm_config_db #(virtual router_dst_if)::set(null,"*","vif_1",din_1);
  	uvm_config_db #(virtual router_dst_if)::set(null,"*","vif_2",din_2);

	//test=new(sin,din_0,din_1,din_2);
	run_test( );
    end  
endmodule


  
   
  
