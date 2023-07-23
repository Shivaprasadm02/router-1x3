
class router_scoreboard extends uvm_scoreboard;

	uvm_tlm_analysis_fifo #(source_xtn) fifo_src;
    uvm_tlm_analysis_fifo #(destination_xtn) fifo_dst[];

	int  src_xtns_in, dst_xtns_in ,xtns_compared ,xtns_dropped;	
       
	 `uvm_component_utils(router_scoreboard)

	logic [7:0] ref_data [bit[65:0]];
	
	bit [1:0]addr;
	
		source_xtn src_data;
		destination_xtn dst_data;

	//source_xtn src_cov_data;
	//destination_xtn dst_cov_data;
/*
covergroup ram_fcov1;
option.per_instance=1;
     
        WR_ADD : coverpoint write_cov_data.address {
					bins low = {[0:100]};
					bins mid1 = {[101:511]};
					bins mid2 = {[512:1023]};
					bins mid3 = {[1024:1535]};
					bins mid4 = {[1536:2047]};
					bins mid5 = {[2048:2559]};
					bins mid6 = {[2560:3071]};
					bins mid7 = {[3072:3583]};
					bins mid8 = {[3584:4094]};
					bins high = {[3996:4095]};
					}
    	     	     
        //DATA
        DATA : coverpoint write_cov_data.data {
                   bins low  =  {[0:64'h0000_0000_0000_ffff]};
		   bins mid1 = {[64'h0000_0000_0001_0000:64'h0000_0000_ffff_ffff]};
		   bins mid2 = {[64'h0000_0001_0000_0000:64'h0000_ffff_ffff_ffff]};
		   bins high = {[64'h0001_0000_0000_0000:64'h0000_ffff_ffff_ffff]};
                 }
    
        // WRITE
        WR : coverpoint write_cov_data.write {
               bins wr_bin = {1};
    	 }
    
    
        //Write Operation - Functional Coverage
        WRITE_FC : cross WR,WR_ADD,DATA;
          
    endgroup

//LAB : write the covergroup ram_fcov2 for read transactions
    covergroup ram_fcov2;
option.per_instance=1;
       //ADDRESS
        RD_ADD : coverpoint read_cov_data.address {
					bins low = {[0:100]};
					bins mid1 = {[101:511]};
					bins mid2 = {[512:1023]};
					bins mid3 = {[1024:1535]};
					bins mid4 = {[1536:2047]};
					bins mid5 = {[2048:2559]};
					bins mid6 = {[2560:3071]};
					bins mid7 = {[3072:3583]};
					bins mid8 = {[3584:3995]};
					bins high = {[3996:4095]};
                 }
       
        //DATA
        DATA : coverpoint read_cov_data.data {
                   bins low = {[0:64'h0000_0000_0000_ffff]};
		   bins mid1 = {[64'h0000_0000_0001_0000:64'h0000_0000_ffff_ffff]};
		   bins mid2 = {[64'h0000_0001_0000_0000:64'h0000_ffff_ffff_ffff]};
		   bins high = {[64'h0001_0000_0000_0000:64'h0000_ffff_ffff_ffff]};
                 }
    
        // READ
        RD : coverpoint read_cov_data.read {
               bins rd_bin = {1};
    	 }
        
        //Read Operation - Functional Coverage
        READ_FC : cross RD,RD_ADD,DATA;
        
    endgroup

*/

	function new(string name,uvm_component parent);
		super.new(name,parent);
		
		 fifo_src = new("fifo_src", this);
		 fifo_dst = new[3];
		 foreach(fifo_dst[i])
			fifo_dst[i]= new($sformatf("fifo_dst[%0d]",i), this);
          
		// ram_fcov1 = new;
		// ram_fcov2 = new;
		 
	endfunction
	/*
	function void mem_write(source_xtn src);
	
	     if(src.pkt_vld)
			ref_data[0]=src.header;
			foreach(src.payload[i])
				ref_data[i+1]=src.payload[i];
		 else 
			ref_data[src.payload.size+2]=src.parity;
        
     	end
   	endfunction 
	
	function bit mem_read(ref destination_xtn dst);
       	if(dst.read)
      	 begin
      	`uvm_info(get_type_name(), $sformatf("Read Transaction from Read agt_top \n %s",dst.sprint()), UVM_HIGH)
        `uvm_info("MEM Function", $psprintf("Address = %h", dst.address), UVM_LOW)
        
      	if(ref_data.exists(dst.address))
      	begin
        dst.data = ref_data[dst.address] ;
        dst_xtns_in ++;
        return(1);
      	end
      	else
      	begin
        xtns_dropped ++;
        return(0);
        end				      
        end
  	endfunction 

*/
	task run_phase(uvm_phase phase);
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
		`uvm_fatal("error","err");
		fork
	   forever 
			begin
            fifo_src.get(src_data);
         //   mem_write(src_data);
             `uvm_info("SRC SB","source data" , UVM_LOW)
              src_data.print;
			 // write_cov_data = wr_data;
    	//ram_fcov1.sample();
			end

        forever
			begin
		     fork
               fifo_dst[0].get(dst_data);
               fifo_dst[1].get(dst_data);
			   fifo_dst[2].get(dst_data);
		     join_any
			 disable fork;
			`uvm_info("DST SB", "dst data" , UVM_LOW)
             // dst_data.print;
            // check_data(dst_data);
			end
			compare(src_data,dst_data);
         join
    endtask

/*
	function void check_data(destination_xtn dst);
		 	destination_xtn ref_xtn;
      
      	$cast( ref_xtn, dst.clone());
   	   `uvm_info(get_type_name(), $sformatf("Read Transaction from Memory_Model \n %s",ref_xtn.sprint()), UVM_HIGH)
        if(mem_read(ref_xtn))
		begin
       		
  		if(dst.compare(ref_xtn))
		begin
	 	`uvm_info(get_type_name(), $sformatf("Scoreboard - Data Match successful"), UVM_MEDIUM)
	 	 xtns_compared++ ;
        	end
        	else	
	  	`uvm_error(get_type_name(), $sformatf("\n Scoreboard Error [Data Mismatch]: \n Received Transaction:\n %s \n Expected Transaction: \n %s", 
                                  dst.sprint(), ref_xtn.sprint()))
  		end
       	else
          	uvm_report_info(get_type_name(), $psprintf("No Data written in the address=%d \n %s",dst.address, dst.sprint()));
//	read_cov_data = rd;
	
    	//ram_fcov2.sample();
*/		
		function void compare(source_xtn src,destination_xtn dst);
		begin
			if(src.header==dst.header)
			begin
				$display("header success");
				if(src.payload.size==dst.payload.size)
				begin
					int i=src.payload.size;
					for(i=0 ; i<src.payload.size; i++)
					begin
					if(src.payload[i]==dst.payload[i])
						  $display("payload success");
					end
				    $display("payload success");
					if(src.parity==dst.parity)
					 $display("parity success");
					else $display("parity not matching");
				end
				else $display("payload not matching");
			end
			else $display("header not matching");
		end
		endfunction
/*

	function void report_phase(uvm_phase phase);
		  `uvm_info(get_type_name(), $sformatf("MSTB: Simulation Report from ScoreBoard 
		  \n Number of Read Transactions from Read agt_top : %0d 
		  \n Number of Write Transactions from write agt_top : %0d 
		  \n Number of Read Transactions Dropped : %0d 
		  \n Number of Read Transactions compared : %0d 
		  \n\n",rd_xtns_in, wr_xtns_in, xtns_dropped, xtns_compared), UVM_LOW)
	endfunction
	
	*/
endclass



      

   
