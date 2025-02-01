module Datapath(IReg_En, Mux_PC_Add_Sel, PC_En, IAR_En, Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel, Mux_PC_In_Sel,
			clk, rst, Mux_Acc_In_Sel, ALU_Sel, Data_Bus_In, Data_Bus_Out, Address_Bus, IReg_Data_Out, PC_Data_Out, Acc_Data_Out);
	input IReg_En, Mux_PC_Add_Sel, PC_En, IAR_En, Acc_En, IReg_Buffer_Sel, PC_Buffer_Sel, IAR_Buffer_Sel, Acc_Buffer_Sel, Mux_PC_In_Sel, clk, rst;
	input [1:0] Mux_Acc_In_Sel, ALU_Sel;
	input [7:0] Data_Bus_In;
	output [7:0] Data_Bus_Out;
	output reg [7:0] Address_Bus;
	output [7:0] IReg_Data_Out, PC_Data_Out, Acc_Data_Out;
	
	wire [7:0] IReg_Data_Out_Buff, PC_Data_Out_Buff, Acc_Data_Out_Buff;
	wire [7:0] IReg_Data_In, IAR_Data_In, Acc_Data_In, ALU_Data_Out, IAR_Data_Out;
	wire [7:0] IReg_Acc_Signal, PC_Incremented_Signal, PC_Adding_Signal, target, Abus1, Abus2, Abus3;
	wire [7:0] PC_Data_In;
	assign IReg_Data_In = Data_Bus_In;
	always @(*)
	begin
		if (PC_Buffer_Sel == 1'b1) Address_Bus = Abus2;
		else if (IReg_Buffer_Sel == 1'b1) Address_Bus = Abus1;
		else Address_Bus = Abus3;
	end 
	
	Pipo_Register IReg (.din(IReg_Data_In), .dout(IReg_Data_Out_Buff), .en(IReg_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit IReg_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(target), .S(IReg_Buffer_Sel), .Y(Abus1));
	assign target = {4'b0000, IReg_Data_Out_Buff[3:0]};
	
	Mux_2x1_8_bit Mux_PC_Add (.I1(8'b00000001), .I0(target), .S(Mux_PC_Add_Sel), .Y(PC_Adding_Signal));
	Mux_2x1_8_bit Mux_PC_Input_Sel (.I1(Data_Bus_In), .I0(PC_Incremented_Signal), .S(Mux_PC_In_Sel), .Y(PC_Data_In));
	Adder_8 Adder (.a(PC_Adding_Signal), .b(PC_Data_Out_Buff), .cin(1'b0), .s(PC_Incremented_Signal), .cout());
	Pipo_Register PC (.din(PC_Data_In), .dout(PC_Data_Out_Buff), .en(PC_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit PC_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(PC_Data_Out_Buff), .S(PC_Buffer_Sel), .Y(Abus2));
	
	assign IAR_Data_In = Data_Bus_In;
	Pipo_Register IAR (.din(IAR_Data_In), .dout(IAR_Data_Out), .en(IAR_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit IAR_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(IAR_Data_Out), .S(IAR_Buffer_Sel), .Y(Abus3));
	
	Mux_4x1_8_bit Mux_ACC (.I3(ALU_Data_Out), .I2(Data_Bus_In), .I1(target), .I0(8'bzzzzzzzz), .S(Mux_Acc_In_Sel), .Y(Acc_Data_In));
	Pipo_Register ACC (.din(Acc_Data_In), .dout(Acc_Data_Out_Buff), .en(Acc_En), .rst(rst), .clk(clk));
	Mux_2x1_8_bit ACC_Tristate_Buffer (.I0(8'bzzzzzzzz), .I1(Acc_Data_Out_Buff), .S(Acc_Buffer_Sel), .Y(Data_Bus_Out));
	
	ALU AL_Unit (.a(Acc_Data_Out_Buff), .b(Data_Bus_In), .y(ALU_Data_Out), .s(ALU_Sel));
	
	assign IReg_Data_Out = IReg_Data_Out_Buff;
	assign PC_Data_Out = PC_Data_Out_Buff;
	assign Acc_Data_Out = Acc_Data_Out_Buff;
endmodule
