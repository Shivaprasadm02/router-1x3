class router_base_test extends uvm_test;
	`uvm_component_utils(router_base_test) 	
    router_env router_envh;
	
   router_env_config m_tb_cfg;
   router_src_agent_config m_src_cfg[];
   router_dst_agent_config m_dst_cfg[];
  
	router_vbase_seq vseqh;
 
    int no_of_sagents = 1;
	int no_of_dagents = 3;
    int has_sagent = 1;
    int has_dagent = 1;
	
	bit [1:0] addr= 2'b00;
	//addr=$random(0,1,2);
	//addr=2'b00;

	function new(string name = "router_base_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	
	function void config_router();
	if (has_sagent) 
		begin
			m_src_cfg = new[no_of_sagents];
	
	        foreach(m_src_cfg[i]) 
				begin
					
					m_src_cfg[i]=router_src_agent_config::type_id::create($sformatf("m_src_cfg[%0d]", i));
			
					if(!uvm_config_db #(virtual router_src_if)::get(this,"", $sformatf("vif_%0d",i),m_src_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?") 
					//m_src_cfg[i].is_active = UVM_ACTIVE;
			$display("get to env_src mcfg in test %p",m_src_cfg[i]);
					m_tb_cfg.m_src_agent_cfg[i] = m_src_cfg[i];
             
                end
        end
		
    if (has_dagent) 
		begin
            
            m_dst_cfg = new[no_of_dagents];

			foreach(m_dst_cfg[i])
				begin
					
					m_dst_cfg[i]=router_dst_agent_config::type_id::create($sformatf("m_dst_cfg[%0d]", i));
					
					if(!uvm_config_db #(virtual router_dst_if)::get(this,"", $sformatf("vif_%0d",i),m_dst_cfg[i].vif))
					`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
					//m_dst_cfg[i].is_active = UVM_ACTIVE;
		
					m_tb_cfg.m_dst_agent_cfg[i] = m_dst_cfg[i];
                
                end
        end
		
	
    m_tb_cfg.no_of_sagents = no_of_sagents;
	m_tb_cfg.no_of_dagents = no_of_dagents;
    m_tb_cfg.has_sagent = has_sagent;
    m_tb_cfg.has_dagent = has_dagent;
		
		//m_tb_cfg.has_scoreboard= 1;
		
	endfunction 


	function void build_phase(uvm_phase phase);
   
	m_tb_cfg=router_env_config::type_id::create("m_tb_cfg");
    if(has_sagent)
        m_tb_cfg.m_src_agent_cfg = new[no_of_sagents];
    if(has_dagent)
       m_tb_cfg.m_dst_agent_cfg = new[no_of_dagents];
    config_router;
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_tb_cfg);
	
			addr={$urandom}%3;
	
	uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
	
	$display("env cfg set in test %p", m_tb_cfg);
	
    super.build();
	router_envh=router_env::type_id::create("router_envh", this);
	endfunction

/*
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction
*/
	task run_phase(uvm_phase phase);

		phase.raise_objection(this);
	/*
		router_sseqh=router_sbase_seq::type_id::create("router_sseqh");
		router_dseqh=router_dbase_seq::type_id::create("router_dseqh");

		router_sseqh.start(router_envh.sagt_top.agnth.seqrh);
		router_dseqh.start(router_envh.dagt_top.agnth.seqrh);
	*/
		vseqh=router_vbase_seq::type_id::create("vseqh");
		vseqh.start(router_envh.v_sequencer);
		phase.drop_objection(this);
endtask 
	
endclass

	
	
	
	
	
class router_rand_addr_test extends router_base_test;

  
	`uvm_component_utils(router_rand_addr_test)

   router_rand_vseq rand_seqh;
	
 	function new(string name = "router_rand_addr_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
    super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
    phase.raise_objection(this);
	
    rand_seqh=router_rand_vseq::type_id::create("rand_seqh");
	
    rand_seqh.start(router_envh.v_sequencer);
	
    phase.drop_objection(this);
endtask   

endclass
	/*
	
	
	
class ram_single_addr_test extends ram_base_test;

  
	// Factory Registration
	`uvm_component_utils(ram_single_addr_test)

	// Declare the handle for  ram_single_vseq virtual sequence
    ram_single_vseq ram_seqh;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_single_addr_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function ram_single_addr_test::new(string name = "ram_single_addr_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void ram_single_addr_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task ram_single_addr_test::run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	//create instance for sequence
    ram_seqh=ram_single_vseq::type_id::create("ram_seqh");
	//start the sequence wrt virtual sequencer
    ram_seqh.start(ram_envh.v_sequencer);
	//drop objection
    phase.drop_objection(this);
endtask   


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

// Extend ram_ten_addr_test from ram_base_test;
class ram_ten_addr_test extends ram_base_test;

  
	// Factory Registration
	`uvm_component_utils(ram_ten_addr_test)

	// Declare the handle for  ram_ten_vseq virtual sequence
    ram_ten_vseq ram_seqh;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_ten_addr_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

// Define Constructor new() function
function ram_ten_addr_test::new(string name = "ram_ten_addr_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void ram_ten_addr_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task ram_ten_addr_test::run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	//create instance for sequence
    ram_seqh=ram_ten_vseq::type_id::create("ram_seqh");
	//start the sequence wrt virtual sequencer
    ram_seqh.start(ram_envh.v_sequencer);
	//drop objection
    phase.drop_objection(this);
endtask   


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

// Extend ram_odd_addr_test from ram_base_test;
class ram_odd_addr_test extends ram_base_test;

  
	// Factory Registration
	`uvm_component_utils(ram_odd_addr_test)

	// Declare the handle for  ram_odd_vseq virtual sequence
    ram_odd_vseq ram_seqh;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_odd_addr_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

// Define Constructor new() function
function ram_odd_addr_test::new(string name = "ram_odd_addr_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void ram_odd_addr_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


//-----------------  run() phase method  -------------------//
task ram_odd_addr_test::run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	//create instance for sequence
    ram_seqh=ram_odd_vseq::type_id::create("ram_seqh");
	//start the sequence wrt virtual sequencer
    ram_seqh.start(ram_envh.v_sequencer);
	//drop objection
    phase.drop_objection(this);
endtask   


//------------------------------------------
// CLASS DESCRIPTION
//------------------------------------------

// Extend ram_even_addr_test from ram_base_test;
class ram_even_addr_test extends ram_base_test;

  
	// Factory Registration
	`uvm_component_utils(ram_even_addr_test)

	// Declare the handle for  ram_even_vseq virtual sequence
    ram_even_vseq ram_seqh;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_even_addr_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function ram_even_addr_test::new(string name = "ram_even_addr_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void ram_even_addr_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//-----------------  run() phase method  -------------------//
task ram_even_addr_test::run_phase(uvm_phase phase);
	//raise objection
    phase.raise_objection(this);
	//create instance for sequence
    ram_seqh=ram_even_vseq::type_id::create("ram_seqh");
	//start the sequence wrt virtual sequencer
    ram_seqh.start(ram_envh.v_sequencer);
	//drop objection
    phase.drop_objection(this);
endtask   


class ram_d1_addr_test extends ram_base_test;

	`uvm_component_utils(ram_d1_addr_test)

    ram_d1_vseq ram_seqh;
	
 	function new(string name = "ram_d1_addr_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		ram_seqh=ram_d1_vseq::type_id::create("ram_seqh");
		ram_seqh.start(ram_envh.v_sequencer);
		phase.drop_objection(this);
	endtask   
endclass

class ram_d2_addr_test extends ram_base_test;

	`uvm_component_utils(ram_d2_addr_test)

    ram_d2_vseq ram_seqh;
	
 	function new(string name = "ram_d2_addr_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		ram_seqh=ram_d2_vseq::type_id::create("ram_seqh");
		ram_seqh.start(ram_envh.v_sequencer);
		phase.drop_objection(this);
	endtask   
endclass

class ram_d3_addr_test extends ram_base_test;

	`uvm_component_utils(ram_d3_addr_test)

    ram_d3_vseq ram_seqh;
	
 	function new(string name = "ram_d3_addr_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		ram_seqh=ram_d3_vseq::type_id::create("ram_seqh");
		ram_seqh.start(ram_envh.v_sequencer);
		phase.drop_objection(this);
	endtask   
endclass

class ram_d4_addr_test extends ram_base_test;

	`uvm_component_utils(ram_d4_addr_test)

    ram_d4_vseq ram_seqh;
	
 	function new(string name = "ram_d4_addr_test" , uvm_component parent);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		  super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		ram_seqh=ram_d4_vseq::type_id::create("ram_seqh");
		ram_seqh.start(ram_envh.v_sequencer);
		phase.drop_objection(this);
	endtask   
endclass


*/
