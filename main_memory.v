module Main_memoryGlb()
    reg [31:0] main_memory[26:0];
    reg []
    integer i;

    initial
        begin
          for (i=0; i<=262143; i = i+1) //initialise to 0
          begin
          main_memory[i] = 0;
    end

endmodule