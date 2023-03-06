module limiter (
    input signed [31:0] sign_data,
    input signed [31:0] gain, // 
    /* input signed [31:0] upper_bound, */
    /* input signed [31:0] lower_bound, */


    output signed [31:0] out
);

  wire signed [63:0] data_multiplxed = gain * sign_data;
  reg [31:0] dat_limited;
  always @(*) begin

    dat_limited = data_multiplxed[31:0];

    if (data_multiplxed  >= $signed(64'h0000_0000_7FFF_FFFF)) begin
      dat_limited = 32'h7FFF_FFFF;
    end

    if (data_multiplxed  <= $signed(64'hFFFF_FFFF_8000_0000)) begin
      dat_limited = 32'h8000_0000;
    end

  end

  assign out = dat_limited;

endmodule
