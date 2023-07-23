class router_src_monitor extends uvm_monitor;
	
	`uvm_component_utils(router_src_monitor)
	
   	virtual router_src_if.SMON_MP vif;
    router_src_agent_config m_cfg;

	function new(string name ="router_src_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	    if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
    endfunction
	
	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
    endfunction
	
	task run_phase(uvm_phase phase);
	 forever
		collect_data;
	endtask
			
	task collect_data();
     source_xtn data_sent;
	 data_sent= source_xtn::type_id::create("data_sent");
	
	 //@(vif.src_mon);
		wait(!vif.src_mon.busy && vif.src_mon.pkt_vld)
			data_sent.header=vif.src_mon.d_in;
			//$display("mon collected data %d",data_sent.header);
			//@(vif.src_mon);
			data_sent.payload=new[data_sent.header[7:2]];
			//$display("payload size is %d",data_sent.payload.size);
			//$display("payload %p",data_sent);
			@(vif.src_mon);
			foreach(data_sent.payload[i])
			begin
			//@(vif.src_mon);
			wait(!vif.src_mon.busy && vif.src_mon.pkt_vld)
				data_sent.payload[i]=vif.src_mon.d_in;
				@(vif.src_mon);
				//$display("payload %p",data_sent);
				//$display($sformatf("mon collected payload[%0d]",data_sent.payload[i]));
				//`uvm_info("SRC_MON_collected data",$sformatf("printing from src monitor \n %s", data_sent.sprint()),UVM_LOW)
			end
			//@(vif.src_mon);	
			wait(!vif.src_mon.busy && !vif.src_mon.pkt_vld)
				data_sent.parity=vif.src_mon.d_in;
	
         `uvm_info("ROUTER_SRC_MONITOR",$sformatf("printing from src monitor \n %s", data_sent.sprint()),UVM_LOW) 
//@(vif.src_mon);
  	 // monitor_port.write(data_sent);
  	
  	  //m_cfg.mon_rcvd_xtn_cnt++;
       endtask
	   
endclass
