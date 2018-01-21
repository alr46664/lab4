
//Parâmetros internos
parameter DATA_WIDTH = 24, // tamanho de dados a serem gravados na memoria
    ROW_WIDTH = 13,
    COL_WIDTH = 10,
    BANK_WIDTH = 2,
//     SDRADDR_WIDTH = ROW_WIDTH > COL_WIDTH ? ROW_WIDTH : COL_WIDTH,
//     CLK_FREQUENCY = 75,
//     REFRESH_TIME =  32, //ms
//     REFRESH_COUNT = 8192; //ciclos

// //Estados
// parameter IDLE = 5'b00000,
//     INIT = 5'b00001,
//     REFRESH = 5'b00010,
//     LOAD_MODE = 5'b00011,
//     PRECHARG = 5'b00100,
//     ACT = 5'b00101,
//     ACT_WAIT = 5'b00110,
//     WRITE = 5'b00111,
//     READ = 5'b01000,
//     WRITE_DATA = 5'b01001,
//     READ_WAIT = 5'b01010,
//     DATA = 5'b01011;