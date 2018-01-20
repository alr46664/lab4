module sdramcontroller(clk, cke, cs_n, ras_n, cas_n, we_n, A, B, dataIn, dataOut);

//Parâmetros internos
parameter ROW_WIDTH = 13;
parameter COL_WIDTH = 10;
parameter SDRADDR_WIDTH = ROW_WIDTH > COL_WIDTH ? ROW_WIDTH : COL_WIDTH;
parameter CLK_FREQUENCY = 75;
parameter REFRESH_TIME =  32; //ms
parameter REFRESH_COUNT = 8192; //ciclos

//Estados
localparam IDLE = 5'b00000;
localparam INIT = 5'b00001;
localparam REFRESH = 5'b00010;
localparam LOAD_MODE = 5'b00011;
localparam PRECHARG = 5'b00100;
localparam ACT = 5'b00101;
localparam ACT_WAIT = 5'b00110;
localparam WRITE = 5'b00111;
localparam READ = 5'b01000;
localparam WRITE_DATA = 5'b01001;
localparam READ_WAIT = 5'b01010;
localparam DATA = 5'b01011;
