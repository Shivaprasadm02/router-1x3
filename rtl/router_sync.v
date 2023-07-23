module router_sync(input clk,rstn,det_addr,w_enb_reg,empty_0,empty_1,empty_2,r_enb_0,r_enb_1,r_enb_2,full_0,full_1,full_2,input [1:0]d_in,
output reg f_full,output vld_out_0,vld_out_1,vld_out_2,output reg s_rst_0,s_rst_1,s_rst_2,output reg[2:0]w_enb);
reg [1:0]int_addr_reg;
reg[4:0]timer_0,timer_1,timer_2;

// int_addr_reg logic
always@(posedge clk)
 if(!rstn)
  int_addr_reg<=1'b0;
 else if(det_addr)
  int_addr_reg<=d_in;
  
//w_enb_reg logic
always@(*)
begin
if(w_enb_reg)
 case(int_addr_reg)
  2'b00:w_enb=3'b001;
  2'b01:w_enb=3'b010;
  2'b10:w_enb=3'b100;
 endcase
end

//valid out logic
assign vld_out_0=~empty_0;
assign vld_out_1=~empty_1;
assign vld_out_2=~empty_2;

//fifo full logic
always@(*)
begin
case(int_addr_reg)
 2'b00:f_full=full_0;
 2'b01:f_full=full_1;
 2'b10:f_full=full_2;
endcase
end
 
//soft reset logic
always@(posedge clk)
 begin
  if(!rstn)
   begin
    {timer_0,timer_1,timer_2}<=0;
	s_rst_0<=0;
	s_rst_1<=0;
	s_rst_2<=0; 
   end
  else if(vld_out_0)
  begin 
   if(!r_enb_0)
   begin
    if(timer_0==5'd29)
     begin
     s_rst_0<=1'b1;
     timer_0<=0;
     end
    else
     begin
     s_rst_0<=0;
     timer_0<=timer_0+1;
     end
   end
  end
   else if(vld_out_1)
  begin 
   if(!r_enb_1)
   begin
    if(timer_1==5'd29)
    begin
    s_rst_1<=1'b1;
    timer_1<=0;
    end
    else
    begin
    s_rst_1<=1;
    timer_1<=timer_1+1;
    end
   end
end
   else if(vld_out_2)
  begin 
   if(!r_enb_2)
   begin
    if(timer_2==5'd29)
    begin
    s_rst_2<=1'b1;
    timer_2<=0;
    end
    else
    begin
    s_rst_2<=0;
    timer_2<=timer_2+1;
    end
   end
 end
end
endmodule
	