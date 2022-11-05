module Decode(instn)
    input [50:0] instn;
    assign opcode = instn[50];
    assign address = instn[49:32];
    assign data = instn[31:0]

    assign offset = address[5:0];
    assign index = address[12:6];
    assign tag = address[17:13];
endmodule