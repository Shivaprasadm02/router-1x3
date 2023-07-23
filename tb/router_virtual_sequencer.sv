
class router_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item) ;
   
	`uvm_component_utils(router_virtual_sequencer)
	
router_src_sequencer src_seqrh[];
router_dst_sequencer dst_seqrh[];	

  	router_env_config m_cfg;

 	function new(string name = "router_virtual_sequencer",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
	
	  if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
    		 super.build_phase(phase);
	src_seqrh=new[m_cfg.no_of_sagents];
	foreach(src_seqrh[i])
	src_seqrh[i]=router_src_sequencer::type_id::create($sformatf("src_seqrh[%0d]",i),this);
    		
	dst_seqrh=new[m_cfg.no_of_dagents];
	foreach(dst_seqrh[i])
	dst_seqrh[i]=router_dst_sequencer::type_id::create($sformatf("dst_seqrh[%0d]",i),this);
	endfunction

endclass
