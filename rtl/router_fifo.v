module router_fifo(clk,rstn,soft_rst,rd_enb,wr_enb,lfd_state,data_in,full,empty,data_out);
input clk,rstn,soft_rst,rd_enb,wr_enb,lfd_state;
input [7:0]data_in;
output empty,full;
output reg [7:0]data_out;
reg [8:0]mem[15:0];
reg [6:0]fifo_counter;
reg [4:0]rd_ptr,wr_ptr;
integer i;

//EMPTY AND FULL
assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;


//POINTER INCREMENTING LOGIC 
 always@(posedge clk)
  begin
  if(!rstn || soft_rst)
  begin
   rd_ptr<=5'b00000;
   wr_ptr<=5'b00000;
  end
  else
  begin
   if(!full&&wr_enb)
   wr_ptr<=wr_ptr+1'b1;
   if(!empty&&rd_enb)
   rd_ptr<=rd_ptr+1'b1;
  end
 end

//COUNTER LOGIC
 always@(posedge clk)
 begin
 if(!rstn || soft_rst)
 fifo_counter<=7'd0;
 else
 begin
 if(rd_enb&&!empty)
  begin
  if(mem[rd_ptr[3:0]][8]==1'b1)
   fifo_counter<=mem[rd_ptr[3:0]][7:2]+1'b1;
  else if(fifo_counter!=0)
   fifo_counter<=fifo_counter-1'b1;
  end
 end
 end

// READ OPERATION
always@(posedge clk)
begin
if(!rstn || soft_rst)
data_out<=0;
else
begin
if((fifo_counter==0)&&(data_out!=0))
data_out<=8'dz;
if(!empty&&rd_enb)
data_out<=mem[rd_ptr[3:0]];
end
end

//WRITE OPERATION
always@(posedge clk)
begin
if(!rstn || soft_rst)
for(i=0;i<16;i=i+1)
mem[i]<=0;
else
begin
if(!full&&wr_enb)
{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={lfd_state,data_in};
end
end


endmodule
