`timescale 1ns / 1ps
module ahb_master(
  input  logic             i_hclk,      // bus clock
  input  logic             i_hreset,    // active-low reset
  input  logic             i_start,     // start transfer
  input  logic [31:0]      i_haddr,     // address from TB
  input  logic             i_hwrite,    // write/read flag
  input  logic [2:0]       i_hsize,     // transfer size
  input  logic [31:0]      i_hwdata,    // write data from TB
  input  logic             i_hready,    // slave ready
  input  logic             i_hresp,     // slave response (used here)
  input  logic [31:0]      i_hrdata,    // data from slave
  input  logic [2:0]       i_hburst,    // burst type from TB

  output logic [31:0]      o_haddr,     // address to bus
  output logic             o_hwrite,    // write flag to bus
  output logic [2:0]       o_hsize,     // size to bus
  output logic [2:0]       o_htrans,    // transfer type
  output logic [31:0]      o_hwdata,    // write data to bus
  output logic [31:0]      o_hrdata,    // read data
  output logic [2:0]       o_hburst     // burst type to bus
);

  // transfer types
  localparam IDLE   = 3'b000;
  localparam WAIT_S=  3'b001;
  localparam NONSEQ = 3'b010;
  localparam SEQ    = 3'b011;
  localparam ERR_RESP=3'b100;

  // burst types
  localparam SINGLE = 3'b000;
  localparam WRAP4  = 3'b010;
  localparam INCR4  = 3'b011;
  localparam WRAP8  = 3'b100;
  localparam INCR8  = 3'b101;
  localparam WRAP16 = 3'b110;
  localparam INCR16 = 3'b111;

  // FSM registers
  logic [2:0] state, next_state;

  // internal registers
  logic       start_q;
  logic       read_flag;
  logic [2:0] burst_q;
  logic [3:0] beat_cnt;

  // wrap helper
  logic [7:0] beats, bytes;
  logic [31:0] bound_val;

  // temporary computing next
  logic [31:0] inc, base_addr, offset, new_offset, next_addr;

  // latch start
  always_ff @(posedge i_hclk or negedge i_hreset) begin
    if (!i_hreset)
      start_q <= 1'b0;
    else
      start_q <= i_start;
  end

  // FSM state register
  always_ff @(posedge i_hclk or negedge i_hreset) begin
    if (!i_hreset)
      state <= IDLE;
    else if (i_hready)
      state <= next_state;
  end

  // Next state logic
  always_comb begin
    unique case (state)
      IDLE:   
        next_state = start_q ? NONSEQ : IDLE;

      WAIT_S: 
        next_state = (i_hresp && !i_hready) ? ERR_RESP :
                     (i_hready ? SEQ : WAIT_S);

      NONSEQ: 
        next_state = (i_hresp && !i_hready) ? ERR_RESP :
                     (i_hready ? (burst_q==SINGLE ? IDLE : SEQ) : NONSEQ);

      SEQ:    
        next_state = (i_hresp && !i_hready) ? ERR_RESP :
                     (i_hready ? (beat_cnt>0 ? SEQ : IDLE) : WAIT_S);

      ERR_RESP: 
        next_state = (i_hready && i_hresp) ? IDLE : ERR_RESP;

      default: 
        next_state = IDLE;
    endcase
end


  // Compute boundary (combinational)
  always_comb begin
    unique case (i_hburst)
      INCR4, WRAP4:    beats = 4;
      INCR8, WRAP8:    beats = 8;
      INCR16,WRAP16:   beats = 16;
      default:         beats = 1;
    endcase
    unique case (i_hsize)
      3'b000: bytes = 1;
      3'b001: bytes = 2;
      3'b010: bytes = 4;
      default: bytes = 1;
    endcase
    bound_val = beats * bytes;
  end

  // Main datapath
  always_ff @(posedge i_hclk or negedge i_hreset) begin
    if (!i_hreset) begin
      o_htrans   <= IDLE;
      o_haddr    <= 32'd0;
      o_hwrite   <= 1'b0;
      o_hsize    <= 3'b010;
      o_hburst   <= SINGLE;
      o_hwdata   <= 32'd0;
      o_hrdata   <= 32'd0;
      burst_q    <= SINGLE;
      beat_cnt   <= 4'd0;
      read_flag  <= 1'b0;
    end
    else if (!start_q) begin
     o_htrans <= IDLE;
    end
     else begin
      o_htrans <= state;
      unique case (state)
        IDLE: if (start_q) begin
          // sample inputs
          o_haddr  <= i_haddr;
          o_hwrite <= i_hwrite;
          o_hsize  <= i_hsize;
          o_hburst <= i_hburst;
          o_hwdata <= i_hwdata;
          burst_q  <= i_hburst;
          // set beat count
          unique case (i_hburst)
            INCR4, WRAP4:    beat_cnt <= 4-1;
            INCR8, WRAP8:    beat_cnt <= 8-1;
            INCR16,WRAP16:   beat_cnt <= 16-1;
            default:         beat_cnt <= 0;
          endcase
          read_flag <= ~i_hwrite;
        end
        WAIT_S: begin
         // Hold address, data, and control signals stable until hready is high
        // No change needed - outputs remain latched due to always_ff
       end


        NONSEQ: if (i_hready) begin
          // first beat done, nothing extra here
        end

        SEQ: if (i_hready) begin
          // compute increment
          o_hwdata <= i_hwdata; 
          inc = (i_hsize==3'b010) ? 4 :
                ((i_hsize==3'b001) ? 2 : 1);
          // incrementing bursts
          if (burst_q==INCR4||burst_q==INCR8||burst_q==INCR16) begin
            next_addr = o_haddr + inc;
          end 
          else begin
            // wrapping bursts
            base_addr  = o_haddr & ~(bound_val - 1);
            offset     = o_haddr - base_addr;
            new_offset = offset + inc;
            if (new_offset >= bound_val)
              new_offset = new_offset - bound_val;
            next_addr = base_addr + new_offset;
          end
          o_haddr  <= next_addr;
          beat_cnt  <= beat_cnt - 1;
        end
      ERR_RESP: begin
       o_haddr <= 32'd0;
       o_hwdata <= 32'd0; 
      end
      endcase

      // capture read data
      if (i_hready && !i_hwrite) begin
        o_hrdata  <= i_hrdata;
        read_flag <= 1'b0;
      end
    end
  end

endmodule
