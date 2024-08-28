
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Design Name:   Test Synchronus FIFO
// Project Name:  Synchronus_FIFO
////////////////////////////////////////////////////////////////////////////////

`define bufwidth 3

module Test_Sync_FIFO();
reg clock, reset, wr_en, rd_en ;
reg[7:0] buf_in;
reg[7:0] temp;
wire [7:0] buf_out;
wire [`bufwidth :0] fifo_cnt;

Sync_FIFO ff( .clock(clock), .reset(reset), .buf_in(buf_in), .buf_out(buf_out), 
         .wr_en(wr_en), .rd_en(rd_en), .buf_empty(buf_empty), 
         .buf_full(buf_full), .fifo_cnt(fifo_cnt) );

initial
begin
   clock = 0;
   reset = 1;
        rd_en = 0;
        wr_en = 0;
        temp = 0;
        buf_in = 0;


        #15 reset = 0;
  
        push(1);
        fork
           push(2);
           pop(temp);
        join              //push and pop together   
        push(10);
        push(20);
        push(30);
        push(40);
        push(50);
        push(60);
        push(70);
        push(80);
        push(90);
        push(100);
        push(110);
        push(120);
        push(130);

        pop(temp);
        push(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
		  push(140);
        pop(temp);
        push(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        pop(temp);
        push(5);
        pop(temp);
end

always
   #5 clock = ~clock;

task push;
input[7:0] data;


   if( buf_full )
            $display("---Cannot push: Buffer Full---");
        else
        begin
           $display("Pushed ",data );
           buf_in = data;
           wr_en = 1;
                @(posedge clock);
                #1 wr_en = 0;
        end

endtask

task pop;
output [7:0] data;

   if( buf_empty )
            $display("---Cannot Pop: Buffer Empty---");
   else
        begin

     rd_en = 1;
          @(posedge clock);

          #1 rd_en = 0;
          data = buf_out;
           $display("-------------------------------Poped ", data);

        end
endtask

endmodule


