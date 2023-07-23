class destination_xtn extends uvm_sequence_item;
	`uvm_object_utils(destination_xtn);
	function new (string name="destination_xtn");
		super.new(name);
	endfunction

	bit[7 : 0] header;    
	bit[7: 0] payload[];
    bit parity;
	
	rand int no_of_cycles;
	//constraint a{no_of_cycles==30;}
	
	function void do_print(uvm_printer printer);
		super.do_print(printer);
		printer.print_field( "header", 		this.header, 	    16,		 UVM_DEC		);
	    foreach(payload[i])
		 printer.print_field( $sformatf("payload[%d]",i), 		this.payload[i], 	    16,		 UVM_DEC		);
        printer.print_field( "parity", 		this.parity, 	    16,		 UVM_DEC		);
	  
	endfunction
endclass
