module Full_Adder(a,b,cin,s,cout);
	input a,b,cin;
	output s,cout;
	
	assign s = a^b^cin;
	assign cout = a&b | b&cin | cin&a;
endmodule

module Adder_8(a,b,cin,s,cout);
	input [7:0] a,b;
	input cin;
	output [7:0] s;
	output cout;
	
	wire [6:0] c_sig;
	
	Full_Adder F1 (.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .cout(c_sig[0]));
	Full_Adder F2 (.a(a[1]), .b(b[1]), .cin(c_sig[0]), .s(s[1]), .cout(c_sig[1]));
	Full_Adder F3 (.a(a[2]), .b(b[2]), .cin(c_sig[1]), .s(s[2]), .cout(c_sig[2]));
	Full_Adder F4 (.a(a[3]), .b(b[3]), .cin(c_sig[2]), .s(s[3]), .cout(c_sig[3]));
	Full_Adder F5 (.a(a[4]), .b(b[4]), .cin(c_sig[3]), .s(s[4]), .cout(c_sig[4]));
	Full_Adder F6 (.a(a[5]), .b(b[5]), .cin(c_sig[4]), .s(s[5]), .cout(c_sig[5]));
	Full_Adder F7 (.a(a[6]), .b(b[6]), .cin(c_sig[5]), .s(s[6]), .cout(c_sig[6]));
	Full_Adder F8 (.a(a[7]), .b(b[7]), .cin(c_sig[6]), .s(s[7]), .cout(cout));
endmodule
	