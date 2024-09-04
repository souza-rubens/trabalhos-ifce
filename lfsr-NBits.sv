parameter nBits = 32;
parameter valorInicial = 4953;

module lfsrnBits(
    input logic clk,
    output logic[nBits - 1:0] lfsr = valorInicial
);

wire feedback = lfsr[nBits - 1];
always_ff @( posedge clk ) 
begin
        for(int i=1; i<nBits; i++)
    begin
        lfsr[i] <= lfsr[i-1];
    end      
lfsr[0] <= lfsr[nBits - 2] ^ feedback;
end

endmodule
