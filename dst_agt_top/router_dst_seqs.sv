class router_dbase_seq extends uvm_sequence #(destination_xtn);  

	`uvm_object_utils(router_dbase_seq)  
	
	//bit [1:0]addr;
	
    function new(string name ="router_dbase_seq");
		super.new(name);
	endfunction
	/*
	task body();
    repeat(10)
	begin
		req=destination_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize());
		finish_item(req); 	
	end
	endtask
	*/
	
endclass

class router_rand_dst_xtns extends router_dbase_seq;
  	
	`uvm_object_utils(router_rand_dst_xtns)

    function new(string name ="router_rand_dst_xtns");
		super.new(name);
	endfunction
	
    task body();
    repeat(10)
	begin
	//if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
		//`uvm_fatal("error","err");
		req=destination_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {no_of_cycles==3;});
		finish_item(req); 	
	end
	endtask
	
endclass