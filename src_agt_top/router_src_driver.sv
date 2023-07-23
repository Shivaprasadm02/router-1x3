class router_src_driver extends uvm_driver #(source_xtn);
	
	`uvm_component_utils(router_src_driver)
	
   	virtual router_src_if.SDR_MP vif;
    router_src_agent_config m_cfg;

	function new(string name ="router_src_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	   if(!uvm_config_db #(router_src_agent_config)::get(this,"","router_src_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?") 
    endfunction

	function void connect_phase(uvm_phase phase);
		vif = m_cfg.vif;
	//$display("vif in driver of src  %p",m_cfg.vif);
    endfunction
	
	task run_phase(uvm_phase phase);
	
	@(vif.src_drv);
	vif.src_drv.resetn <=0;
	@(vif.src_drv);
	vif.src_drv.resetn <=1;
	
		forever
		begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
		end
	endtask
	
	task send_to_dut(source_xtn xtn);
	
		//@(vif.src_drv);
             wait(!vif.src_drv.busy)
			 @(vif.src_drv);
              vif.src_drv.pkt_vld <=1;
              vif.src_drv.d_in <= xtn.header;

        @(vif.src_drv);
			  foreach(xtn.payload[i])
				begin	
					wait(!vif.src_drv.busy)
						vif.src_drv.d_in<=xtn.payload[i];
							@(vif.src_drv);
						$display("interface data %d",vif.src_drv.d_in);
				end
			wait(!vif.src_drv.busy)	
		//@(vif.src_drv);
			   vif.src_drv.pkt_vld <=0;
			   vif.src_drv.d_in<=xtn.parity;

        //repeat(2)
           @(vif.src_drv);
			
	  `uvm_info("ROUTER_SRC_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
   	 
	endtask

endclass


 


	


