#Makefile for UVM Testbench
RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../src_agt_top +incdir+../dst_agt_top
SVTB2 = ../test/router_test_pkg.sv
COVOP = -coveropt 3 +cover=bcft
VSIMOPT= -vopt -voptargs=+acc 

VSIMBATCH1= -c -do  " log -r /* ;run -all; exit"

help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                             											!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.       								!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                   								!"
	@echo "! run_sim    =>  run the simulation in batch mode.                   								!"
	@echo "! run_test	=>  clean, compile & run the simulation in batch mode.		!" 
	@echo ====================================================================================================================

sv_cmp:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(RTL) $(INC) $(SVTB2) $(SVTB1) $(COVOP)
	
run_sim:
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -l test.log  -sv_seed random work.top +UVM_TESTNAME=router_rand_addr_test

clean:
	rm -rf transcript* *log*  vsim.wlf fcover* covhtml* mem_cov* *.wlf modelsim.ini
	clear

run_test: clean sv_cmp run_sim
