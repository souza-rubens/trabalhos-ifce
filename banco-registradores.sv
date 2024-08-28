//Registrador PIPO
module regPIPO(
	input logic clk, rst, wr_en,
	input logic[7:0] din,
	output logic[7:0] dout
);
	logic[7:0] q_next, q_reg;
	
always_ff @(posedge clk, posedge rst)
begin
    if (rst == 1'b1)
        q_reg <= 8'b0; 
    else if (wr_en == 1'b1)
        q_reg <= q_next;
end
  
assign q_next = din;
assign dout = q_reg;

endmodule

//MUX
module mux4x1(
	input logic [1:0] sel,
	input logic [7:0] d0, d1, d2, d3,
	output logic [7:0] o
);
always_comb
begin
	case (sel)
	2'b00: o = d0;
	2'b01: o = d1;
	2'b10: o = d2;
	2'b11: o = d3;
	default: o = 8'b00000000;
	endcase
end

endmodule

//DEMUX
module demux4x1(
	input logic [1:0] sel2,
    input logic in,
    output logic [3:0] o2
);
always_comb
begin
	o2 = 4'b00000000;
	o2[sel2] = in;
end

endmodule

//BANCO DE REGISTRADORES
module banco(
	input logic clk,
	input logic rst,
	input logic wr_en,
	input logic [1:0] add_rd0, add_rd1, add_wr,
	input logic [7:0] wr_data,
	output logic [7:0] rd0, rd1
);
	logic [7:0] reg_data [3:0];
    logic [3:0] demux_out;
    logic [7:0] mux_out0, mux_out1;

demux4x1 demux_inst(.sel2(add_wr), .in(wr_en), .o2(demux_out));
regPIPO reg0 (.clk(clk), .rst(rst), .wr_en(demux_out[0]), .din(wr_data), .dout(reg_data[0]));
regPIPO reg1 (.clk(clk), .rst(rst), .wr_en(demux_out[1]), .din(wr_data), .dout(reg_data[1]));
regPIPO reg2 (.clk(clk), .rst(rst), .wr_en(demux_out[2]), .din(wr_data), .dout(reg_data[2]));
regPIPO reg3 (.clk(clk), .rst(rst), .wr_en(demux_out[3]), .din(wr_data), .dout(reg_data[3]));
mux4x1 mux_inst0(.sel(add_rd0), .d0(reg_data[0]), .d1(reg_data[1]), .d2(reg_data[2]), .d3(reg_data[3]), .o(mux_out0));
mux4x1 mux_inst1(.sel(add_rd1), .d0(reg_data[0]), .d1(reg_data[1]), .d2(reg_data[2]), .d3(reg_data[3]), .o(mux_out1));

assign rd0 = mux_out0;
assign rd1 = mux_out1;

endmodule