class router_dst_sequencer extends uvm_sequencer #(destination_xtn);

	`uvm_component_utils(router_dst_sequencer)

	function new(string name = "router_dst_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction

endclass
