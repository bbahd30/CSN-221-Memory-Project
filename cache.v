`include "lru.v"

module memory();
reg reset;
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
  //integer index;
  reg [1:0] offset;
  wire read_hit; //miss= 0
  reg [3:0] valid_bit; //
  reg [3:0] valid_bit_out;
  wire [31:0] way; //corresponds to replace in lru
  integer j;
  integer i;
  LRU lru (reset, read_hit, valid_bit, index, valid_bit_out, way);
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
          
    

          if (rwop==0)
          begin
            for ( j=0; j<3; j=j+1)
            begin
              valid_bit[j] = cache[index][j][37];
              
              // assign valid_bit = valid_bit_out;
              if (cache[index][j][36:32]==tag)
              begin
                read_hit=1;
              end
              
              
            end
            
          
          end
          
          
        end

    end
endmodule