`include "lru.v"

module memory();
  reg [7:0] memory[4095:0];
  // integer cache [4:0][3:0];
  reg [20:0] instruction_set;
  reg [20:0] instn;
  reg valid_bit;
  reg [7:0] address;
  reg [31:0] data;
  reg [2:0] tag;
  reg [2:0] index;
  reg [1:0] offset;

integer i;
    initial
    begin
      $readmemb("instruction.txt", instruction_set);
      for (i=0; i<100; i=i+1)
        begin
          instn = instruction_set[i];
          valid_bit = instn[40];
          address = instn[39:32]; 
          data = instn[31:0];
          tag = address[7:5];
          index = address[4:2];
          offset = address[1:0];
          
        end

    end
endmodule