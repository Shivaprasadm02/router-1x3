
class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(router_vbase_seq)  
       
	router_src_sequencer src_seqrh[];
	router_dst_sequencer dst_seqrh[];
	
    router_virtual_sequencer vsqrh;
	
	bit [1:0]addr;
	//uvm_config_db #(addr)::get(this,"*","addr",addr);
	
	//router_sbase_seq sseqh;
	//router_dbase_seq dseqh;
	

  /*
	ram_single_addr_wr_xtns single_wxtns;
	ram_single_addr_rd_xtns single_rxtns;

	ram_ten_wr_xtns ten_wxtns;
	ram_ten_rd_xtns ten_rxtns;

	ram_even_wr_xtns even_wxtns;
	ram_even_rd_xtns even_rxtns;

	ram_odd_wr_xtns odd_wxtns;
	ram_odd_rd_xtns odd_rxtns;
	
	ram_d1_wr_xtns d1_wxtns;
	ram_d1_rd_xtns d1_rxtns;
	
	ram_d2_wr_xtns d2_wxtns;
	ram_d2_rd_xtns d2_rxtns;
	
	ram_d3_wr_xtns d3_wxtns;
	ram_d3_rd_xtns d3_rxtns;
	
	ram_d4_wr_xtns d4_wxtns;
	ram_d4_rd_xtns d4_rxtns;
  */
	router_env_config m_cfg;

 	extern function new(string name = "router_vbase_seq");
	extern task body();
endclass 

function router_vbase_seq::new(string name ="router_vbase_seq");
	super.new(name);
endfunction

task router_vbase_seq::body();
	 if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal("error","err");
	
	if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	
	src_seqrh = new[m_cfg.no_of_sagents];
	dst_seqrh = new[m_cfg.no_of_dagents]; 
  
  assert($cast(vsqrh,m_sequencer)) 
  else
	begin
		`uvm_error("BODY", "Error in $cast of virtual sequencer")
	end
	
	foreach(src_seqrh[i])
	begin
		src_seqrh[i] = vsqrh.src_seqrh[i];
		//sseqh.start(src_seqrh[i]);
		end
		
	foreach(dst_seqrh[i])
	begin
		dst_seqrh[i] = vsqrh.dst_seqrh[i];
		//dseqh.start(dst_seqrh[i]);
	end
		
	
endtask: body

//------------------
//---rand clas------------
//-----------------

class router_rand_vseq extends router_vbase_seq;

	`uvm_object_utils(router_rand_vseq)
	
	router_rand_src_xtns rand_sxtns;
	router_rand_dst_xtns rand_dxtns;
	
 	function new(string name = "router_rand_vseq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
  
    rand_sxtns= router_rand_src_xtns::type_id::create("rand_sxtns");
    rand_dxtns= router_rand_dst_xtns::type_id::create("rand_dxtns");
	
	
	fork
		begin
			rand_sxtns.start(src_seqrh[0]);
		end
		begin
			if(addr==00)
				rand_dxtns.start(dst_seqrh[0]);
			if(addr==01)
				rand_dxtns.start(dst_seqrh[1]);
			if(addr==10)
				rand_dxtns.start(dst_seqrh[2]);
		end
	join
	/*
    if(m_cfg.has_sagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_sagents; i++)
            
	        rand_sxtns.start(src_seqrh[i]);
        end

    if(m_cfg.has_dagent) 
		begin
            for (int i=0 ; i < m_cfg.no_of_dagents; i++)
			  
	        rand_dxtns.start(dst_seqrh[i]);
        end 
		*/
	endtask
	
endclass


/*
   

//------------------------------------------------------------------------------
//                 single address sequence

//------------------------------------------------------------------------------
// Extend ram_single_vseq from ram_vbase_seq
class ram_single_vseq extends ram_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(ram_single_vseq)

    //------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_single_vseq");
	extern task body();
endclass : ram_single_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
function ram_single_vseq::new(string name ="ram_single_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task ram_single_vseq::body();
    super.body();
    // create the instances for ram_single_addr_wr_xtns & ram_single_addr_rd_xtns
    single_wxtns= ram_single_addr_wr_xtns::type_id::create("single_wxtns");
    single_rxtns= ram_single_addr_rd_xtns::type_id::create("single_rxtns");

    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++)
            // Start the write sequence on all the write sequencers 
	        single_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent) 
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++)
			// Start the read sequence on all the read sequencers  
	        single_rxtns.start(rd_seqrh[i]);
        end 

endtask

//------------------------------------------------------------------------------
//                 ten address sequence

//------------------------------------------------------------------------------
// Extend ram_ten_vseq from uvm_sequence
class ram_ten_vseq extends ram_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(ram_ten_vseq)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "ram_ten_vseq");
	extern task body();
endclass : ram_ten_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
function ram_ten_vseq::new(string name ="ram_ten_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task ram_ten_vseq::body();
    super.body();
    // create the instances for ram_ten_wr_xtns & ram_ten_rd_xtns
    ten_wxtns= ram_ten_wr_xtns::type_id::create("ten_wxtns");
    ten_rxtns= ram_ten_rd_xtns::type_id::create("ten_rxtns");

    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
			// Start the write sequence on all the write sequencers
	        ten_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
			// Start the read sequence on all the read sequencers
	        ten_rxtns.start(rd_seqrh[i]);
        end 

endtask



//------------------------------------------------------------------------------
//                 even sequence

//------------------------------------------------------------------------------
// Extend ram_even_vseq from ram_vbase_seq
class ram_even_vseq extends ram_vbase_seq;

    // Factory Registration
	`uvm_object_utils(ram_even_vseq)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_even_vseq");
	extern task body();
endclass : ram_even_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
function ram_even_vseq::new(string name ="ram_even_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//


task ram_even_vseq::body();
    super.body();
	// create the instances for ram_even_wr_xtns & ram_even_rd_xtns
    even_wxtns= ram_even_wr_xtns::type_id::create("even_wxtns");
    even_rxtns= ram_even_rd_xtns::type_id::create("even_rxtns");

    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
			// Start the write sequence on all the write sequencers
				even_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++)
			// Start the read sequence on all the read sequencers
				even_rxtns.start(rd_seqrh[i]);
        end 

endtask


//------------------------------------------------------------------------------
//                 odd sequence

//------------------------------------------------------------------------------
// Extend ram_odd_vseq from ram_vbase_seq
class ram_odd_vseq extends ram_vbase_seq;

    // Factory Registration
	`uvm_object_utils(ram_odd_vseq)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "ram_odd_vseq");
	extern task body();
endclass : ram_odd_vseq  
//-----------------  constructor new method  -------------------//

// Add constructor 
function ram_odd_vseq::new(string name ="ram_odd_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//


task ram_odd_vseq::body();
    super.body();
	// create the instances for ram_odd_wr_xtns & ram_odd_rd_xtns
    odd_wxtns= ram_odd_wr_xtns::type_id::create("odd_wxtns");
    odd_rxtns= ram_odd_rd_xtns::type_id::create("odd_rxtns");
  
    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the write sequence on all the write sequencers
				odd_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the read sequence on all the read sequencers
	            odd_rxtns.start(rd_seqrh[i]);
        end 

endtask

class ram_d1_vseq extends ram_vbase_seq;

	`uvm_object_utils(ram_d1_vseq)

 	function new(string name = "ram_d1_vseq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
	// create the instances for ram_odd_wr_xtns & ram_odd_rd_xtns
    d1_wxtns= ram_d1_wr_xtns::type_id::create("d1_wxtns");
    d1_rxtns= ram_d1_rd_xtns::type_id::create("d1_rxtns");
  
    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the write sequence on all the write sequencers
				d1_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the read sequence on all the read sequencers
	            d1_rxtns.start(rd_seqrh[i]);
        end 

	endtask
endclass

class ram_d2_vseq extends ram_vbase_seq;

	`uvm_object_utils(ram_d2_vseq)

 	function new(string name = "ram_d2_vseq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
	// create the instances for ram_odd_wr_xtns & ram_odd_rd_xtns
    d2_wxtns= ram_d2_wr_xtns::type_id::create("d2_wxtns");
    d2_rxtns= ram_d2_rd_xtns::type_id::create("d2_rxtns");
  
    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the write sequence on all the write sequencers
				d2_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the read sequence on all the read sequencers
	            d2_rxtns.start(rd_seqrh[i]);
        end 

	endtask
endclass

class ram_d3_vseq extends ram_vbase_seq;

	`uvm_object_utils(ram_d3_vseq)

 	function new(string name = "ram_d2_vseq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
	// create the instances for ram_odd_wr_xtns & ram_odd_rd_xtns
    d3_wxtns= ram_d3_wr_xtns::type_id::create("d3_wxtns");
    d3_rxtns= ram_d3_rd_xtns::type_id::create("d3_rxtns");
  
    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the write sequence on all the write sequencers
				d3_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the read sequence on all the read sequencers
	            d3_rxtns.start(rd_seqrh[i]);
        end 

	endtask
endclass

class ram_d4_vseq extends ram_vbase_seq;

	`uvm_object_utils(ram_d4_vseq)

 	function new(string name = "ram_d4_vseq");
		super.new(name);
	endfunction
	
	task body();
		super.body();
	// create the instances for ram_odd_wr_xtns & ram_odd_rd_xtns
    d4_wxtns= ram_d4_wr_xtns::type_id::create("d4_wxtns");
    d4_rxtns= ram_d4_rd_xtns::type_id::create("d4_rxtns");
  
    if(m_cfg.has_wagent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the write sequence on all the write sequencers
				d4_wxtns.start(wr_seqrh[i]);
        end

    if(m_cfg.has_ragent)
		begin
            for (int i=0 ; i < m_cfg.no_of_duts; i++) 
				// Start the read sequence on all the read sequencers
	            d4_rxtns.start(rd_seqrh[i]);
        end 

	endtask
endclass

*/
