module limiter (
    input signed [31:0] sign_data,
    input signed [31:0] gain,
    input signed [31:0] upper_bound,
    input signed [31:0] lower_bound,


    output signed [31:0] out
);

  reg [31:0] dat_limited;
  always @(*) begin

    dat_limited = sign_data;

    if (sign_data >= upper_bound) begin
      dat_limited = upper_bound;
    end

    if (sign_data <= lower_bound) begin
      dat_limited = lower_bound;
    end

  end

  assign out = dat_limited * gain;

endmodule
