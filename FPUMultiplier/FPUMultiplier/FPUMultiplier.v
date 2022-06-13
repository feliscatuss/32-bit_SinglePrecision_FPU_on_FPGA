module FPUMultiplier(input [31:0] a, input [31:0] b, output exception, overflow, underflow, output [31:0] out);

wire sign, round, normalised, zero;
wire [8:0] exponent, sum_exponent;
wire [22:0] product_mantissa;
wire [23:0] op_a, op_b;
wire [47:0] product, product_normalised; 


assign sign = a[31] ^ b[31];   													// XOR of 32nd bit
assign exception = (&a[30:23]) | (&b[30:23]);											// Execption sets to 1 when exponent of any a or b is 255
																// If exponent is 0, hidden bit is 0
assign zero = exception ? 1'b0 : (a[22:0] == 23'd0 || b[22:0] == 23'd0) ? 1'b1 : 1'b0;

assign op_a = (|a[30:23]) ? {1'b1,a[22:0]} : {1'b0,a[22:0]};
assign op_b = (|b[30:23]) ? {1'b1,b[22:0]} : {1'b0,b[22:0]};

assign product = op_a * op_b;													// Product
assign round = |product_normalised[22:0];  											// Last 22 bits are ORed for rounding off purpose
assign normalised = product[47] ? 1'b1 : 1'b0;	
assign product_normalised = normalised ? product : product << 1;								// Normalized value based on 48th bit
assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & round); 					// Mantissa
assign sum_exponent = a[30:23] + b[30:23];
assign exponent = sum_exponent - 8'd127 + normalised;
assign overflow = ((exponent[8] & !exponent[7]) & !zero) ? 1'b1: 1'b0; 									// exponent > 255
assign underflow = ((exponent[8] & exponent[7]) & !zero) ? 1'b1 : 1'b0; 			   // exponent < 0
assign out = exception ? 32'd0 : zero ? {sign,31'd0} : overflow ? {sign,8'hFF,23'd0} : underflow ? {sign,31'd0} : {sign,exponent[7:0],product_mantissa};

endmodule



