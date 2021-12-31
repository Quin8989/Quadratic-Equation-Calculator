/* 

Copyright (c) 2012, Ameer M. Abdelhadi; ameer@ece.ubc.ca. All rights reserved.

Redistribution  and  use  in  source   and  binary  forms,   with  or  without
modification,  are permitted  provided that  the following conditions are met:
  * Redistributions   of  source   code  must  retain   the   above  copyright
    notice,  this   list   of   conditions   and   the  following  disclaimer.
  * Redistributions  in  binary  form  must  reproduce  the  above   copyright
    notice, this  list  of  conditions  and the  following  disclaimer in  the
    documentation and/or  other  materials  provided  with  the  distribution.
  * Neither the name of the University of British Columbia (UBC) nor the names
    of   its   contributors  may  be  used  to  endorse  or   promote products
    derived from  this  software without  specific  prior  written permission.

THIS  SOFTWARE IS  PROVIDED  BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND  ANY EXPRESS  OR IMPLIED WARRANTIES,  INCLUDING,  BUT NOT LIMITED TO,  THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED.  IN NO  EVENT SHALL  THE UNIVERSITY OF BRITISH COLUMBIA  BE LIABLE
FOR ANY DIRECT,  INDIRECT,  INCIDENTAL,  SPECIAL,  EXEMPLARY, OR CONSEQUENTIAL
DAMAGES  (INCLUDING,  BUT NOT LIMITED TO,  PROCUREMENT OF  SUBSTITUTE GOODS OR
SERVICES;  LOSS OF USE,  DATA,  OR PROFITS;  OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY,  WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF  THIS SOFTWARE,  EVEN  IF  ADVISED  OF  THE  POSSIBILITY  OF  SUCH  DAMAGE.

---------------------------------------------------------------------------------

	converts a binary number into its equivalent Binary Code Decimal form (BCD)
	using the double-dabble method. Used to help display results in decimal form.
 
	Original unmodified code is written by Ameer M. Abdelhadi, source: 
	https://github.com/AmeerAbdelhadi/Binary-to-BCD-Converter

*/

module bin2bcd
 #( parameter                W = 10)  // input width
  ( input      [W-1      :0] bin   ,  // binary
    output reg [W+(W-4)/3:0] bcd   ); // bcd {...,thousands,hundreds,tens,ones}

  integer i,j;

  always @(bin) begin
    for(i = 0; i <= W+(W-4)/3; i = i+1) bcd[i] = 0;     // initialize with zeros
    bcd[W-1:0] = bin;                                   // initialize with input vector
    for(i = 0; i <= W-4; i = i+1)                       // iterate on structure depth
      for(j = 0; j <= i/3; j = j+1)                     // iterate on structure width
        if (bcd[W-i+4*j -: 4] > 4)                      // if > 4
          bcd[W-i+4*j -: 4] = bcd[W-i+4*j -: 4] + 4'd3; // add 3
  end

endmodule