class router_sbase_seq extends uvm_sequence #(source_xtn);  

	`uvm_object_utils(router_sbase_seq)  
	
	bit [1:0]addr;
	
    function new(string name ="router_sbase_seq");
		super.new(name);
	endfunction
	
	//uvm_config_db #(addr)::get(this,"*","addr",addr);
	
	/*
	task body();
    repeat(10)
	begin
		req=source_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		finish_item(req); 	
	end
	endtask
	*/
	
endclass

class router_rand_src_xtns extends router_sbase_seq;
  	
	`uvm_object_utils(router_rand_src_xtns)

    function new(string name ="router_rand_src_xtns");
		super.new(name);
	endfunction
	
    task body();
    repeat(10)
	begin
		if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
			`uvm_fatal("error","err");
	
		req=source_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[1:0]==addr;})
		finish_item(req); 	
	end
	endtask
	
endclass

