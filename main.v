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
    integer hit_counter = 32'd0;
    reg[31:0] counter = 32'd0;
    reg[31:0] set0[3:0];
    // reg[31:0] i = 32'd0;
    reg[31:0] random_ind = 32'd0;
    reg[31:0] cache_data_offset_start = 32'd0;
    reg[31:0] cache_data_offset_end = 32'd0;

    initial
    begin

      for(i=0; i<4096; i=i+1)
				memory[i] = i;


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
          $display("Address: %b", address);
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
                  if (valid_bit[j]==1 && cache[index][j][36:32]==tag)
                    begin
                      read_hit=1;
                      // $display("\n" + memory[tag]);
                    end
                end

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
                  $display("memory data: %d", memory[address]);
                  cache_data_offset_start = 31 - 8*offset;
                  cache_data_offset_end = cache_data_offset_start-32'd7;
                  cache[index][replace][cache_data_offset_start -:8] = memory[address];
                  cache[index][replace][37] = 1;
                  cache[index][replace][36 -:5] = tag;
                  $display("cache: %b", cache[index][replace]);
                end
                else
                begin
                  $display("It was a hit\n");
                  hit_counter = hit_counter + 1;
                end
              // $display(cache[index][j]+ "\n\n");
              // if (cache[index][j][36:32]==tag)
              //   begin
              //     read_hit=1;
              //     // $display("\n" + memory[tag]);
              //   end

            end
          end
    end
endmodule