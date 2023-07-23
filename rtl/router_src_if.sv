interface router_src_if(input bit clk);

bit resetn;

logic [7:0]d_in;
logic pkt_vld;

logic error;
logic busy;

clocking src_drv@(posedge clk);
	default input #1 output #1;
	output d_in,pkt_vld,resetn;
	input error,busy;
endclocking

clocking src_mon@(negedge clk);
	default input #1 output #1;
	input d_in,pkt_vld;
	input error,busy;
endclocking

modport SDR_MP(clocking src_drv);
modport SMON_MP(clocking src_mon);

endinterface
