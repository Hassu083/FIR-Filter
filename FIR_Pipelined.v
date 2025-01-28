module FIR_Pipelined (
  input wire clk,
  input wire reset,
  input wire signed [15:0] data_in,
  output wire signed [31:0] data_out
);

  // Coefficients
  localparam [15:0] coeffs [0:8] = '{
    16'h0002, 16'hFFFB, 16'h000A, 16'hFFEC, 16'h0070,
    16'hFFEC, 16'h000A, 16'hFFFB, 16'h0002
  };

  // Shift Register 
  reg signed [15:0] samples [0:8];
  reg signed [15:0] d1, d2, d3, d4, d5, d6, d7, d8, d9;

  // Pipeline Registers 
  reg signed [31:0] m0, m1, m2, m3, m4, m5, m6, m7, m8;
  reg signed [31:0] a0, a1, a2, a3, a4, a5, a6, a7;

  // Shift Register Update 
  always @(posedge clk) begin
    if (reset) begin
      d1 <= 0; d2 <= 0; d3 <= 0; d4 <= 0; d5 <= 0;
      d6 <= 0; d7 <= 0; d8 <= 0; d9 <= 0;
    end else begin
      d1 <= data_in;   
      d2 <= d1;       
      d3 <= d2;
      d4 <= d3;
      d5 <= d4;
      d6 <= d5;
      d7 <= d6;
      d8 <= d7;
      d9 <= d8;
    end
  end

  // Pipelined Multiply Stage
  always @(posedge clk) begin
    m0 <= d1 * coeffs[0];  
    m1 <= d2 * coeffs[1];  
    m2 <= d3 * coeffs[2];
    m3 <= d4 * coeffs[3];
    m4 <= d5 * coeffs[4];
    m5 <= d6 * coeffs[5];
    m6 <= d7 * coeffs[6];
    m7 <= d8 * coeffs[7];
    m8 <= d9 * coeffs[8];
  end

  // Pipelined Accumulate Stage 
  always @(posedge clk) begin
    a0 <= m0 + m1;    
    a1 <= m2 + m3;
    a2 <= m4 + m5;
    a3 <= m6 + m7;
    a4 <= a0 + a1;    
    a5 <= a2 + a3;
    a6 <= a4 + a5;    
    a7 <= a6 + m8;    
  end

  assign data_out = a7;

endmodule
