module pipeline3_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 21;

// contador de testes a serem feitos
integer testes;

// declaracao das input e output
reg clk_in, RST;
reg [CTRL_WIDTH-1:0] ctrl_in;
reg [PC_WIDTH-1:0] pc_in;
reg [REG_ADDR_WIDTH-1:0] A_addr, B_addr;
reg signed [DATA_WIDTH-1:0] A, B, imm;

wire [PC_WIDTH-1:0] pc_out;
wire signed [DATA_WIDTH-1:0] data;
wire [MEM_WIDTH-1:0] addr;
wire [REG_ADDR_WIDTH-1:0] reg_addr;
wire [CTRL_WIDTH-1:0] ctrl_out;
wire pc_chg, done;

// instancia do modulo a ser testado
pipeline3 pipeline30(
    .clk_in(clk_in),
    .RST(RST),
    .ctrl_in(ctrl_in),
    .pc_in(pc_in),
    .A_addr(A_addr),
    .B_addr(B_addr),
    .A(A),
    .B(B),
    .imm(imm),
    .pc_chg(pc_chg),
    .pc_out(pc_out),
    .data(data),
    .addr(addr),
    .reg_addr(reg_addr),
    .ctrl_out(ctrl_out),
    .done(done)
);


// inicializando testes em 0
initial begin
    testes = -1;
    // inicilizacao dos inputs
    ctrl_in = 0;
    pc_in   = 0;
    A_addr  = 0;
    B_addr  = 0;
    A       = 0;
    B       = 0;
    imm     = 0;
    // inicialize clk
    clk_in = 0;
    // faca rotina de reset
    RST = 1;
    #1;
    RST = 0;
    #1;
    RST = 1;
end

// gerando clock
always begin
    // gere o clock quando os sinais de teste estiverem estabilizados
    #4;
    clk_in = !clk_in;
end

// gerandos os testes aqui
always @(negedge clk_in) begin
    // gere casos de teste
    testes = testes+1;
    // DESCREVA OS CASOS DE TESTE ABAIXO
    case(testes)
    0: begin
        ctrl_in = LW;
        pc_in   = 45000;
        A_addr  = 5;
        B_addr  = 6;
        A       = 0;
        B       = 8;
        imm     = 42;
    end
    1: begin
        ctrl_in = SW;
        pc_in   = 32000;
        A_addr  = 8;
        B_addr  = 7;
        A       = 5;
        B       = 65;
        imm     = 45;
    end
    2: begin
        ctrl_in = ADD;
        pc_in   = 38000;
        A_addr  = 10;
        B_addr  = 9;
        A       = 50;
        B       = 85;
        imm     = 0;
    end
    3: begin
        ctrl_in = SUB;
        pc_in   = 40000;
        A_addr  = 20;
        B_addr  = 15;
        A       = 150;
        B       = 25;
        imm     = 0;
    end
    4: begin
        ctrl_in = MUL;
        pc_in   = 1700;
        A_addr  = 18;
        B_addr  = 4;
        A       = 5;
        B       = 10;
        imm     = 0;
    end
    5: begin
        ctrl_in = DIV;
        pc_in   = 300;
        A_addr  = 14;
        B_addr  = 16;
        A       = 50;
        B       = -2;
        imm     = 0;
    end
    6: begin
        ctrl_in = AND;
        pc_in   = 1000;
        A_addr  = 7;
        B_addr  = 3;
        A       = 5;
        B       = 7;
        imm     = 0;
    end
    7: begin
        ctrl_in = OR;
        pc_in   = 7500;
        A_addr  = 11;
        B_addr  = 29;
        A       = 6;
        B       = 1;
        imm     = 0;
    end
    8: begin
        ctrl_in = CMP;
        pc_in   = 9000;
        A_addr  = 18;
        B_addr  = 19;
        A       = 80;
        B       = -2;
        imm     = 0;
    end
    9: begin
        ctrl_in = NOT;
        pc_in   = 15000;
        A_addr  = 9;
        B_addr  = 0;
        A       = 70;
        B       = 0;
        imm     = 0;
    end
    10: begin
        ctrl_in = JR;
        pc_in   = 14250;
        A_addr  = 13;
        B_addr  = 0;
        A       = 150;
        B       = 0;
        imm     = 0;
    end
    11: begin
        ctrl_in = JPC;
        pc_in   = 12000;
        A_addr  = 0;
        B_addr  = 0;
        A       = 0;
        B       = 0;
        imm     = 350;
    end
    12: begin
        ctrl_in = CMP;
        pc_in   = 11529;
        A_addr  = 2;
        B_addr  = 3;
        A       = -5;
        B       = 80;
        imm     = 0;
    end
    13: begin
        ctrl_in = BRFL;
        pc_in   = 11530;
        A_addr  = 7;
        B_addr  = 8;
        A       = 5000;
        B       = 1;
        imm     = 1;
    end
    14: begin
        ctrl_in = CMP;
        pc_in   = 12767;
        A_addr  = 15;
        B_addr  = 9;
        A       = -1;
        B       = 1;
        imm     = 0;
    end
    15: begin
        ctrl_in = BRFL;
        pc_in   = 12768;
        A_addr  = 17;
        B_addr  = 18;
        A       = 7000;
        B       = 0;
        imm     = 1;
    end
    16: begin
        ctrl_in = CALL;
        pc_in   = 17541;
        A_addr  = 19;
        B_addr  = 0;
        A       = 48000;
        B       = 0;
        imm     = 0;
    end
    17: begin
        ctrl_in = RET;
        pc_in   = 48000;
        A_addr  = 0;
        B_addr  = 0;
        A       = 0;
        B       = 0;
        imm     = 0;
    end
    18: begin
        ctrl_in = NOP;
        pc_in   = 17542;
        A_addr  = 0;
        B_addr  = 0;
        A       = 0;
        B       = 0;
        imm     = 0;
    end
    19: begin
        ctrl_in = LW_IMM;
        pc_in   = 45000;
        A_addr  = 8;
        B_addr  = 0;
        A       = 95;
        B       = 0;
        imm     = 42;
    end
    20: begin
        ctrl_in = EOF;
        pc_in   = 17542;
        A_addr  = 0;
        B_addr  = 0;
        A       = 0;
        B       = 0;
        imm     = 0;
    end
    21: begin
        ctrl_in = ADD;
        pc_in   = 17543;
        A_addr  = 0;
        B_addr  = 1;
        A       = 0;
        B       = 1;
        imm     = 1;
    end
    default: begin
        // nao faca nada de proposito
    end
    endcase
end

// mostre os resultados dos testes
always @(posedge clk_in) begin
    // aqui aparecem os resultados dos testes
    if (testes >= 0 && testes  < N_TESTES) begin
        // ENTRADAS (estaveis)
        $display("  Teste # %2d  =>  ", testes);
        $display("\t ------ ENTRADAS -------  ");
        $display("\t PC_IN: %6d  ", pc_in);
        $display("\t A  -  ADDR: %3d  -  DATA: %6d  ", A_addr, A);
        $display("\t B  -  ADDR: %3d  -  DATA: %6d  ", B_addr, B);
        $display("\t IMM: %6d  ", imm);
        $write(  "\t CTRL: %b (", ctrl_in);
        case(ctrl_in)
        LW:       $display("LW)");
        LW_IMM:   $display("LW_IMM)");
        SW:       $display("SW)");
        ADD:      $display("ADD)");
        SUB:      $display("SUB)");
        MUL:      $display("MUL)");
        DIV:      $display("DIV)");
        AND:      $display("AND)");
        OR:       $display("OR)");
        NOT:      $display("NOT)");
        CMP:      $display("CMP)");
        JR:       $display("JR)");
        JPC:      $display("JPC)");
        BRFL:     $display("BRFL)");
        CALL:     $display("CALL)");
        RET:      $display("RET)");
        NOP:      $display("NOP)");
        EOF:      $display("EOF)");
        endcase
    end
end

always @(negedge clk_in) begin
    if (testes >= 0 && testes  < N_TESTES) begin
        // ENTRADAS (estaveis)
        $display("\t ------ SAIDAS -------  ");
        $display("\t DONE: %b", done);
        $display("\t PC_CHG: %b", pc_chg);
        $display("\t PC_OUT: %6d  ", pc_out);
        $display("\t DATA: %6d  ", data);
        $display("\t ADDR: %6d  ", addr);
        $display("\t REG_ADDR: %3d  ", reg_addr);
        $write(  "\t CTRL_OUT: %b (", ctrl_out);
        case(ctrl_out)
        LW:      $display("LW)");
        LW_IMM:  $display("LW_IMM)");
        SW:      $display("SW)");
        ADD:     $display("ADD)");
        SUB:     $display("SUB)");
        MUL:     $display("MUL)");
        DIV:     $display("DIV)");
        AND:     $display("AND)");
        OR:      $display("OR)");
        NOT:     $display("NOT)");
        CMP:     $display("CMP)");
        JR:      $display("JR)");
        JPC:     $display("JPC)");
        BRFL:    $display("BRFL)");
        CALL:    $display("CALL)");
        RET:     $display("RET)");
        NOP:     $display("NOP)");
        EOF:     $display("EOF)");
        endcase
    end
end


endmodule