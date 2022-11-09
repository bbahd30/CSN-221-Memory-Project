module LRU(reset, hit, lru_prev_state, index, final_state, replace);
input wire reset;
    input wire hit;
    input wire [3:0] lru_prev_state;
    input index;

    output reg [3:0] final_state;
    output reg[31:0] replace;

    reg[31:0] counter = 32'd0;
    reg[31:0] set0[3:0];
    reg[31:0] i = 32'd0;
    reg[31:0] random_ind = 32'd0;
    always @ (posedge reset)
    begin
        // hit <= 0;
        final_state <= 4'b0000;
    end
    always @(hit, lru_prev_state) begin
        
    if(hit==0)
    begin
        for (i=0; i<=3; i = i+1) //initialise to 0
          begin
            if(lru_prev_state[i]==0)
            begin
                set0[counter] = i;
                counter = counter+1;
            end
          end

        if(counter==1)
        begin
            final_state = ~lru_prev_state;
            replace = set0[0];
        end
        else
        begin
            random_ind = $urandom%counter;
            final_state = lru_prev_state;
            final_state[set0[random_ind]] = 1;
            replace = set0[random_ind];
        end
    end

    end

endmodule