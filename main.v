module memory();
    parameter MAIN_MEMORY_SIZE_EXP = 32'd24;
    parameter CACHE_SIZE_EXP = 32'd14;
    parameter WAYS_EXP = 32'd4; //New addition
    // parameter WAYS = 32'd1<<WAYS_EXP; //New addition
    parameter ADDRESS_SIZE = 32'd24;
    // parameter BLOCK_SIZE = 32'd32;
    // parameter BLOCK_SIZE_EXP = 32'd5;
    parameter BLOCK_SIZE = 32'd64;
    parameter BLOCK_SIZE_EXP = 32'd6;
    parameter DATA_SIZE = 32'd8;
    parameter OFFSET_EXP = 32'd3;
    parameter NO_OF_INST = 32'd41832;
    // parameter INDEX_SIZE_EXP = CACHE_SIZE_EXP - (OFFSET_EXP + BLOCK_SIZE_EXP);
    parameter INDEX_SIZE_EXP = CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP);

    integer tag_size = ADDRESS_SIZE - INDEX_SIZE_EXP - OFFSET_EXP;
    integer CACHE_DATA_SIZE = 32'd2 + ADDRESS_SIZE - INDEX_SIZE_EXP + BLOCK_SIZE;
    // integer CACHE_DATA_SIZE = WAYS_EXP + ADDRESS_SIZE - INDEX_SIZE_EXP + BLOCK_SIZE;
    integer INDEX_SIZE = 32'd1<<INDEX_SIZE_EXP;

    // reg [DATA_SIZE-1:0] memory[32'd1<<(MAIN_MEMORY_SIZE_EXP-2):0][3:0];
    reg [DATA_SIZE-1:0] memory[32'd1<<(MAIN_MEMORY_SIZE_EXP-(BLOCK_SIZE_EXP-3)):0][32'd1<<(BLOCK_SIZE_EXP-3)-1:0];
    // reg [32'd2 + ADDRESS_SIZE + CACHE_SIZE_EXP - (OFFSET_EXP + BLOCK_SIZE_EXP) + BLOCK_SIZE -1:0] cache [32'd1<<(CACHE_SIZE_EXP - (OFFSET_EXP + BLOCK_SIZE_EXP))-1:0][3:0];
    // reg [WAYS_EXP + ADDRESS_SIZE + CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP) + BLOCK_SIZE -1:0] cache [32'd1<<(CACHE_SIZE_EXP - (OFFSET_EXP + BLOCK_SIZE_EXP))-1:0][3:0];
    reg [32'd2 + ADDRESS_SIZE - CACHE_SIZE_EXP + (WAYS_EXP + BLOCK_SIZE_EXP) + BLOCK_SIZE -1:0] cache [(32'd1<<(CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)))-1:0][(32'd1<<WAYS_EXP) - 1:0];
    reg [ADDRESS_SIZE+3:0] instruction_set[0:NO_OF_INST-1];
    reg [ADDRESS_SIZE+3:0] instn;
    reg [3:0] rwop;
    reg [ADDRESS_SIZE-1:0] address;
    reg [BLOCK_SIZE-1:0] data;
    reg [ADDRESS_SIZE - (CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)) - OFFSET_EXP - 1:0] tag; //Modified
    reg [CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)-1:0] index; //Modified
    //integer index;
    reg [OFFSET_EXP-1:0] offset;
    reg read_hit; //miss= 0
    reg [(32'd1<<WAYS_EXP)-1:0] valid_bit; //Modified
    reg [(32'd1<<WAYS_EXP)-1:0] valid_bit_out; //Modified
    integer j, i, k, a, b, c;
    // input hit; //Modified
    // reg [3:0] valid_bit;

    reg[31:0] replace;
    integer hit_counter = 32'd0;
    reg[31:0] counter = 32'd0;
    reg[31:0] set0[(32'd1<<WAYS_EXP)-1:0]; //Modified
    // reg[31:0] i = 32'd0;
    reg[31:0] random_ind = 32'd0;
    // reg[31:0] cache_data_offset_start = 32'd0; //Modified
    // reg[31:0] cache_data_offset_end = 32'd0; /Modified

    initial
    begin

      for(i=0; i<32'd1<<(MAIN_MEMORY_SIZE_EXP-2); i=i+1)
        for(j=0; j<32'd4; ++j)
				  memory[i][j] = i+j;


      for (a = 0; a<(32'd1<<WAYS_EXP); a = a + 1) //Modified
      begin
          for (b = 0; b<INDEX_SIZE; b = b+1)
          begin
              // $display("b = %b", b);'
              cache[b][a][CACHE_DATA_SIZE-2] = 0;
              // $display("cache[b][a][CACHE_DATA_SIZE-2] = %b", cache[b][a][CACHE_DATA_SIZE-2]);
          end
      end

      $readmemh("instruction.txt", instruction_set);
      // $display(instruction_set[0]);
      for (i=0; i<NO_OF_INST; i=i+1)
        begin
          instn = instruction_set[i];
          rwop = instn[(ADDRESS_SIZE+3) -: 4]; //read=1, write=2
          address = instn[ADDRESS_SIZE-1:0];
          // data = instn[7:0];
          tag = address[ADDRESS_SIZE-1 -: ADDRESS_SIZE - (CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)) - OFFSET_EXP]; //Modified
          index = address[CACHE_SIZE_EXP - BLOCK_SIZE_EXP :OFFSET_EXP];
          offset = address[OFFSET_EXP-1:0];
          read_hit = 0;
          // valid_bit = 4'b0000;
          // valid_bit = WAYS'd0;
          // $display("address: %b", address);
          // $display("tag: %b", tag);

          for(j=0 ; j<32'd1<<WAYS_EXP ; j=j+1)
          begin
            valid_bit[j] = 0;
          end

          counter = 32'd0;

          // Pseudo LRU
          for ( j=0; j<(32'd1<<WAYS_EXP); j=j+1) //Modified
          begin
            valid_bit[j] = cache[index][j][CACHE_DATA_SIZE-2];
            // $display("CACHE_VALID_BIT : %b", cache[index][j][CACHE_DATA_SIZE-2]);
            // $display("VALID_BIT : %b", valid_bit[j]);
            if (valid_bit[j]==1 && cache[index][j][CACHE_DATA_SIZE-3 -: ADDRESS_SIZE - (CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)) - OFFSET_EXP]==tag) //Modified
              begin
                read_hit=1;
                // hit_counter = hit_counter + 1;
                // $display("\n" + memory[tag]);
              end
          end
          for (k=0; k<(32'd1<<WAYS_EXP); k = k+1) //initialise to 0 //Modified
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

          if (rwop==4'b0001)
            begin
              if(read_hit==0)
                begin
                  // cache[index][replace]= {memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][0], memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][1], memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][2], memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][3]};

                  for(k=0 ; k<(32'd1<<(BLOCK_SIZE_EXP-3)) ; k=k+1)
                  begin
                    cache[index][replace][(BLOCK_SIZE-1-k*8) -: 8] = memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][k];
                  end

                  cache[index][replace][CACHE_DATA_SIZE-2] = 1;
                  cache[index][replace][CACHE_DATA_SIZE-3 -: ADDRESS_SIZE - (CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)) - OFFSET_EXP] = tag; //Modified
                  // $display("cache: %b", cache[index][replace]);
                end
                else
                begin
                  // $display("It was a hit\n");
                  hit_counter = hit_counter + 1;
                end
              // $display(cache[index][j]+ "\n\n");
              // if (cache[index][j][36:32]==tag)
              //   begin
              //     read_hit=1;
              //     // $display("\n" + memory[tag]);
              //   end

            end
          else
            begin
              cache[index][replace][CACHE_DATA_SIZE-2] = 1;
              if(read_hit==0 && cache[index][replace][CACHE_DATA_SIZE-1]==1)
              begin
                // memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][0] = cache[index][replace][BLOCK_SIZE-1 -: DATA_SIZE];
                // memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][1] = cache[index][replace][BLOCK_SIZE-DATA_SIZE-1 -: DATA_SIZE];
                // memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][2] = cache[index][replace][BLOCK_SIZE-(2*DATA_SIZE)-1 -: DATA_SIZE];
                // memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][3] = cache[index][replace][BLOCK_SIZE-1 -(3*DATA_SIZE) -: DATA_SIZE];
                for(k=0 ; k<32'd1<<WAYS_EXP ; k=k+1)
                begin
                  memory[address[ADDRESS_SIZE-1 : OFFSET_EXP]][k] = cache[index][replace][BLOCK_SIZE-(k*DATA_SIZE)-1 -: DATA_SIZE];
                end

                cache[index][replace][CACHE_DATA_SIZE-1] = 0;
              end

              if(read_hit==1)
              begin
                cache[index][replace][CACHE_DATA_SIZE-1] = 1;
                hit_counter = hit_counter + 1;
              end
              else
              begin
                cache[index][replace][CACHE_DATA_SIZE-1] = 1;
                cache[index][replace][CACHE_DATA_SIZE-3 -: ADDRESS_SIZE - (CACHE_SIZE_EXP - (WAYS_EXP + BLOCK_SIZE_EXP)) - OFFSET_EXP] = tag; //Modified
              end

            end
          end
          $display("hit counter: %d", hit_counter);
         $display("hit rate: %d", hit_counter/418.32);
    end
   
endmodule