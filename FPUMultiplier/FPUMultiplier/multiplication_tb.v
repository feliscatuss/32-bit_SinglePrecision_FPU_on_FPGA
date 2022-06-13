module multiplication_tb;

reg [31:0] a,b;
wire exception,overflow,underflow;
wire [31:0] res;

reg clk = 1'b1;

FPUMultiplier dut(a,b,exception,overflow,underflow,res);

always clk = #5 ~clk;

initial
begin

iteration (32'b01000010001011001001100110011001,32'b01000010011111001000010100011110,1'b0,1'b0,1'b0,32'b01000101001100100001000011101001,`__LINE__); // 45.13 * 63.13 = 2849.0569;

iteration (32'b01000000010010011001100110011001,32'b11000001011001100011110101110000,1'b0,1'b0,1'b0,32'b11000010001101010101000001100010,`__LINE__); //3.15 * -14.39 = -45.3285

iteration (32'b11000001010100100110011001100110,32'b11000010010000001010001111010111,1'b0,1'b0,1'b0,32'b01000100000111100101001101110100,`__LINE__); //-13.15 * -48.16 = 633.304

iteration (32'b01000100100110100100000000000000,32'b01000100100110100100000000000000,1'b0,1'b0,1'b0,32'b01001001101110011110001000100000,`__LINE__); //4096 * 4096 = 16777216

iteration (32'b00111010110010100110001011000001,32'b00110101101001100001101110011100,1'b0,1'b0,1'b0,32'b00110001000000110101000111011101,`__LINE__); //0.00154408081 * 0.0000012376 = 0.000000001910954410456

iteration (32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,1'b0,1'b0,1'b0,32'b00000000000000000000000000000000,`__LINE__); // 0 * 0 = 0;

iteration (32'b11000001110011111110011010011010,32'b00000000000000000000000000000000,1'b0,1'b0,1'b0,32'b00000000000000000000000000000000,`__LINE__); //-25.9876 * 0 = 0;

$stop;

end

task iteration(
input [31:0] op_a,op_b,
input Expected_Exception,Expected_Overflow,Expected_Underflow,
input [31:0] Expected_result,
input integer linenum 
);
begin
@(negedge clk)
begin
	a = op_a;
	b = op_b;
end

@(posedge clk)
begin
if ((Expected_result == res) && (Expected_Exception == exception) && (Expected_Overflow == overflow) && (Expected_Underflow == underflow))
	$display ("Success : %d",linenum);

else
	$display ("Failed : Expected_result = %b, Result = %b, \n Expected_Exception = %b, Exception = %b,\n Expected_Overflow = %b, Overflow = %b, \n Expected_Underflow = %b, Underflow = %b - %b \n ",Expected_result,res,Expected_Exception,exception,Expected_Overflow,overflow,Expected_Underflow,underflow,linenum);
end
end
endtask
endmodule