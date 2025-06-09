module assertion_check(
    input clk,
    input rst,
    input start,
    input [31:0] i_haddr,
    input i_hwrite,
    input [2:0] i_hsize,
    input [31:0] i_hwdata,
    input [2:0] i_hburst,
    input [31:0] o_hrdata
);

default clocking c1
 @(posedge clk);
endclocking


property p1;
 disable iff(!rst) (!(start)|->dut.s_haddr==32'd0);
endproperty

property p2;
 disable iff(!rst) (!start|-> dut.s_hwdata==32'd0);
endproperty

property p3;
 disable iff(!rst) (!start|-> o_hrdata==32'd0);
endproperty

property p4;
 disable iff(!rst) ($rose(start) |=> ((dut.m_haddr<=255) throughout start)); 
endproperty

property p5;
 disable iff(!rst) ($rose(start) |-> (i_hburst==3'd0 or (i_hburst>=3'd2 and i_hburst<=3'd7 )));
endproperty

property p6;
 ((start and i_hsize==3'd1)|=>(dut.m_haddr==$past(dut.m_haddr+1)));
endproperty

property p7;
 ((start and i_hsize==3'd2)|=>(dut.m_haddr==$past(dut.m_haddr+2)));
endproperty

property p8;
 ((start and i_hsize==3'd3)|=>(dut.m_haddr==$past(dut.m_haddr+4)));
endproperty

property p9;
  
  disable iff (!rst)
  (dut.m_htrans inside {2'b10, 2'b11} and dut.m_hready and dut.m_hwdata != 32'd0) |-> i_hwrite;
endproperty


property p10;
 (dut.m_hready and i_hwrite==0 and dut.m_htrans inside {2'b10,2'b11} |-> ##4 ($stable(o_hrdata) throughout $stable(i_haddr)) );
endproperty

//reset functionality
property p11;
 (!rst |-> (dut.m_haddr==32'd0 and dut.m_hwdata==32'd0 and o_hrdata==32'd0));
endproperty

//Assert that the master holds signals when wait states are inserted
property p12;
 (start and !dut.m_hready |-> (dut.m_haddr==$past(dut.m_haddr) ) and (dut.m_hwdata==$past(dut.m_hwdata)) and (dut.m_hwrite==$past(dut.m_hwrite)) );
endproperty

//data read is exactly same as data wrote at that location . do at the end
property p13;
  integer waddr;
  logic [31:0] data;
  ((i_hwrite,waddr=dut.m_haddr,data=i_hwdata)|-> ##[1:30] !i_hwrite ##2 (dut.m_haddr==waddr) ##2 (o_hrdata==data));
 
endproperty


//Assert that no read is attempted before the corresponding write completes
//for checking same on write just copy paste and replace i_hwrite with i_hread
property p14;
   (dut.m_hready and i_hwrite and i_hburst==1 |-> $stable(i_hwrite )[*1:$] );

endproperty

property p15;
   (dut.m_hready and i_hwrite and i_hburst==2 |-> $stable(i_hwrite)[*4:$] );

endproperty


property p16;
   (dut.m_hready and i_hwrite and i_hburst==3 |-> $stable(i_hwrite)[*4:$] );

endproperty


property p17;
   (dut.m_hready and i_hwrite and i_hburst==4 |-> $stable(i_hwrite)[*8:$] );

endproperty

property p18;
   (dut.m_hready and i_hwrite and i_hburst==5 |-> $stable(i_hwrite)[*8:$] );

endproperty

property p19;
   (dut.m_hready and i_hwrite and i_hburst==6 |-> $stable(i_hwrite )[*16:$] );

endproperty

property p20;
   (dut.m_hready and i_hwrite and i_hburst==7 |-> $stable(i_hwrite)[*16:$] );

endproperty

//Assert that the number of beats matches the burst type (e.g., INCR4 does 4 beats) 
//also checks that the addr is incrementing according to size
property p21;
 (dut.m_hready and i_hburst==1 and i_hsize==1|-> (dut.m_haddr==$past(dut.m_haddr+1))[*1:$]);
endproperty

property p22;
 (dut.m_hready and i_hburst==2 and i_hsize==1 |-> (dut.m_haddr==$past(dut.m_haddr+1))[*4:$]);
endproperty

property p23;
 (dut.m_hready and i_hburst==3 and i_hsize==1 |-> (dut.m_haddr==$past(dut.m_haddr+1))[*4:$]);
endproperty

property p24;
 (dut.m_hready and i_hburst==4 and i_hsize==1 |-> (dut.m_haddr==$past(dut.m_haddr+1))[*8:$]);
endproperty

property p25;
 (dut.m_hready and i_hburst==5 and i_hsize==1 |-> (dut.m_haddr==$past(dut.m_haddr+1))[*8:$]);
endproperty

property p26;
 (dut.m_hready and (i_hburst==6 or i_hburst==7) and i_hsize==1 |-> (dut.m_haddr==$past(dut.m_haddr+1))[*16:$]);
endproperty

//for i_hsize=2
property p27;
 (dut.m_hready and i_hburst==1 and i_hsize==2|-> (dut.m_haddr==$past(dut.m_haddr+2))[*1:$]);
endproperty

property p28;
 (dut.m_hready and i_hburst==2 and i_hsize==2 |-> (dut.m_haddr==$past(dut.m_haddr+2))[*4:$]);
endproperty

property p29;
 (dut.m_hready and i_hburst==3 and i_hsize==2 |-> (dut.m_haddr==$past(dut.m_haddr+2))[*4:$]);
endproperty

property p30;
 (dut.m_hready and i_hburst==4 and i_hsize==2 |-> (dut.m_haddr==$past(dut.m_haddr+2))[*8:$]);
endproperty

property p31;
 (dut.m_hready and i_hburst==5 and i_hsize==2 |-> (dut.m_haddr==$past(dut.m_haddr+2))[*8:$]);
endproperty

property p32;
 (dut.m_hready and (i_hburst==6 or i_hburst==7) and i_hsize==2 |-> (dut.m_haddr==$past(dut.m_haddr+2))[*16:$]);
endproperty

//for i_hsize==3

property p33;
 (dut.m_hready and i_hburst==1 and i_hsize==3|-> (dut.m_haddr==$past(dut.m_haddr+4))[*1:$]);
endproperty

property p34;
 (dut.m_hready and i_hburst==2 and i_hsize==3 |-> (dut.m_haddr==$past(dut.m_haddr+4))[*4:$]);
endproperty

property p35;
 (dut.m_hready and i_hburst==3 and i_hsize==3 |-> (dut.m_haddr==$past(dut.m_haddr+4))[*4:$]);
endproperty

property p36;
 (dut.m_hready and i_hburst==4 and i_hsize==3 |-> (dut.m_haddr==$past(dut.m_haddr+4))[*8:$]);
endproperty

property p37;
 (dut.m_hready and i_hburst==5 and i_hsize==3 |-> (dut.m_haddr==$past(dut.m_haddr+4))[*8:$]);
endproperty

property p38;
 (dut.m_hready and (i_hburst==6 or i_hburst==7) and i_hsize==3 |-> (dut.m_haddr==$past(dut.m_haddr+4))[*16:$]);
endproperty

//address holds it previous value on invalid burst value
property p39;
 (dut.m_hready and i_hburst==1 and i_hwrite|-> $stable(dut.m_haddr) and $stable(i_hwdata) );
endproperty


property p40;
 (dut.m_hready and i_hsize>2 |=> dut.m_haddr==32'bx);
endproperty

A1:  assert property(p1)  else $error("P1 failed");
A2:  assert property(p2)  else $error("P2 failed");
A3:  assert property(p3)  else $error("P3 failed");
A4:  assert property(p4)  else $error("P4 failed");
A5:  assert property(p5)  else $error("P5 failed");
A6:  assert property(p6)  else $error("P6 failed");
A7:  assert property(p7)  else $error("P7 failed");
A8:  assert property(p8)  else $error("P8 failed");
A9:  assert property(p9)  else $error("P9 failed");
A10: assert property(p10) else $error("P10 failed");
A11: assert property(p11) else $error("P11 failed");
A12: assert property(p12) else $error("P12 failed");
A13: assert property(p13) else $error("P13 failed");
A14: assert property(p14) else $error("P14 failed");
A15: assert property(p15) else $error("P15 failed");
A16: assert property(p16) else $error("P16 failed");
A17: assert property(p17) else $error("P17 failed");
A18: assert property(p18) else $error("P18 failed");
A19: assert property(p19) else $error("P19 failed");
A20: assert property(p20) else $error("P20 failed");
A21: assert property(p21) else $error("P21 failed");
A22: assert property(p22) else $error("P22 failed");
A23: assert property(p23) else $error("P23 failed");
A24: assert property(p24) else $error("P24 failed");
A25: assert property(p25) else $error("P25 failed");
A26: assert property(p26) else $error("P26 failed");
A27: assert property(p27) else $error("P27 failed");
A28: assert property(p28) else $error("P28 failed");
A29: assert property(p29) else $error("P29 failed");
A30: assert property(p30) else $error("P30 failed");
A31: assert property(p31) else $error("P31 failed");
A32: assert property(p32) else $error("P32 failed");
A33: assert property(p33) else $error("P33 failed");
A34: assert property(p34) else $error("P34 failed");
A35: assert property(p35) else $error("P35 failed");
A36: assert property(p36) else $error("P36 failed");
A37: assert property(p37) else $error("P37 failed");
A38: assert property(p38) else $error("P38 failed");
A39: assert property(p39) else $error("P39 failed");
A40: assert property(p40) else $error("P40 failed");

endmodule