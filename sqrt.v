/* 

.v implimentation for finding the integer square root of a number using the "Square and compare" method.
Described by the paper “Implementation of Integer Square Root” 

	- ISSN: 2319-5967
	- Authors: Addanki Purna Ramesh, I. JAYARAM KUMAR

	The MSB of the running result is changed to 1. If that makes the square of the running result
	larger than the input, the bit is changed back to 0, otherwise it is left at 1.
	This modify-and check sequence happens to each bit down to the LSB.
	This whole process should take no more than 16 clock cycles as the output is 16 bits long.
	
*/

module sqrt(clr, num, res, clk);

   input clr;
   input [31:0] num; // number to be square rooted
   output reg [15:0] res; // running result
	input clk;
   
   reg [31:0] resSqrd; //resSqrd = res**2
	
   reg [4:0] ind; //tracks the index of the bit we currently being changed/considered
   wire [15:0] chgBit = 1<<ind; 
   wire [31:0] chgBitSqrd = 1<<(ind<<1); // immitates the bit shift of "chgBit" as if chgBitSqrd = chgBit**2
	
	// bitwise or a single bit in res & resSqrd respectively for the next guesses of the correct binary sequence.
   wire [15:0] guess  = res | chgBit;
   wire [31:0] guessSqrd = resSqrd + chgBitSqrd + ((res<<ind)<<1);


   always @(posedge clk)begin
      if(clr) begin // clear memory to prepare for the next number to calculate the square root of	
			ind <= 15;      
			res <= 0;
			resSqrd <= 0;
      end
      else begin
			if(guessSqrd <= num) begin // if guess was correct for the iteration
				res  <= guess;
				resSqrd <= guessSqrd;
			end
			if(ind >= 0)
				ind <= ind -1;
		end
	end

endmodule
