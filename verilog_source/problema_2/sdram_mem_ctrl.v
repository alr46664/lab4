
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

//      ESPECIFICACOES DO PROBLEMA 2

// Esta memoria comporta uma imagem de 1920 x 1440 x 24 bits true color em um unico bank de 8K x 1K x 16 bits (linha x coluna) ocupando 
// ao todo 66% do banco (1920 x 1440 x 2 enderecos do banco / (2^13 x 2^10)) supondo que armazenemos um pixel de 24 bits em duas celulas de memoria,
// estando 16 bits em uma celula e os outros 8 bits na subsequente.
// Logo precisamos garantir que conseguimos ler a memoria e realizar precharge / refresh rapido o suficiente para podermos usar um unico banco
// da memoria, simplificando o controle em nosso verilog.
// Para o VGA funcionar, precisamos fornecer para o monitor ~18433 pixels / ms (640 x 480 pixels x 60 Hz / 1000 ms). 
// Dessa forma, podemos tentar fazer um burst da pagina inteira do bank da memoria, selecionando 640 x 480 pixels para um buffer. 
// Lembrando que podemos interromper o burst a qualquer momento. Logo, podemos selecionar a linha e coluna da memoria, solicitar o burst da pagina
// inteira, deixar o burst operando ate que tenhamos recebido os 640x480 pixels em nosso buffer. Feito isso, podemos realizar um refresh global da
// memoria, garantindo assim a integridade dos dados armazenados nela.
//
// Para que isso tudo funcione, precisaremos de um buffer de 600 KB (640 x 480 pixels x 16 bits / (8 bits por byte * 1024 kilobytes)). Isso é 
// perfeitamente possivel usando os recursos da placa Altera Cyclone IV !
// Assim sendo, precisamos APENAS garantir que os dados da memoria estarao acessiveis e nao serao corrompidos ao longo do tempo (ou seja,
// precisamos realizar o precharge e refresh de acordo com os requisitos de temporizacao memoria, mantendo um fluxo de pixels para o VGA constante).
// 
//        TEMPORIZACOES
// REFRESH (banco inteiro - 8192 linhas) = 64 ms

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