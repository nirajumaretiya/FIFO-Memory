# 🚀 Synchronous FIFO Memory Design

A robust and efficient implementation of a Synchronous First-In-First-Out (FIFO) memory buffer in Verilog. This design provides a reliable data buffering solution with full/empty status indicators and overflow protection.

## 🌟 Features

- **Synchronous Operation**: All operations are synchronized with a clock signal
- **8-bit Data Width**: Supports 8-bit data transfers
- **Configurable Buffer Size**: Easily adjustable through `bufwidth` parameter
- **Status Indicators**:
  - Empty flag
  - Full flag
  - FIFO counter
- **Control Signals**:
  - Write enable (wr_en)
  - Read enable (rd_en)
  - Reset functionality
- **Overflow Protection**: Prevents writing when buffer is full
- **Underflow Protection**: Prevents reading when buffer is empty

## 🛠️ Implementation Details

### Module Structure
- **Sync_FIFO**: Main FIFO implementation module
- **Test_Sync_FIFO**: Comprehensive testbench module

### Key Parameters
```verilog
`define bufwidth 3    // Buffer size = 2^3 = 8 locations
`define bufsize (1<<`bufwidth)
```

### Interface Signals
- **Inputs**:
  - `clock`: System clock
  - `reset`: Asynchronous reset
  - `wr_en`: Write enable
  - `rd_en`: Read enable
  - `buf_in[7:0]`: 8-bit input data

- **Outputs**:
  - `buf_out[7:0]`: 8-bit output data
  - `buf_empty`: Empty status flag
  - `buf_full`: Full status flag
  - `fifo_cnt`: Current number of elements in FIFO

## 🎯 Usage Example

```verilog
// Writing data to FIFO
wr_en = 1;
buf_in = 8'hAA;
@(posedge clock);

// Reading data from FIFO
rd_en = 1;
@(posedge clock);
data = buf_out;
```

## 🧪 Testbench Features

The included testbench provides comprehensive testing scenarios:
- Push operations
- Pop operations
- Simultaneous push and pop
- Buffer full conditions
- Buffer empty conditions
- Reset functionality

## 📊 Performance Characteristics

- **Clock Frequency**: Compatible with standard synchronous designs
- **Latency**: One clock cycle for both read and write operations
- **Throughput**: One data word per clock cycle when not full/empty

## 🔧 Customization

To modify the buffer size, adjust the `bufwidth` parameter:
```verilog
`define bufwidth 4    // For 16 locations
`define bufwidth 5    // For 32 locations
```

## 📝 Notes

- The FIFO is synchronous, requiring a clock signal for all operations
- Reset is asynchronous and active high
- Write operations are ignored when the buffer is full
- Read operations are ignored when the buffer is empty

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is open source and available under the MIT License.

---
Made with ❤️ for digital design enthusiasts
