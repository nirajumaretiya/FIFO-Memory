# FIFO Memory (Verilog)

Simple FIFO implementations in Verilog:
- `Sync_FIFO.v` (synchronous FIFO)
- `simple_async_fifo.v` (asynchronous FIFO, dual-clock)

This repository currently includes one testbench file for the synchronous FIFO.

## Files

- `Sync_FIFO.v`  
  Synchronous FIFO with:
  - single clock (`clock`)
  - `wr_en` / `rd_en`
  - `buf_empty`, `buf_full`
  - `fifo_cnt`

- `Test_Sync_FIFO.v`  
  Testbench for `Sync_FIFO` with push/pop tasks and mixed read/write stimulus.

- `simple_async_fifo.v`  
  Asynchronous FIFO with:
  - write clock `wr_clk` and read clock `rd_clk`
  - Gray-code pointer logic
  - synchronized pointers across clock domains
  - `full`, `empty`, `overflow`, `underflow`

## Quick Notes

- Data width is 8-bit in both designs by default.
- `Sync_FIFO.v` uses:
  - `` `define bufwidth 3``
  - `` `define bufsize (1<<`bufwidth)``
- `simple_async_fifo.v` uses parameters:
  - `DATA_WIDTH = 8`
  - `DEPTH = 512`

## Simulation

No simulator scripts are included in this repo.  
Use your preferred Verilog simulator and compile the files you want to test.

For synchronous FIFO simulation, use:
- `Sync_FIFO.v`
- `Test_Sync_FIFO.v`

## Status

- Synchronous FIFO: implementation + testbench included.
- Asynchronous FIFO: implementation included.

