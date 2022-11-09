`include "lru.v"

module memory();
  reg [7:0] memory[1023:0][3:0];
  reg [38:0] cache [31:0][3:0];
  // reg v_bit [31:0][3:0];
  // reg m_bit [31:0][3:0];
  reg [20:0] instruction_set[99:0];
  reg [20:0] instn;
  reg rwop;
  reg [11:0] address;
  reg [31:0] data;
  reg [2:0] tag;
  reg [2:0] index;
  // integer index;
  reg [1:0] offset;
  reg read_hit; //miss= 0
  reg [3:0] valid_bit; //
  reg [3:0] valid_bit_out;
  reg [31:0] way; //corresponds to replace in lru
integer i;
    initial
    begin
      $readmemb("instruction.txt", instruction_set);
      for (i=0; i<100; i=i+1)
        begin
          instn = instruction_set[i];
          rwop = instn[20]; //read=0, write=1
          address = instn[19:8]; 
          data = instn[7:0];
          tag = address[11:7];
          index = address[6:2];
          offset = address[1:0];
          read_hit = 0;
          // valid_bit = 4'b0000;

          if (rwop==0)
          begin
            for (integer i=0; i<3; i=i+1)
            begin
              valid_bit[i] = cache[index][i][37];
              LRU(read_hit, valid_bit, valid_bit_out, way);
              // assign valid_bit = valid_bit_out;
              if (cache[index][i][36:32]==tag)
              begin
                read_hit=1;
              end
              
              
            end
            
            begin

            end
          end
          
          
        end

    end
endmodule