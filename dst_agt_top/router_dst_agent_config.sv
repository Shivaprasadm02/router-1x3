

class router_dst_agent_config extends uvm_object;

`uvm_object_utils(router_dst_agent_config)

virtual router_dst_if vif;
 
uvm_active_passive_enum is_active = UVM_ACTIVE;
 
//static int mon_rcvd_xtn_cnt = 0;

//static int drv_data_sent_cnt = 0;

function new(string name = "router_dst_agent_config");
  super.new(name);
endfunction

endclass
