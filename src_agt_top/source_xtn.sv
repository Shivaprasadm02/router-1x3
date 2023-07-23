class source_xtn extends uvm_sequence_item;
	`uvm_object_utils(source_xtn);
	
	function new (string name="source_xtn");
		super.new(name);
	endfunction

	rand bit[7 : 0] header;    
	rand bit[7: 0] payload[];
    bit parity;

	constraint a{ 
		    //  header[1:0] inside  {00,01,10}; 
			  header[1:0]!=3; 
			  header[7:2] !=0;
		    }
			
	constraint b{ 
		      payload.size==header[7:2];
			}
							
	function void do_print(uvm_printer printer);
	
		   super.do_print(printer);

    printer.print_field( "header", 		this.header, 	    16,		 UVM_DEC		);
	foreach(payload[i])
		printer.print_field( $sformatf("payload[%d]",i), 		this.payload[i], 	    16,		 UVM_DEC		);
      printer.print_field( "parity", 		this.parity, 	    16,		 UVM_DEC		);
	  
	endfunction
	
	function void post_randomize();
		parity=0^header;
		foreach(payload[i])
			parity=parity^payload[i];
	endfunction
	    
endclass 

