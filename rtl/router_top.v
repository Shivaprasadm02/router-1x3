module router_top(input clk,rstn,rd_enb_0,rd_enb_1,rd_enb_2,pkt_vld,input [7:0]data_in,
output [7:0]data_out_0,data_out_1,data_out_2,output vld_out_0,vld_out_1,vld_out_2,err,busy);
wire  [2:0]w_enb;
wire [7:0]dout;

//FIFO module router_fifo(clk,rstn,soft_rst,rd_enb,wr_enb,lfd_state,data_in,full,empty,data_out);
router_fifo FIFO0(clk,rstn,s_rst_0,rd_enb_0,w_enb[0],lfd_state,dout,full_0,empty_0,data_out_0);
router_fifo FIFO1(clk,rstn,s_rst_1,rd_enb_1,w_enb[1],lfd_state,dout,full_1,empty_1,data_out_1);
router_fifo FIFO2(clk,rstn,s_rst_2,rd_enb_2,w_enb[2],lfd_state,dout,full_2,empty_2,data_out_2);

/*SYNC module router_sync(input clk,rstn,det_addr,w_enb_reg,empty_0,empty_1,empty_2,r_enb_0,r_enb_1,r_enb_2,full_0,full_1,full_2,input [1:0]d_in,
output reg f_full,output vld_out_0,vld_out_1,vld_out_2,output reg s_rst_0,s_rst_1,s_rst_2,[2:0]w_enb);*/
router_sync SYNC(clk,rstn,detect_addr,w_enb_reg,empty_0,empty_1,empty_2,rd_enb_0,rd_enb_1,rd_enb_2,full_0,full_1,full_2,data_in[1:0], 
f_full,vld_out_0,vld_out_1,vld_out_2,s_rst_0,s_rst_1,s_rst_2,w_enb[2:0]);

/*FSMmodule router_fsm(input clk,rstn,pkt_vld,input [1:0] data_in,input s_rst_0,s_rst_1,s_rst_2,f_full,empty_0,empty_1,empty_2,low_pkt_vld,parity_done,
output busy,detect_addr,ld_state,laf_state,full_state,w_enb_reg, rst_int_reg,lfd_state);*/
router_fsm FSM(clk,rstn,pkt_vld,data_in[1:0],s_rst_0,s_rst_1,s_rst_2,f_full,empty_0,empty_1,empty_2,low_pkt_vld,parity_done,
 busy,detect_addr,ld_state,laf_state,full_state,w_enb_reg, rst_int_reg,lfd_state);

/*REGmodule router_reg(input clk,rstn,input [7:0]data_in,input pkt_vld,f_full,rst_int_reg,detect_add,ld_state,laf_state,lfd_state,full_state,
 output reg parity_done,low_pkt_vld,err,output reg [7:0]dout);*/
router_reg REG(clk,rstn,data_in[7:0],pkt_vld,f_full,rst_int_reg,detect_addr,ld_state,laf_state,lfd_state,full_state,
 parity_done,low_pkt_vld,err,dout[7:0]);

endmodule
