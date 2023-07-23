class router_env_config extends uvm_object;
/*
bit has_functional_coverage = 0;
bit has_wagent_functional_coverage = 0;
bit has_scoreboard = 1;
*/
bit has_sagent = 1;
bit has_dagent = 1;

bit has_virtual_sequencer = 1;

router_src_agent_config m_src_agent_cfg[];
router_dst_agent_config m_dst_agent_cfg[];

int no_of_sagents;
int no_of_dagents;
`uvm_object_utils(router_env_config)

function new(string name = "router_env_config");
  super.new(name);
endfunction

endclass
