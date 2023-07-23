class router_dst_monitor extends uvm_monitor;
	
	`uvm_component_utils(router_dst_monitor)
	
	virtual router_dst_if.DMON_MP vif;
    router_dst_agent_config m_cfg;
	
	function new(string name ="router_dst_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	    if(!uvm_config_db #(router_dst_agent_config)::get(this,"","router_dst_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
    endfunction
	
	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
    endfunction
	
	task run_phase(uvm_phase phase);
	 forever
	 begin
		collect_data();
		#1000 $finish;
		end
	endtask
	
	task collect_data();
     destination_xtn data_sent;
	 data_sent= destination_xtn::type_id::create("data_sent");
	
	 @(vif.dst_mon);
		wait(vif.dst_mon.rd_enb)
			//@(vif.dst_mon);
			data_sent.header=vif.dst_mon.d_out;
			data_sent.payload=new[data_sent.header[7:2]];
			//$display("got data in dst mon");
			//$display(" %p", data_sent);
			//@(vif.dst_mon);
			foreach(data_sent.payload[i])
			begin
				data_sent.payload[i]=vif.dst_mon.d_out;
				@(vif.dst_mon);
			end
		data_sent.parity=vif.dst_mon.d_out;
	
				@(vif.dst_mon);
			//data_sent.print(uvm_default_table_printer); 
  	
       endtask
	
endclass
