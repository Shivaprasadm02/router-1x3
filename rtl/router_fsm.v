module router_fsm(
input clk,rstn,pkt_vld,input [1:0] data_in,input s_rst_0,s_rst_1,s_rst_2,f_full,empty_0,empty_1,empty_2,low_pkt_vld,parity_done,
output busy,detect_addr,ld_state,laf_state,full_state,w_enb_reg, rst_int_reg,lfd_state);
reg [3:0]pr_st,nx_st;
reg[1:0]addr;

//parameter declaration

parameter 
DECODE_ADDRESS=4'b0001,
WAIT_TILL_EMPTY=4'b0010,
LOAD_FIRST_DATA=4'b0011,
LOAD_DATA=4'b0100,
LOAD_PARITY=4'b0101,
FIFO_FULL_STATE=4'b0110,
LOAD_AFTER_FULL=4'b0111,
CHECK_PARITY_ERROR=4'b1000;

//internal variable addr logic
/*always@(posedge clk)
begin
if(!rstn)
 addr<=2'b0;
else if((s_rst_0 && data_in==2'b00)||
 (s_rst_1 && data_in==2'b01)||
 (s_rst_2 && data_in==2'b10))
 addr<=2'b00;
else if(DECODE_ADDRESS)
 addr<=data_in;
 end*/

  always@(posedge clk)
    begin
      if(~rstn)
        addr<=2'b0;
      else if(DECODE_ADDRESS)          // decides the address of out channel 
       addr<=data_in;			 
    end
 
//pr_st logic
always@(posedge clk)
begin
 if(!rstn)
  pr_st<=DECODE_ADDRESS;
 else if(s_rst_0|s_rst_1|s_rst_2)
  pr_st<=DECODE_ADDRESS;
 else
  pr_st<=nx_st;
 end
 
//nx_st logic
always@(*)
 begin
  if(data_in!=2'b11)
   begin
    nx_st<=DECODE_ADDRESS;
    case(pr_st)
//1
    DECODE_ADDRESS:
	begin
     if((pkt_vld&&(data_in==2'b00)&&empty_0)||(pkt_vld&&(data_in==2'b01)&&empty_1)||(pkt_vld&&(data_in==2'b10)&&empty_2))
        nx_st<=LOAD_FIRST_DATA;
     else if((pkt_vld&&(data_in==2'b00)&&(!empty_0))||(pkt_vld&&(data_in==2'b01)&&(!empty_1))||(pkt_vld&&(data_in==2'b10)&&(!empty_2)))
        nx_st<=WAIT_TILL_EMPTY;
     else nx_st<=DECODE_ADDRESS;
    end
//2
    LOAD_FIRST_DATA:
	begin
      nx_st<=LOAD_DATA;
    end
//2
    WAIT_TILL_EMPTY:
	begin
     if(((addr==2'b00)&&empty_0)||((addr==2'b01)&&empty_1)||((addr==2'b10)&&empty_2))
      nx_st<=LOAD_FIRST_DATA;
     else nx_st<=WAIT_TILL_EMPTY;
    end
//3
    LOAD_DATA:
	begin
    if(f_full)
     nx_st<=FIFO_FULL_STATE;
    else 
      begin
       if((!f_full)&&(!pkt_vld))
        nx_st<=LOAD_PARITY;
      else nx_st<=LOAD_DATA;
     end
    end
//4
    FIFO_FULL_STATE:
	begin
     if(!f_full)
      nx_st<=LOAD_AFTER_FULL;
     else nx_st<=FIFO_FULL_STATE;
    end
//5	
	LOAD_PARITY:
    begin
      nx_st<=CHECK_PARITY_ERROR;
    end
//6
    LOAD_AFTER_FULL:
	begin
    if(!parity_done&&low_pkt_vld)
      nx_st<=LOAD_PARITY;
    else if(!parity_done&&(!low_pkt_vld))
     nx_st<=LOAD_DATA;
    else
     begin
      if(parity_done)
       nx_st<=DECODE_ADDRESS;
     else nx_st<=LOAD_AFTER_FULL;
    end
    end
//7
    CHECK_PARITY_ERROR:
	begin
	 if(f_full)
	  nx_st<=FIFO_FULL_STATE;
	 else if(!f_full)
	  nx_st<=DECODE_ADDRESS;
	end    
   endcase
  end
end

//output logic

assign detect_addr=(pr_st==DECODE_ADDRESS)?1'b1:1'b0;
assign ld_state=(pr_st==LOAD_DATA)?1'b1:1'b0;
assign laf_state=(pr_st==LOAD_AFTER_FULL)?1'b1:1'b0;
assign lfd_state=(pr_st==LOAD_FIRST_DATA)?1'b1:1'b0;
assign full_state=(pr_st==FIFO_FULL_STATE)?1'b1:1'b0;
assign rst_int_reg=(pr_st==CHECK_PARITY_ERROR)?1'b1:1'b0;
assign w_enb_reg=((pr_st==LOAD_DATA)||(pr_st==LOAD_AFTER_FULL)||(pr_st==LOAD_PARITY))?1'b1:1'b0;
assign busy=((pr_st==LOAD_FIRST_DATA)||(pr_st==LOAD_PARITY)||(pr_st==FIFO_FULL_STATE)||(pr_st==LOAD_AFTER_FULL)||
             (pr_st==WAIT_TILL_EMPTY)||(pr_st==CHECK_PARITY_ERROR))?1:0;
// assign busy=((pr_st=DECODE_ADDRESS)||(pr_st=LOAD_DATA))?1'b0:1'b1;

endmodule