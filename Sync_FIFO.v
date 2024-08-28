`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Synchronus FIFO
// Module Name:    Sync_FIFO 
// Project Name: FIFO Design
//////////////////////////////////////////////////////////////////////////////////




`define bufwidth 3    // bufsize = 16 -> bufwidth = 4, no. of bits to be used in pointer
`define bufsize ( 1<<`bufwidth )

module Sync_FIFO( clock, reset, buf_in, buf_out, wr_en, rd_en, buf_empty, buf_full, fifo_cnt );

input                 reset, clock, wr_en, rd_en;   
// reset, system clock, write enable and read enable.
input [7:0]           buf_in;                   
// data input to be pushed to buffer
output[7:0]           buf_out;                  
// port to output the data using pop.
output                buf_empty, buf_full;      
// buffer empty and full indication 
output[`bufwidth :0] fifo_cnt;             
// number of data pushed in to buffer   

reg[7:0]              buf_out;
reg                   buf_empty, buf_full; 
reg[`bufwidth :0]    fifo_cnt;
reg[`bufwidth -1:0]  rd_ptr, wr_ptr;           // pointer to read and write addresses  
reg[7:0]              buf_mem[`bufsize -1 : 0]; //  

always @(fifo_cnt)
begin
   buf_empty = (fifo_cnt==0);   // Checking for whether buffer is empty or not
   buf_full = (fifo_cnt== `bufsize);  //Checking for whether buffer is full or not

end

//Setting FIFO counter value for different situations of read and write operations.
always @(posedge clock or posedge reset)
begin
   if( reset )
       fifo_cnt <= 0;		// Reset the counter of FIFO

   else if( (!buf_full && wr_en) && ( !buf_empty && rd_en ) )  //When doing read and write operation simultaneously
       fifo_cnt <= fifo_cnt;			// At this state, counter value will remain same.

   else if( !buf_full && wr_en )			// When doing only write operation
       fifo_cnt <= fifo_cnt + 1;

   else if( !buf_empty && rd_en )		//When doing only read operation
       fifo_cnt <= fifo_cnt - 1;

   else
      fifo_cnt <= fifo_cnt;			// When doing nothing.
end

always @( posedge clock or posedge reset)
begin
   if( reset )
      buf_out <= 0;		//On reset output of buffer is all 0.
   else
   begin
      if( rd_en && !buf_empty )
         buf_out <= buf_mem[rd_ptr];	//Reading the 8 bit data from buffer location indicated by read pointer

      else
         buf_out <= buf_out;		

   end
end

always @(posedge clock)
begin
   if( wr_en && !buf_full )
      buf_mem[ wr_ptr ] <= buf_in;		//Writing 8 bit data input to buffer location indicated by write pointer

   else
      buf_mem[ wr_ptr ] <= buf_mem[ wr_ptr ];
end

always@(posedge clock or posedge reset)
begin
   if( reset )
   begin
      wr_ptr <= 0;		// Initializing write pointer
      rd_ptr <= 0;		//Initializing read pointer
   end
   else
   begin
      if( !buf_full && wr_en )    
			wr_ptr <= wr_ptr + 1;		// On write operation, Write pointer points to next location
      else  
			wr_ptr <= wr_ptr;

      if( !buf_empty && rd_en )   
			rd_ptr <= rd_ptr + 1;		// On read operation, read pointer points to next location to be read
      else 
			rd_ptr <= rd_ptr;
   end

end
endmodule

