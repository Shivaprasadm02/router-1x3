interface router_dst_if(input bit clk);

logic [7:0] d_out;
logic vld_out;
logic rd_enb;

clocking dst_drv@(posedge clk);
	default input #1 output #1;
	output rd_enb;
	input vld_out;
endclocking

clocking dst_mon@(negedge clk);
	default input #1 output #1;
	input rd_enb,d_out;
endclocking

modport DDR_MP(clocking dst_drv);
modport DMON_MP(clocking dst_mon);

endinterface
