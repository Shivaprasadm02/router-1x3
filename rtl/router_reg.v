module router_reg(input clk,rstn,input [7:0]data_in,input pkt_vld,f_full,rst_int_reg,detect_add,ld_state,laf_state,lfd_state,full_state,
 output reg parity_done,low_pkt_vld,err,output reg [7:0]dout);
//int reg
reg[7:0]hhb;
reg[7:0]ffb;
reg[7:0]cal_par;
reg[7:0]pkt_par;

always@(posedge clk)
begin
//rst logic
 if(!rstn)
 begin
  {parity_done,low_pkt_vld,err,dout}=0;
  {hhb,ffb,cal_par,pkt_par}=0;
 end
 else if(detect_add)
  {cal_par, ffb, pkt_par}=3'b000;
 
//cal_par logic
 else if(lfd_state)
  cal_par=cal_par^hhb;
 else if (ld_state && pkt_vld && !full_state)
   cal_par=cal_par^data_in;
 else if(!pkt_vld && rst_int_reg)
   cal_par=0;
 
//dout logic

//hhb logic
  if(detect_add && pkt_vld)
   hhb=data_in;
  if(lfd_state)
   dout=hhb;
  if(ld_state && !f_full)
   dout=data_in;
//ffb logic
  if(ld_state && f_full)
   ffb=data_in;
  if(laf_state)
   dout=ffb;
 
//parity_done logic
  if((ld_state && ~f_full && ~pkt_vld)||
  (laf_state && low_pkt_vld && ~parity_done))
    parity_done=1'b1;
  else if(detect_add)
    parity_done=1'b0;

//low_pkt_vld logic

  if (rst_int_reg)
   low_pkt_vld=1'b0;
  if(ld_state && ~pkt_vld)
   low_pkt_vld =1'b1;
 
//err logic

//pkt_par logic
   if(ld_state && !pkt_vld)
    pkt_par=data_in;
	if(parity_done)
    err=(cal_par!==pkt_par)?1'b1:1'b0;
  end

endmodule
