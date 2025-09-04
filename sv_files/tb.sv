`include "uvm_macros.svh"
import uvm_pkg::*;


class transaction extends uvm_sequence_item;
  logic rst;
  logic start;
  rand logic [31:0] i_haddr;
  logic i_hwrite;
  rand logic [2:0] i_hsize;
  rand logic [31:0] i_hwdata;
  rand logic [2:0] i_hburst;
  logic [31:0] o_hrdata;
  logic m_hready;
  logic [31:0] m_haddr;
  
  constraint size_t { i_hsize>=0;i_hsize<3 ;}
  constraint burst_t {
  i_hburst inside {0, [2:7]}; // $ means maximum value allowed
}

  constraint addr_c {i_haddr>0;i_haddr<256;}
  constraint addr_err {i_haddr>255;}
  
  
  function new(string path="t");
   super.new(path);
  endfunction
  
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(rst,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(start,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(i_haddr,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(i_hwrite,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(i_hsize,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(i_hwdata,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(i_hburst,UVM_ALL_ON | UVM_BIN);
  `uvm_field_int(o_hrdata,UVM_ALL_ON | UVM_BIN);
  `uvm_object_utils_end




endclass


class gen_w extends uvm_sequence#(transaction);
 `uvm_object_utils(gen_w);

// transaction tr;
 
 function new(string path="gw");
  super.new(path);
 endfunction
 

 
virtual task body();
  repeat (15) begin
    transaction tr0, tr1;

//     First transaction: start = 0
    tr0 = transaction::type_id::create("tr0");
    start_item(tr0);
    tr0.start = 1'b0;
    assert(tr0.randomize());
    finish_item(tr0);

    // Second transaction: start = 1
    tr1 = transaction::type_id::create("tr1");
    start_item(tr1);
    tr1.start = 1'b0;
    #10;
    tr1.addr_c.constraint_mode(1);
    tr1.addr_err.constraint_mode(0);
    tr1.start = 1'b1;
    tr1.i_hwrite = 1'b1;
    assert(tr1.randomize());
    finish_item(tr1);


    // Delay based on tr1's burst type
    case (tr1.i_hburst)
      3'd0:        #20;
      3'd2, 3'd3:  #80;
      3'd4, 3'd5:  #160;
//      3'd6, 3'd7:  #160;
      3'd6, 3'd7:  #320;
      default:     #20;
    endcase
  end
endtask

 
endclass


class gen_werr extends uvm_sequence#(transaction);
 `uvm_object_utils(gen_werr);
// transaction tr;
 
 function new(string path="gwe");
  super.new(path);
 endfunction
 
virtual task body();
  repeat (128) begin
    transaction tr0, tr1;

    // First transaction: start = 0
//    tr0 = transaction::type_id::create("tr0");
//    start_item(tr0);
//    tr0.start = 1'b0;
//    assert(tr0.randomize());
//    finish_item(tr0);

    // Second transaction: start = 1
    tr1 = transaction::type_id::create("tr1");
    start_item(tr1);
        
    tr1.start = 1'b0;
    #10;
    tr1.addr_c.constraint_mode(0);
    tr1.addr_err.constraint_mode(1);
    tr1.start = 1'b1;
    tr1.i_hwrite = 1'b1;
    assert(tr1.randomize());
    finish_item(tr1);

    // Delay based on tr1's burst type
    case (tr1.i_hburst)
      3'd0:        #20;
      3'd2, 3'd3:  #80;
      3'd4, 3'd5:  #160;
      3'd6, 3'd7:  #320;
      default:     #20;
    endcase
  end
endtask

 
endclass



class gen_r extends uvm_sequence#(transaction);
 `uvm_object_utils(gen_r);
 
  
// transaction tr;
 
 function new(string path="gr");
  super.new(path);
 endfunction


 
virtual task body();
  repeat (15) begin
    transaction tr0, tr1;
   

    // First transaction: start = 0
    tr0 = transaction::type_id::create("tr0");
    start_item(tr0);
    tr0.start = 1'b0;
    assert(tr0.randomize());
    finish_item(tr0);

    // Second transaction: start = 1
    tr1 = transaction::type_id::create("tr1");
    start_item(tr1);
    tr1.start = 1'b0;
    #10;
    tr1.addr_c.constraint_mode(1);
    tr1.addr_err.constraint_mode(0);
    tr1.start = 1'b1;
    tr1.i_hwrite = 1'b0;
//    assert(tr1.randomize());
    assert(tr1.i_hburst.randomize());
    assert(tr1.i_haddr.randomize());
    assert(tr1.i_hsize.randomize());
    finish_item(tr1);

    // Delay based on tr1's burst type
    case (tr1.i_hburst)
      3'd0:        #20;
      3'd2, 3'd3:  #80;
      3'd4, 3'd5:  #160;
      3'd6, 3'd7:  #320;
      default:     #20;
    endcase
  end
endtask

 
endclass


class gen_rerr extends uvm_sequence#(transaction);
 `uvm_object_utils(gen_rerr);
// transaction tr;
 
 function new(string path="grerr");
  super.new(path);
 endfunction
 
virtual task body();
  repeat (128) begin
    transaction tr0, tr1;

    // First transaction: start = 0
    tr0 = transaction::type_id::create("tr0");
    start_item(tr0);
    tr0.start = 1'b0;
    assert(tr0.randomize());
    finish_item(tr0);

    // Second transaction: start = 1
    tr1 = transaction::type_id::create("tr1");
    start_item(tr1);
    tr1.addr_c.constraint_mode(0);
    tr1.addr_err.constraint_mode(1);
    tr1.start = 1'b1;
    tr1.i_hwrite = 1'b0;
    assert(tr1.randomize());
    finish_item(tr1);

    // Delay based on tr1's burst type
    case (tr1.i_hburst)
      3'd0:        #20;
      3'd2, 3'd3:  #80;
      3'd4, 3'd5:  #160;
      3'd6, 3'd7:  #320;
      default:     #20;
    endcase
  end
endtask

 
endclass



class drv extends uvm_driver#(transaction);
  `uvm_component_utils(drv);
  transaction tr;
  
  virtual ahb_top_i aif;
  
  function new(string path="d",uvm_component parent = null);
   super.new(path,parent);
  endfunction
  
  task reset_dut();
   repeat(5) begin
    aif.rst<=1'b0;
    aif.start<=1'b0;
    @(posedge aif.clk);
   end
   @(posedge aif.clk);
   aif.rst<=1'b1;
  
  endtask
  
  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   tr=transaction::type_id::create("t");
   if(uvm_config_db#(virtual ahb_top_i)::get(this,"*","aif",aif)) begin
    `uvm_info("DRV","Got interface",UVM_NONE);
   end
   else begin
    `uvm_error("DRV","Did not got interface");
   end
  
  
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    reset_dut();
    forever begin
     seq_item_port.get_next_item(tr);
     aif.start<=tr.start;
     aif.i_haddr<=tr.i_haddr;
     aif.i_hwrite<=tr.i_hwrite;
     aif.i_hsize<=tr.i_hsize;
     aif.i_hwdata<=tr.i_hwdata;
     aif.i_hburst<=tr.i_hburst;
     seq_item_port.item_done();
    end
  
  
  endtask

endclass


class mon extends uvm_monitor;
 `uvm_component_utils(mon);
  transaction tr;
  uvm_analysis_port#(transaction) snd;
  virtual ahb_top_i aif;
  
  
 covergroup cia ;
   option.per_instance=1;
   
   coverpoint tr.rst {
    bins rst_low={0};
    bins rst_high={1};
   
   }
   
   coverpoint tr.start {
    bins sl={0};
    bins sh={1};
   }
   
   coverpoint tr.i_haddr{
    bins v_addr[]={[0:255]};
    //bins inv_addr[]={[256:1024]};
   }
  
  coverpoint tr.i_hwrite{
    bins write_tx={1};
    bins read_tx={0};
  }
  
  coverpoint tr.i_hsize{
   bins byte_s={0};
   bins hw_tx={1};
   bins w_tx={2};
   //bins inv_size[]={[3:7]};
  }
  
  coverpoint tr.i_hwdata{
   bins bin_low[]={[0:63]};
   bins bin_high[]={[64:127]};
  
  }
  coverpoint tr.i_hburst {
   bins single={0};
   bins w4={2};
   bins i4={3};
   bins w8={4};
   bins i8={5};
   bins w16={6};
   bins i16={7};
   bins iv_burst={1};
  }
  
  coverpoint tr.o_hrdata;
  
  coverpoint tr.m_hready {
   bins nr={0};
   bins r={1};
  }
  //illegal burst types coverage upon start
  
  cross_illegal_burst: cross tr.i_hburst,tr.start,tr.m_hready{
   ignore_bins leg_burst=binsof(tr.i_hburst)intersect{0,[2:7]};
   ignore_bins strt_high=binsof(tr.start)intersect{0};
   ignore_bins rdy=binsof(tr.m_hready)intersect{0};
  }
  
  cross_illegal_tx: cross tr.i_haddr,tr.start,tr.m_hready {
   ignore_bins strt_high=binsof(tr.start)intersect{0};
   ignore_bins addr=binsof(tr.i_haddr)intersect{[0:255]};
   ignore_bins rdy=binsof(tr.m_hready)intersect{1};
  }
  
  
  cross_legal_burst: cross tr.i_hburst,tr.start,tr.m_hready{
   ignore_bins leg_burst=binsof(tr.i_hburst)intersect{1};
   ignore_bins strt_high=binsof(tr.start)intersect{0};
   ignore_bins rdy=binsof(tr.m_hready)intersect{0};
  }
  
  cross_legal_tx: cross tr.i_haddr,tr.start,tr.m_hready {
   ignore_bins strt_high=binsof(tr.start)intersect{0};
   ignore_bins addr=binsof(tr.i_haddr)intersect{[256:$]};
   ignore_bins rdy=binsof(tr.m_hready)intersect{0};
  }
  
  cross_illegal_ready: cross tr.start,tr.m_hready {
  ignore_bins strt_high=binsof(tr.start)intersect{0};
  ignore_bins rdy=binsof(tr.m_hready)intersect{1};
  
  }
  
  cross_legal_ready: cross tr.start,tr.m_hready {
  ignore_bins strt_high=binsof(tr.start)intersect{0};
  ignore_bins rdy=binsof(tr.m_hready)intersect{0};
  
  }
  
  
  
 endgroup
 

 
 
  
  function new(string path="d",uvm_component parent = null);
   super.new(path,parent);
   cia=new();
  endfunction
  
 
  
  
  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   tr=transaction::type_id::create("t");
   snd=new("snd",this);
   if(uvm_config_db#(virtual ahb_top_i)::get(this,"*","aif",aif)) begin
    `uvm_info("MON","Got interface",UVM_NONE);
   end
   else begin
    `uvm_error("MON","Did not got interface");
   end
//   cia=new();
  endfunction


  virtual task run_phase(uvm_phase phase);
   forever begin
    @(posedge aif.clk)
     `uvm_info("MON",$sformatf("MON values %0d %0d %0d",aif.i_hwdata,aif.i_haddr,aif.i_hwrite),UVM_NONE);
      if(aif.rst && aif.m_hready) begin
        tr.start<=aif.start;
        tr.i_haddr<=aif.i_haddr;
        tr.i_hwrite<=aif.i_hwrite;
        tr.i_hsize<=aif.i_hsize;
        tr.i_hwdata<=aif.i_hwdata;
        tr.i_hburst<=aif.i_hburst;
        tr.o_hrdata<=aif.o_hrdata;
        tr.m_hready <= aif.m_hready;
        tr.m_haddr <= aif.m_haddr;
        cia.sample();
        snd.write(tr);
      end
   end
  
  
  endtask
endclass

class sco extends uvm_scoreboard;
  `uvm_component_utils(sco);

  transaction tr;
  uvm_analysis_imp#(transaction, sco) rcv;
  

  // Simple reference model memory for tracking writes
  bit [31:0] ref_mem [0:255];
  integer i;

  function new(string path="sco", uvm_component parent = null);
    super.new(path, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("t");
    rcv = new("rcv", this);
    for (i=0;i<256;i++) begin
     ref_mem[i]=i;
    end

  endfunction

  virtual function void write(transaction tr);
    this.tr = tr;

    // Skip reset or invalid transactions
    if (!tr.start)
      return;

    if (tr.i_hwrite) begin
      // Write operation: store data into reference model
      if (tr.m_haddr < 256) begin
        ref_mem[tr.m_haddr] = tr.i_hwdata;
       
        `uvm_info("SCO", $sformatf("WRITE: Addr=%0d, Data=%0h", tr.i_haddr, tr.i_hwdata), UVM_NONE);
      end else begin
        `uvm_warning("SCO", $sformatf("WRITE to invalid address: %0d", tr.i_haddr));
      end
    end 
    else begin
      // Read operation: compare against expected data
      if (tr.m_haddr < 256) begin
        bit [31:0] expected = ref_mem[tr.m_haddr];
        if (tr.o_hrdata !== expected) begin
          `uvm_error("SCO", $sformatf("READ MISMATCH: Addr=%0d, Expected=%0h, Got=%0h",
                                       tr.i_haddr, expected, tr.o_hrdata));
        end 
        else begin
          `uvm_info("SCO", $sformatf("READ PASS: Addr=%0d, Data=%0h", tr.i_haddr, tr.o_hrdata), UVM_LOW);
        end
      end 
      else begin
        `uvm_warning("SCO", $sformatf("READ from invalid address: %0d", tr.i_haddr));
      end
    end
  endfunction
endclass

class agent extends uvm_agent;
  `uvm_component_utils(agent);

  drv d;
  mon m;
  uvm_sequencer#(transaction) seqr;

  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = drv::type_id::create("d", this);
    m = mon::type_id::create("m", this);
    seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass


class env extends uvm_env;
  `uvm_component_utils(env);
  sco s;
  agent a;
  function new(string name="e",uvm_component parent=null);
     super.new(name,parent);
     
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   s=sco::type_id::create("s",this);
   a=agent::type_id::create("a",this);
   
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   a.m.snd.connect(s.rcv);
     
  endfunction
  

endclass


class test extends uvm_test;
  `uvm_component_utils(test);

  gen_w    gw;
  gen_werr gwe;
  gen_r    gr;
  gen_rerr grerr;
  env      e;

  function new(string name="test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gw   = gen_w::type_id::create("gw", this);
    gwe  = gen_werr::type_id::create("gwe", this);
    gr   = gen_r::type_id::create("gr", this);
    grerr = gen_rerr::type_id::create("grerr", this);
    e    = env::type_id::create("e", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Start your write and read sequences on the sequencer
    gw.start(e.a.seqr);
    gr.start(e.a.seqr);

    // Optionally start error sequences if you want
    // Uncomment these to run error tests
    gwe.start(e.a.seqr);
    grerr.start(e.a.seqr);

    phase.drop_objection(this);
  endtask

endclass


module tb;

  // Instantiate interface
  ahb_top_i aif();

  // Instantiate DUT and connect interface signals
  ahb_top dut (
    .clk      (aif.clk),
    .rst      (aif.rst),
    .start    (aif.start),
    .i_haddr  (aif.i_haddr),
    .i_hwrite (aif.i_hwrite),
    .i_hsize  (aif.i_hsize),
    .i_hwdata (aif.i_hwdata),
    .i_hburst (aif.i_hburst),
    .o_hrdata (aif.o_hrdata)
    // Add other ports as needed
  );
  
  bind ahb_top assertion_check assert_inst (
  .clk      (clk),
  .rst      (rst),
  .start    (start),
  .i_haddr  (i_haddr),
  .i_hwrite (i_hwrite),
  .i_hsize  (i_hsize),
  .i_hwdata (i_hwdata),
  .i_hburst (i_hburst),
  .o_hrdata (o_hrdata)
);

 assign aif.m_hready=dut.m_hready;
 assign aif.m_haddr=dut.m_haddr;
  // Clock generation
  initial begin
    aif.clk = 0;
    forever #5 aif.clk = ~aif.clk; // 100 MHz clock (10ns period)
  end



  // UVM testbench start
  initial begin
    // Set virtual interface for UVM components with the name "aif"
    uvm_config_db#(virtual ahb_top_i)::set(null, "*", "aif", aif);

    
    run_test("test");
  end
  initial begin
   $dumpfile("waveform.vcd");   
   $dumpvars(0, tb);            
  end


endmodule



    
