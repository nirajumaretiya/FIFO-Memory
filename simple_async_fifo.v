module simple_async_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 512
)(
    input  wire wr_clk,
    input  wire rd_clk,
    input  wire rst, 
    
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] wr_data,
    output wire                  full,
    
    input  wire                  rd_en,
    output reg  [DATA_WIDTH-1:0] rd_data,
    output wire                  empty,
    
    output reg overflow,
    output reg underflow
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    reg [PTR_WIDTH-1:0] wr_ptr_bin, wr_ptr_gray;
    reg [PTR_WIDTH-1:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
    
    reg [PTR_WIDTH-1:0] rd_ptr_bin, rd_ptr_gray;
    reg [PTR_WIDTH-1:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    
    function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
        bin2gray = (bin >> 1) ^ bin;
    endfunction
    
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_ptr_bin  <= 0;
            wr_ptr_gray <= 0;
            overflow    <= 0;
        end else begin
            overflow <= 0;
            if (wr_en && !full) begin
                mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
                wr_ptr_bin  <= wr_ptr_bin + 1;
                wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
            end else if (wr_en && full) begin
                overflow <= 1;
            end
        end
    end
    
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end
    
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptr_bin  <= 0;
            rd_ptr_gray <= 0;
            rd_data     <= 0;
            underflow   <= 0;
        end else begin
            underflow <= 0;
            if (rd_en && !empty) begin
                rd_data     <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
                rd_ptr_bin  <= rd_ptr_bin + 1;
                rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
            end else if (rd_en && empty) begin
                underflow <= 1;
            end
        end
    end
    
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end
    
    assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);
    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
                                    rd_ptr_gray_sync2[PTR_WIDTH-3:0]});

endmodule










// module simple_async_fifo #(
//     parameter DATA_WIDTH = 8,
//     parameter DEPTH = 512
// )(
//     input  wire wr_clk,
//     input  wire rd_clk,
//     input  wire rst,
    
//     input  wire                  wr_en,
//     input  wire [DATA_WIDTH-1:0] wr_data,
//     output wire                  full,
//     output wire                  almost_full, // NEW PORT
    
//     input  wire                  rd_en,
//     output reg  [DATA_WIDTH-1:0] rd_data,
//     output wire                  empty,
    
//     output reg overflow,
//     output reg underflow
// );
//     localparam ADDR_WIDTH = $clog2(DEPTH);
//     localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
//     reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
//     reg [PTR_WIDTH-1:0] wr_ptr_bin, wr_ptr_gray;
//     reg [PTR_WIDTH-1:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
    
//     reg [PTR_WIDTH-1:0] rd_ptr_bin, rd_ptr_gray;
//     reg [PTR_WIDTH-1:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    
//     function [PTR_WIDTH-1:0] bin2gray(input [PTR_WIDTH-1:0] bin);
//         bin2gray = (bin >> 1) ^ bin;
//     endfunction
    
//     function [PTR_WIDTH-1:0] gray2bin(input [PTR_WIDTH-1:0] gray);
//         integer i;
//         begin
//             gray2bin[PTR_WIDTH-1] = gray[PTR_WIDTH-1];
//             for (i = PTR_WIDTH-2; i >= 0; i = i - 1)
//                 gray2bin[i] = gray2bin[i+1] ^ gray[i];
//         end
//     endfunction
    
//     always @(posedge wr_clk or posedge rst) begin
//         if (rst) begin
//             wr_ptr_bin <= 0;
//             wr_ptr_gray <= 0;
//             overflow <= 0;
//         end else begin
//             overflow <= 0;
//             if (wr_en && !full) begin
//                 mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
//                 wr_ptr_bin <= wr_ptr_bin + 1;
//                 wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
//             end else if (wr_en && full) begin
//                 overflow <= 1;
//             end
//         end
//     end
    
//     always @(posedge wr_clk or posedge rst) begin
//         if (rst) begin
//             rd_ptr_gray_sync1 <= 0;
//             rd_ptr_gray_sync2 <= 0;
//         end else begin
//             rd_ptr_gray_sync1 <= rd_ptr_gray;
//             rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
//         end
//     end
    
//     always @(posedge rd_clk or posedge rst) begin
//         if (rst) begin
//             rd_ptr_bin <= 0;
//             rd_ptr_gray <= 0;
//             rd_data <= 0;
//             underflow <= 0;
//         end else begin
//             underflow <= 0;
//             if (rd_en && !empty) begin
//                 rd_data <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
//                 rd_ptr_bin <= rd_ptr_bin + 1;
//                 rd_ptr_gray <= bin2gray(rd_ptr_bin + 1);
//             end else if (rd_en && empty) begin
//                 underflow <= 1;
//             end
//         end
//     end
    
//     always @(posedge rd_clk or posedge rst) begin
//         if (rst) begin
//             wr_ptr_gray_sync1 <= 0;
//             wr_ptr_gray_sync2 <= 0;
//         end else begin
//             wr_ptr_gray_sync1 <= wr_ptr_gray;
//             wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
//         end
//     end
    
//     wire [PTR_WIDTH-1:0] wr_ptr_next = wr_ptr_bin + 1;
//     wire [PTR_WIDTH-1:0] wr_ptr_gray_next = bin2gray(wr_ptr_next);
    
//     assign full = (wr_ptr_gray_next == {~rd_ptr_gray_sync2[PTR_WIDTH-1:PTR_WIDTH-2], 
//                                          rd_ptr_gray_sync2[PTR_WIDTH-3:0]});
//     assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);

//     wire [PTR_WIDTH-1:0] rd_ptr_bin_sync_wr = gray2bin(rd_ptr_gray_sync2);
//     wire [PTR_WIDTH-1:0] fifo_count = wr_ptr_bin - rd_ptr_bin_sync_wr;
    
//     assign almost_full = (fifo_count >= (DEPTH - 128));

// endmodule