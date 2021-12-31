module quadCalcTop(clk, nextButton, inputSwitches, SSDout0, SSDout1, SSDout2, SSDout3, SSDout4, SSDout5);

input clk, nextButton;
input signed [9:0] inputSwitches; // Used to determine the values of A,B & C from user inputs
output [7:0] SSDout0, SSDout1, SSDout2, SSDout3, SSDout4, SSDout5; // output signals for the Seven Segment Displays

reg bEn = 0; // button toggle enable
reg [3:0] seq = 0; // tracks State of the circuit
reg [3:0] SSDin0, SSDin1, SSDin2, SSDin3, SSDin4, SSDin5 = 0;
reg signed [9:0] A,B,C = 0;

wire [23:0] BCD_BsqwfourABS_out,BCD_numABS_out, BCD_x1_out, BCD_x2_out;
wire[9:0] inputSwitchesABS_VAL;
wire [31:0] BsqwfourA_ABS, x1_ABS, x2_ABS;
wire [15:0] BCD_sqrtRes_out; 
wire signed [15:0]sqrtRes;
reg sqrtClr = 1;

wire signed [31:0] BsqwfourA = B**2 -4*A*C; //Discriminant of quadratic function
wire signed[31:0] x1 = (-B+sqrtRes)/(2*A); //roots of function
wire signed[31:0] x2 = (-B-sqrtRes)/(2*A);
wire NRR = BsqwfourA[31];//pointer if function has real roots

assign BsqwfourA_ABS = (BsqwfourA[31])? -BsqwfourA : BsqwfourA; //absolute values of variables to put into B.C.D decoder
assign x1_ABS = (x1[31])? -x1 : x1;
assign x2_ABS = (x2[31])? -x2 : x2;
assign inputSwitchesABS_VAL = inputSwitches[9]? -inputSwitches:inputSwitches;



// CONTROL LOGIC:
always@(posedge clk) begin
	
	if(nextButton == 0) begin // if button is held down
		if(bEn == 0) begin // if button was NOT held down last clock cycle
			if(seq == 0) begin
				A <= inputSwitches;
				seq <= 1;
				bEn <= 1;
			end 
			else begin
				if(seq == 1) begin 
					B <= inputSwitches;
					seq <= 2;
					bEn <= 1;
				end
				else begin
					if(seq == 2) begin 
						C <= inputSwitches;
						sqrtClr <= 0; // allow memory to be loaded to sqrt module
						seq <= 3;
						bEn <= 1;
					end
					else begin
						if(seq == 3) begin 
							seq <= 4;
							bEn <= 1;
						end
						else begin
							if(seq == 4) begin
								seq <= 5;
								bEn <= 1;
							end
							else begin
								if(seq == 5) begin
									seq <= 6;
									bEn <= 1;
								end
								else begin
									bEn <= 1;
									seq <= 0;
									sqrtClr <= 1;
								end
							end
						end
					end 
				end
			end
		end
	end
	else begin
		bEn <= 0;
		
		if(seq == 0) begin
			SSDin0 <= BCD_numABS_out[3:0];
			SSDin1 <= BCD_numABS_out[7:4];
			SSDin2 <= BCD_numABS_out[11:8];
			SSDin3 <= BCD_numABS_out[15:12];
			SSDin4 <= (inputSwitches[9])?4'b1101:4'b0000;
			SSDin5 <= 4'b1010; //load "A" into 7.S.D "HEX5"
		end
		
		if(seq == 1) begin
			SSDin0 <= BCD_numABS_out[3:0];
			SSDin1 <= BCD_numABS_out[7:4];
			SSDin2 <= BCD_numABS_out[11:8];
			SSDin3 <= BCD_numABS_out[15:12];
			SSDin4 <= (inputSwitches[9])?4'b1101:4'b0000;
			SSDin5 <= 4'b1011; //load "B" into 7.S.D "HEX5"
		end
		
		if(seq == 2) begin
			SSDin0 <= BCD_numABS_out[3:0];
			SSDin1 <= BCD_numABS_out[7:4];
			SSDin2 <= BCD_numABS_out[11:8];
			SSDin3 <= BCD_numABS_out[15:12];
			SSDin4 <= (inputSwitches[9])?4'b1101:4'b0000;
			SSDin5 <= 4'b1100; //load "C" into 7.S.D "HEX5"
		end
		
		if(seq == 3) begin // display the discriminant of the function
			SSDin0 <= BCD_BsqwfourABS_out[3:0];
			SSDin1 <= BCD_BsqwfourABS_out[7:4];
			SSDin2 <= BCD_BsqwfourABS_out[11:8];
			SSDin3 <= BCD_BsqwfourABS_out[15:12];
			SSDin4 <= BCD_BsqwfourABS_out[19:16];
			SSDin5 <= (NRR)?4'b1101:BCD_numABS_out[23:20];
				
		end
		
		if(seq == 4) begin //display the integer sqrt of the discriminant
			SSDin0 <= (NRR)?4'b1110:BCD_sqrtRes_out[3:0];
			SSDin1 <= (NRR)?4'b1110:BCD_sqrtRes_out[7:4];
			SSDin2 <= (NRR)?4'b1111:BCD_sqrtRes_out[11:8];
			SSDin3 <= (NRR)?4'b0000:BCD_sqrtRes_out[15:12];
			SSDin4 <= 4'b0000;
			SSDin5 <= 4'b0000;
		end
		
		if(seq == 5) begin // display x1
			SSDin0 <= (NRR)?4'b1110:BCD_x1_out[3:0];
			SSDin1 <= (NRR)?4'b1110:BCD_x1_out[7:4];
			SSDin2 <= (NRR)?4'b1111:BCD_x1_out[11:8];
			SSDin3 <= (NRR)?4'b0000:BCD_x1_out[15:12];
			SSDin4 <= (NRR)?4'b0000:BCD_x1_out[19:16];
			SSDin5 <= (NRR)?4'b0000:(x1 < 0)?4'b1101:BCD_x1_out[23:20];
		end
		
		if(seq == 6) begin // display x2
			SSDin0 <= (NRR)?4'b1110:BCD_x2_out[3:0];
			SSDin1 <= (NRR)?4'b1110:BCD_x2_out[7:4];
			SSDin2 <= (NRR)?4'b1111:BCD_x2_out[11:8];
			SSDin3 <= (NRR)?4'b0000:BCD_x2_out[15:12];
			SSDin4 <= (NRR)?4'b0000:BCD_x2_out[19:16];
			SSDin5 <= (NRR)?4'b0000:(x2 < 0)?4'b1101:BCD_x2_out[23:20];
		end

	end
end

bin2bcd(inputSwitchesABS_VAL, BCD_numABS_out);
bin2bcd_wide(BsqwfourA_ABS, BCD_BsqwfourABS_out);
bin2bcd_wide(sqrtRes, BCD_sqrtRes_out);
bin2bcd_wide(x1_ABS, BCD_x1_out);
bin2bcd_wide(x2_ABS, BCD_x2_out);


SSD_LettersAndNums SSD0(SSDin0, SSDout0);
SSD_LettersAndNums SSD1(SSDin1, SSDout1);
SSD_LettersAndNums SSD2(SSDin2, SSDout2);
SSD_LettersAndNums SSD3(SSDin3, SSDout3);
SSD_LettersAndNums SSD4(SSDin4, SSDout4);
SSD_LettersAndNums SSD5(SSDin5, SSDout5);
sqrt(sqrtClr,BsqwfourA_ABS,sqrtRes,clk);

endmodule