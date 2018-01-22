
// este modulo ira operar a 75 MHz
module sdram_mem_ctrl(
    clk,
    RST,
    row,    // linha do endereco inicial do pixel
    col,    // coluna do endereco inicial do pixel
    CS,     // ativa ou desativa a leitura da sdram - 1 desativa / 0 ativa memoria
    op,     // indica a operacao                    - 1 para gravacao / 0 para leitura
    data    // dados para gravacao/leitura na memoria    
);

// faz o include dos parameters das instrucoes
`include "params_sdram.v"

// declaracao de entrada

input clk, RST, CS, op;
input [ROW_WIDTH-1:0] row;
input [COL_WIDTH-1:0] col;

// declaracao de saida

inout reg [DATA_WIDTH-1:0] data;

// variaveis auxiliares
wire DQMH, DQML;
wire cke, RAS, CAS, WE;
wire [ROW_WIDTH-1:0] addr;
wire [BANK_WIDTH-1:0] bank;

// instancia de Memoria SDRAM 
// TODO: devemos pesquisar como instanciar ela no Quartus
// sdram sdram0(.clk(clk), .cke(cke), .CS(CS), .RAS(RAS), .CAS(CAS), .WE(WE), .DQMH(DQMH), .DQML(DQML), .addr(addr), .ba(bank), .DQ(data));

// esses sinais devem estar em LOW o tempo todo (ativando data como entrada/saida)
assign DQMH = 1b'0;
assign DQML = 1b'0;

// esses sinal deve permanescer HIGH para o clk funcionar
assign cke = 1b'1;


// inicializacao da memoria:
    // 1) DQMH = DQML = cke = HIGH 
    // 2) 100 us de espera (os comandos NOP ou INHIBIT devem ser aplicados na memoria durante esse periodo - CS = HIGH significa NOP)
    // 3) Execute o comando PRECHARGE em todos os banks (apos esse comando a memoria estara no estado IDLE)
    // 4) Excute o AUTOREFRESH (por 2 ciclos / 2 vezes - apos isso a memoria estara no estado MODE REGISTER)
    // 5) Devemos setar o MODE REGISTER da memoria antes de usarmos qualquer outro comando (vide pagina 26 para detalhes)
    //      M0-M2  especificam o burst length (iremos usar o burst length = 4. Logo M[2:0] = 3b'010 - NESSE CASO IREMOS USAR A2-A9 PARA SELECIONAR O BLOCO DE DADOS QUE SERA LIDO EM BURST)
    //      M3     especificam o tipo de burst (sequencial ou interleaved - iremos usar o sequencial logo M[3] = 1b'0)
    //      M4-M6  especificam a latencia CAS (no nosso caso a latencia é 2 - logo M[6:4] = 3'b010)
    //      M7-M8  especificam o modo de operacao (iremos usar o modo padrao M[8:7] = 2b'00)
    //      M9     especificam o write burst mode (nao sei qual iremos usar, vide pagina 26 para detalhes)
    //      M10-M12  nao sao usados (reservados para uso futuro)
    // 6) A memoria estara agora no estado ACTIVE

// addr[10] == 1 significa AUTOPRECHARGE

// estado PRECHARGE = precisa ocorrer antes de qualquer operacao, 
//                    seleciona os bancos de memoria que sofreram a acao (leitura gravacao)
//                    que ocorrera em seguida
//                    PARA O PRECHARGE OCORRER PRECISAMOS SETAR:
//                       A[10] = 0 / 1 (1 SIGNIFICA SELECIONE TODOS OS BANKS DA MEMORIA)
//                       BA[1:0] = 00-11 (CASO A[10] == 0, ESSES BITS SELECIONAM O BANK SELECIONADO, DO CONTRARIO ELES SAO DONT CARE - vide pagina 49)

// estado IDLE = comandos possiveis:
//      row active
//      refresh
//      mode

// estado ROW_ACTIVE = comandos possiveis:
//      read
//      write
//      precharge

// estado ROW_ACTIVE = comandos possiveis:
//      comandos relacionados a burst
//      write
//      transicao para estados: READ, WRITE, PRECHARGE, ROW_ACTIVE, 
      
//DECODIFICADOR DE PROXIMO ESTADO
//DECODIFICADOR DE MEMORIA
//DECODIFICADOR DE SAIDA

endmodule