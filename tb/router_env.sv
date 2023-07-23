class router_env extends uvm_env;

    `uvm_component_utils(router_env)

	router_src_agt_top sagt_top[];	
	router_dst_agt_top dagt_top[];
	
	router_virtual_sequencer v_sequencer;

	//router_scoreboard sb[];

    router_env_config m_cfg;

	function new(string name = "router_env", uvm_component parent);
		super.new(name,parent);
	endfunction

    function void build_phase(uvm_phase phase);
	//m_cfg.m_src_agent_cfg=new[m_cfg.no_of_sagents];
	//m_cfg=router_env_config::type_id::create("m_cfg");
	
	  if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
		$display("get to env_cfg in env frm test %p",m_cfg);
            if(m_cfg.has_sagent) 
			begin
	    sagt_top = new[m_cfg.no_of_sagents];
		//m_cfg.m_src_agent_cfg=new[m_cfg.no_of_sagents];
		foreach(sagt_top[i])
		begin
            uvm_config_db #(router_src_agent_config)::set(this,$sformatf("sagt_top[%0d]*",i),  "router_src_agent_config", m_cfg.m_src_agent_cfg[i]);
	        sagt_top[i]=router_src_agt_top::type_id::create($sformatf("sagt_top[%0d]",i) ,this);
		end
		end
             
          if(m_cfg.has_dagent == 1) 
		  begin       
		  dagt_top = new[m_cfg.no_of_dagents];
	
            foreach(dagt_top[i]) 
			begin
               uvm_config_db #(router_dst_agent_config)::set(this,$sformatf("dagt_top[%0d]*",i),  "router_dst_agent_config", m_cfg.m_dst_agent_cfg[i]);
	           dagt_top[i]=router_dst_agt_top::type_id::create($sformatf("dagt_top[%0d]",i) ,this);
            end
		 end
             
        	super.build_phase(phase);
               if(m_cfg.has_virtual_sequencer)

	         v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
             //  if(m_cfg.has_scoreboard) begin


            //sb = new[1];
			// Create the instances of ram_scoreboard  
           // foreach (sb[i]) 
             //   sb[i] = router_scoreboard::type_id::create($sformatf("sb[%0d]",i),this);
//
            //   end
	endfunction
	
function void connect_phase(uvm_phase phase);
    if(m_cfg.has_virtual_sequencer)
		begin
            if(m_cfg.has_sagent)
				foreach(sagt_top[i]) 
					begin 
							v_sequencer.src_seqrh[i] = sagt_top[i].agnth.seqrh;                    
					end
                        
			if(m_cfg.has_dagent) 
				begin
					foreach(dagt_top[i]) 
						v_sequencer.dst_seqrh[i] = dagt_top[i].agnth.seqrh;
                end
        end
/*
   		     if(m_cfg.has_scoreboard) 
			 begin
    		
    		foreach(wagt_top[i])
     				wagt_top[i].agnth.monh.monitor_port.connect(sb[i].fifo_wrh.analysis_export);
   			foreach(ragt_top[i])
      				ragt_top[i].agnth.monh.monitor_port.connect(sb[i].fifo_rdh.analysis_export);

		     end
			 */
			endfunction
		
endclass
