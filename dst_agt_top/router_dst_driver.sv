class router_dst_driver extends uvm_driver #(destination_xtn);
	
	`uvm_component_utils(router_dst_driver)
	
   	virtual router_dst_if.DDR_MP vif;
    router_dst_agent_config m_cfg;

	function new(string name ="router_dst_driver",uvm_component parent);
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
		forever begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask
	
	task send_to_dut(destination_xtn xtn);
	    @(vif.dst_drv);
             wait(vif.dst_drv.vld_out)
			 repeat(xtn.no_of_cycles)
			 begin
             @(vif.dst_drv);
              vif.dst_drv.rd_enb <= 1;
			  end
		@(vif.dst_drv);
			 wait(!vif.dst_drv.vld_out)
             //@(vif.dst_drv);
              vif.dst_drv.rd_enb <= 0;
           
              repeat(2)
              @(vif.dst_drv);
	endtask
	
endclass


 


	


