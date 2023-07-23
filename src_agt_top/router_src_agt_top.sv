
	class router_src_agt_top extends uvm_env;

	`uvm_component_utils(router_src_agt_top)
  
      	 router_src_agent agnth;
	
	function new(string name = "router_src_agt_top" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
    function void build_phase(uvm_phase phase);
     		super.build_phase(phase);
			
			//agnth=new[m_cfg.no_of_sagent];
   		//foreach(agnth[i])
		//agnth[i]=router_src_agent::type_id::create($sformatf("agnth[%0d]",i),this);
		agnth=router_src_agent::type_id::create("agnth",this);
	endfunction
	
	task run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask   

endclass
