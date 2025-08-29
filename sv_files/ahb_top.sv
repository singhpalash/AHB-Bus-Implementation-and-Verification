`timescale 1ns / 1ps

module ahb_top(
    input clk,
    input rst,
    input start,
    input [31:0] i_haddr,
    input i_hwrite,
    input [2:0] i_hsize,
    input [31:0] i_hwdata,
    input [2:0] i_hburst,
    output wire [31:0] o_hrdata
);

// Master-to-Interconnect wires
wire [31:0] m_haddr;
wire [2:0]  m_htrans;
wire [2:0]  m_hburst;
wire [2:0]  m_hsize;
wire        m_hwrite;
wire [31:0] m_hwdata;
wire [31:0] m_hrdata;
wire        m_hready;
wire        m_hresp;

// Interconnect-to-Slave wires
wire hsel0, hsel1, hsel2;

wire [31:0] s0_hrdata, s1_hrdata, s2_hrdata;
wire s0_hreadyout, s1_hreadyout, s2_hreadyout;
wire s0_hresp, s1_hresp, s2_hresp;

// Common signals to all slaves from interconnect
wire [31:0] s_haddr;
wire [2:0]  s_htrans;
wire [2:0]  s_hburst;
wire [2:0]  s_hsize;
wire        s_hwrite;
wire [31:0] s_hwdata;

// Master Instantiation
ahb_master mm1 (
    .i_hclk(clk),
    .i_hreset(rst),
    .i_start(start),
    .i_haddr(i_haddr),
    .i_hwrite(i_hwrite),
    .i_hsize(i_hsize),
    .i_hwdata(i_hwdata),
    .i_hburst(i_hburst),
    .i_hready(m_hready),
    .i_hresp(m_hresp),
    .i_hrdata(m_hrdata),
    .o_haddr(m_haddr),
    .o_hwrite(m_hwrite),
    .o_hsize(m_hsize),
    .o_htrans(m_htrans),
    .o_hburst(m_hburst),
    .o_hwdata(m_hwdata),
    .o_hrdata(o_hrdata)
);

// Interconnect Instantiation
ahb_interconnect intercon (
    .HCLK(clk),
    .HRESETn(rst),
    .M_HADDR(m_haddr),
    .M_HTRANS(m_htrans),
    .M_HBURST(m_hburst),
    .M_HSIZE(m_hsize),
    .M_HWRITE(m_hwrite),
    .M_HWDATA(m_hwdata),
    .M_HRDATA(m_hrdata),
    .M_HREADY(m_hready),
    .M_HRESP(m_hresp),

    .HSEL0(hsel0),
    .S0_HADDR(s_haddr),
    .S0_HTRANS(s_htrans),
    .S0_HBURST(s_hburst),
    .S0_HSIZE(s_hsize),
    .S0_HWRITE(s_hwrite),
    .S0_HWDATA(s_hwdata),
    .S0_HRDATA(s0_hrdata),
    .S0_HREADYOUT(s0_hreadyout),
    .S0_HRESP(s0_hresp),

    .HSEL1(hsel1),
    .S1_HADDR(s_haddr),
    .S1_HTRANS(s_htrans),
    .S1_HBURST(s_hburst),
    .S1_HSIZE(s_hsize),
    .S1_HWRITE(s_hwrite),
    .S1_HWDATA(s_hwdata),
    .S1_HRDATA(s1_hrdata),
    .S1_HREADYOUT(s1_hreadyout),
    .S1_HRESP(s1_hresp),

    .HSEL2(hsel2),
    .S2_HADDR(s_haddr),
    .S2_HTRANS(s_htrans),
    .S2_HBURST(s_hburst),
    .S2_HSIZE(s_hsize),
    .S2_HWRITE(s_hwrite),
    .S2_HWDATA(s_hwdata),
    .S2_HRDATA(s2_hrdata),
    .S2_HREADYOUT(s2_hreadyout),
    .S2_HRESP(s2_hresp)
);

// Three Slave Instantiations
ahb_slave #(.MEM_DEPTH(256), .WAIT_CYCLES(2)) slave0 (
    .HCLK(clk),
    .HRESETn(rst),
    .HSEL(hsel0),
    .HADDR(s_haddr),
    .HTRANS(s_htrans),
    .HBURST(s_hburst),
    .HSIZE(s_hsize),
    .HWRITE(s_hwrite),
    .HWDATA(s_hwdata),
    .HRDATA(s0_hrdata),
    .HREADY(m_hready),
    .HREADYOUT(s0_hreadyout),
    .HRESP(s0_hresp)
);

ahb_slave #(.MEM_DEPTH(256), .WAIT_CYCLES(2)) slave1 (
    .HCLK(clk),
    .HRESETn(rst),
    .HSEL(hsel1),
    .HADDR(s_haddr),
    .HTRANS(s_htrans),
    .HBURST(s_hburst),
    .HSIZE(s_hsize),
    .HWRITE(s_hwrite),
    .HWDATA(s_hwdata),
    .HRDATA(s1_hrdata),
    .HREADY(m_hready),
    .HREADYOUT(s1_hreadyout),
    .HRESP(s1_hresp)
);

ahb_slave #(.MEM_DEPTH(256), .WAIT_CYCLES(2)) slave2 (
    .HCLK(clk),
    .HRESETn(rst),
    .HSEL(hsel2),
    .HADDR(s_haddr),
    .HTRANS(s_htrans),
    .HBURST(s_hburst),
    .HSIZE(s_hsize),
    .HWRITE(s_hwrite),
    .HWDATA(s_hwdata),
    .HRDATA(s2_hrdata),
    .HREADY(m_hready),
    .HREADYOUT(s2_hreadyout),
    .HRESP(s2_hresp)
);

endmodule

interface ahb_top_i;
    logic clk;
    logic rst;
    logic start;
    logic [31:0] i_haddr;
    logic i_hwrite;
    logic [2:0] i_hsize;
    logic [31:0] i_hwdata;
    logic [2:0] i_hburst;
    logic [31:0] o_hrdata;
    logic m_hready;
    logic [31:0] m_haddr;

endinterface
