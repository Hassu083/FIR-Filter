module FIR_DSP (
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

  // DSP48E1 Cascade Signals
  wire [47:0] pcout [0:8];  // DSP output cascade
  wire [29:0] a_input [0:8]; // DSP A input (30-bit)
  wire [17:0] b_input [0:8]; // DSP B input (18-bit)

  // Assign coefficients to B inputs
  assign b_input[0] = {coeffs[0], 2'b00};  // Pad to 18 bits
  assign b_input[1] = {coeffs[1], 2'b00};
  assign b_input[2] = {coeffs[2], 2'b00};
  assign b_input[3] = {coeffs[3], 2'b00};
  assign b_input[4] = {coeffs[4], 2'b00};
  assign b_input[5] = {coeffs[5], 2'b00};
  assign b_input[6] = {coeffs[6], 2'b00};
  assign b_input[7] = {coeffs[7], 2'b00};
  assign b_input[8] = {coeffs[8], 2'b00};

  // Assign A inputs (shift register)
  assign a_input[0] = {{14{data_in[15]}}, data_in};  // Sign-extend to 30 bits
  assign a_input[1] = a_input[0];  // Delay line propagation
  assign a_input[2] = a_input[1];
  assign a_input[3] = a_input[2];
  assign a_input[4] = a_input[3];
  assign a_input[5] = a_input[4];
  assign a_input[6] = a_input[5];
  assign a_input[7] = a_input[6];
  assign a_input[8] = a_input[7];

  // Instantiate 9 DSP48E1 primitives (one per tap)
  genvar i;
  generate
    for (i = 0; i < 9; i = i + 1) begin : DSP_Chain
      DSP48E1 #(
        .USE_DPORT("FALSE"),
        .ALUMODEREG(1),
        .AREG(1),       // Use 1 register on A input
        .BREG(1),       // Use 1 register on B input
        .CREG(1),       // Use 1 register on C input
        .OPMODEREG(1),  // Use 1 register for OPMODE
        .MREG(1),       // Use multiplier output register
        .PREG(1)        // Use output register
      ) dsp (
        .CLK(clk),
        .RST(reset),
        // Input A (30-bit), B (18-bit), C (48-bit)
        .A(a_input[i]),
        .B(b_input[i]),
        .C(i == 0 ? 48'd0 : pcout[i-1]),  // Cascade previous sum
        // Control signals (configure for MAC)
        .OPMODE(7'b0110101),  // Multiply + accumulate (Z = C + A*B)
        .ALUMODE(4'b0000),    // Add (Z = X + Y)
        // Cascade output
        .PCOUT(pcout[i]),
        .P(pcout[i])
      );
    end
  endgenerate

  assign data_out = pcout[8][31:0];

endmodule
