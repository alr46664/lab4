
// definicoes do PC
parameter PC_INITIAL = 16'd0;   // endereco que comeca a execucao do programa

// definicao dos tamanhos das palavras
parameter MEM_WIDTH        = 16,  // TAMANHO EM BITS MEMORIA
          DATA_WIDTH       = 16,  // TAMANHO EM BITS DOS DADOS
          REG_ADDR_WIDTH   = 5,   // TAMANHO EM BITS DOS ENDERECOS DOS REGISTRADORES
          OPCODE_WIDTH     = 6,   // TAMANHO EM BITS DOS OPCODES DO PROCESSADOR
          INSTR_WIDTH      = OPCODE_WIDTH + 2*REG_ADDR_WIDTH + DATA_WIDTH,  // TAMANHO EM BITS DAS INSTRUCOES DO PROCESSADOR
          CTRL_WIDTH       = 6,   // TAMANHO EM BITS DO CONTROLLER DO PROCESSADOR
          PC_WIDTH         = 16,  // TAMANHO EM BITS DO CONTADOR DE PROGRAMA
          RFLAGS_WIDTH     = 5,   // TAMANHO DO RFLAGS
          CS_HAZARD_WIDTH  = 2,   // TAMANHO DO SELETOR DO MULTIPLEXADOR DE HAZARD
          PILHA_CTRL_WIDTH = 2,   // TAMANHO DO SELETOR DE FUNCAO DA PILHA
		  PILHA_WIDTH      = 8,   // TAMANHO DA PILHA
		  IRQ_WIDTH        = 5;   // TAMANHO DO IRQ EM BITS

// definicao das instrucoes
parameter LW     = 6'b000000, // faz load do valor armazenado no endero de memoria (B + imm)
          LW_IMM = 6'b010000, // faz load do valor absoluto de imm (nao le memoria)
          SW     = 6'b000001,
          ADD    = 6'b000010,
          SUB    = 6'b000011,
          MUL    = 6'b000100,
          DIV    = 6'b000101,
          AND    = 6'b000110,
          OR     = 6'b000111,
          NOT    = 6'b001000,
          CMP    = 6'b001001,
          JR     = 6'b001010,
          JPC    = 6'b001011,
          BRFL   = 6'b001100,
          CALL   = 6'b001101,
          RET    = 6'b001110,
          NOP    = 6'b001111;

// definicao da pilha
parameter PILHA_PUSH  = 2'b00,
          PILHA_POP   = 2'b01,
          PILHA_RESET = 2'b11;
			 
// definicoes das interrupcoes. As mascaradas começam sempre com 1 e por sua vez tem prioridade sobre as outras.		
parameter IRQ_0  = 5'b10000,
		 IRQ_1  = 5'b10001,
		 IRQ_2  = 5'b10010,
		 IRQ_3  = 5'b10011,
		 IRQ_4  = 5'b10100,
		 IRQ_5  = 5'b10101,
		 IRQ_6  = 5'b10110,
		 IRQ_7  = 5'b10111,
		 IRQ_8  = 5'b11000,
		 IRQ_9  = 5'b11001,
		 IRQ_10 = 5'b11010,
		 IRQ_11 = 5'b11011,
		 IRQ_12 = 5'b11100,
		 IRQ_13 = 5'b11101,
		 IRQ_14 = 5'b11110,
		 IRQ_15 = 5'b11111,
		 IRQ_16 = 5'b00000,
		 IRQ_17 = 5'b00001,
		 IRQ_18 = 5'b00010,
		 IRQ_19 = 5'b00011,
		 IRQ_20 = 5'b00100,
		 IRQ_21 = 5'b00101,
		 IRQ_22 = 5'b00110,
		 IRQ_23 = 5'b00111,
		 IRQ_24 = 5'b01000,
		 IRQ_25 = 5'b01001,
		 IRQ_26 = 5'b01010,
		 IRQ_27 = 5'b01011,
		 IRQ_28 = 5'b01100,
		 IRQ_29 = 5'b01101,
		 IRQ_30 = 5'b01110,
		 IRQ_31 = 5'b01111;
			 
