module SSD_LettersAndNums(in, seg);

	input [4:0] in;
	output [7:0] seg;
   reg [7:0] seg;

    always @(in)
    begin
        case (in) //case statement
            4'b0000 : seg = 8'b11000000; // display "0"
            4'b0001 : seg = 8'b11111001; // display "1"
            4'b0010 : seg = 8'b10100100; // display "2"
            4'b0011 : seg = 8'b10110000; // display "3"
            4'b0100 : seg = 8'b10011001; // display "4"
            4'b0101 : seg = 8'b10010010; // display "5"
            4'b0110 : seg = 8'b10000010; // display "6"
            4'b0111 : seg = 8'b11111000; // display "7"
            4'b1000 : seg = 8'b10000000; // display "8"
            4'b1001 : seg = 8'b10010000; // display "9"
				/*Letters for UI*/
				4'b1010 : seg = 8'b10001000; // display "A"
				4'b1011 : seg = 8'b10000011; // display "B"
				4'b1100 : seg = 8'b11000110; // display "C"
				/* misc. */
				4'b1101 : seg = 8'b10111111; // display "-"
				4'b1110 : seg = 8'b10101111; // display "r"
				4'b1111 : seg = 8'b10101011; // display "n"				

            default : seg = 8'b11111111; 
        endcase
    end
    
endmodule
