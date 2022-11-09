module memory();
    reg [7:0] memory[4095:0];
    reg [38:0] cache [31:0][3:0];
    reg [20:0] instruction_set[0:3];
    reg [20:0] instn;
    reg rwop;
    reg [11:0] address;
    reg [31:0] data;
    reg [2:0] tag;
    reg [2:0] index;
    //integer index;
    reg [1:0] offset;
    reg read_hit; //miss= 0
    reg [3:0] valid_bit; //
    reg [3:0] valid_bit_out;
    reg [31:0] way; //corresponds to replace in lru
    integer j, i, k, a, b;
    input hit;
    // reg [3:0] valid_bit;

    reg[31:0] replace;

    reg[31:0] counter = 32'd0;
    reg[31:0] set0[3:0];
    // reg[31:0] i = 32'd0;
    reg[31:0] random_ind = 32'd0;

    initial
    begin

      for(i=0; i<32; i=i+1)
				memory[i] <= 32'd0;
      memory[1] = 1;
      memory[2] = 9;
      memory[3] = 6;
      memory[4] = 8;
      memory[5] = 1;
      memory[6] = 6;
      memory[7] = 7;


      for (a = 0; a<4; a = a + 1)
      begin
          for (b = 0; b<32; b = b+1)
          begin
              cache[b][a] = 0;
          end
      end

      $readmemb("instruction.txt", instruction_set);
      // $display(instruction_set[0]);
      $display("hel");
      for (i=0; i<2; i=i+1)
        begin
          instn = instruction_set[i];
          rwop = instn[20]; //read=0, write=1
          address = instn[19:8]; 
          data = instn[7:0];
          tag = address[11:7];
          index = address[6:2];
          offset = address[1:0];
          read_hit = 0;
          valid_bit = 4'b0000;          
          if (rwop==0)
            begin
              for ( j=0; j<=3; j=j+1)
                begin
                  valid_bit[j] = cache[index][j][37];

                  // LRU starts
                  if(read_hit==0)
                    begin
                      for (k=0; k<=3; k = k+1) //initialise to 0
                        begin
                          if(valid_bit[k]==0)
                          begin
                              set0[counter] = k;
                              counter = counter+1;
                          end
                        end
                      if(counter==1)
                      begin
                          valid_bit_out = ~valid_bit;
                          replace = set0[0];
                      end
                      else
                      begin
                          random_ind = $urandom%counter;
                          valid_bit_out = valid_bit;
                          valid_bit_out[set0[random_ind]] = 1;
                          replace = set0[random_ind];
                      end
                    end
                  $display(cache[index][j]+ "\n\n");
                  if (cache[index][j][36:32]==tag)
                    begin
                      read_hit=1;
                      // $display("\n" + memory[tag]);
                    end
                  
                end
            end
          end
    end
endmodule