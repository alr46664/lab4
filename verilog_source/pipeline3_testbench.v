module pipeline3_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 22;

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
wire pc_chg;
wire we;

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
    .mem_we(we),
    .data(data),
    .addr(addr),
    .reg_addr(reg_addr),
    .ctrl_out(ctrl_out)
);

// inicializa os inputs do modulo (acima) a ser testado
task init_input;
begin
    ctrl_in = 0;
    pc_in   = 0;
    A_addr  = 0;
    B_addr  = 0;
    A       = 0;
    B       = 0;
    imm     = 0;
end
endtask

// executa o teste numero 'testes' emitindo status como resultado do teste
task execute_test;
    input integer testes;
    output reg status;

    // dados dos testes
    parameter TESTE1_CTRL = LW,
        TESTE1_PC_IN = 45000,
        TESTE1_A_ADDR = 5,
        TESTE1_B_ADDR = 6,
        TESTE1_A = 0,
        TESTE1_B = 8,
        TESTE1_IMM = 42;

    parameter TESTE2_CTRL = SW,
        TESTE2_PC_IN = 32000,
        TESTE2_A_ADDR = 8,
        TESTE2_B_ADDR = 7,
        TESTE2_A = 5,
        TESTE2_B = 65,
        TESTE2_IMM = 45;

    parameter TESTE3_CTRL = ADD,
        TESTE3_PC_IN = 38000,
        TESTE3_A_ADDR = 10,
        TESTE3_B_ADDR = 9,
        TESTE3_A = 50,
        TESTE3_B = 85,
        TESTE3_IMM = 0;

    parameter TESTE4_CTRL = SUB,
        TESTE4_PC_IN = 40000,
        TESTE4_A_ADDR = 20,
        TESTE4_B_ADDR = 15,
        TESTE4_A = 150,
        TESTE4_B = 25,
        TESTE4_IMM = 0;

    parameter TESTE5_CTRL = MUL,
        TESTE5_PC_IN = 1700,
        TESTE5_A_ADDR = 18,
        TESTE5_B_ADDR = 4,
        TESTE5_A = 5,
        TESTE5_B = 10,
        TESTE5_IMM = 0;

    parameter TESTE6_CTRL = DIV,
        TESTE6_PC_IN = 300,
        TESTE6_A_ADDR = 14,
        TESTE6_B_ADDR = 16,
        TESTE6_A = 50,
        TESTE6_B = -2,
        TESTE6_IMM = 0;

    parameter TESTE7_CTRL = AND,
        TESTE7_PC_IN = 1000,
        TESTE7_A_ADDR = 7,
        TESTE7_B_ADDR = 3,
        TESTE7_A = 5,
        TESTE7_B = 7,
        TESTE7_IMM = 0;

    parameter TESTE8_CTRL = OR,
        TESTE8_PC_IN = 7500,
        TESTE8_A_ADDR = 11,
        TESTE8_B_ADDR = 29,
        TESTE8_A = 6,
        TESTE8_B = 1,
        TESTE8_IMM = 0;

    parameter TESTE9_CTRL = CMP,
        TESTE9_PC_IN = 9000,
        TESTE9_A_ADDR = 18,
        TESTE9_B_ADDR = 19,
        TESTE9_A = 80,
        TESTE9_B = -2,
        TESTE9_IMM = 0;

    parameter TESTE10_CTRL = NOT,
        TESTE10_PC_IN = 15000,
        TESTE10_A_ADDR = 9,
        TESTE10_B_ADDR = 0,
        TESTE10_A = 70,
        TESTE10_B = 0,
        TESTE10_IMM = 0;

    parameter TESTE11_CTRL = JR,
        TESTE11_PC_IN = 14250,
        TESTE11_A_ADDR = 13,
        TESTE11_B_ADDR = 0,
        TESTE11_A = 150,
        TESTE11_B = 0,
        TESTE11_IMM = 0;

    parameter TESTE12_CTRL = JPC,
        TESTE12_PC_IN = 12000,
        TESTE12_A_ADDR = 0,
        TESTE12_B_ADDR = 0,
        TESTE12_A = 0,
        TESTE12_B = 0,
        TESTE12_IMM = 350;

    parameter TESTE13_CTRL = CMP,
        TESTE13_PC_IN = 11529,
        TESTE13_A_ADDR = 2,
        TESTE13_B_ADDR = 3,
        TESTE13_A = -5,
        TESTE13_B = 80,
        TESTE13_IMM = 0;

    parameter TESTE14_CTRL = BRFL,
        TESTE14_PC_IN = 11530,
        TESTE14_A_ADDR = 7,
        TESTE14_B_ADDR = 8,
        TESTE14_A = 5000,
        TESTE14_B = 1,
        TESTE14_IMM = 1;

    parameter TESTE15_CTRL = CMP,
        TESTE15_PC_IN = 12767,
        TESTE15_A_ADDR = 15,
        TESTE15_B_ADDR = 9,
        TESTE15_A = -1,
        TESTE15_B = 1,
        TESTE15_IMM = 0;

    parameter TESTE16_CTRL = BRFL,
        TESTE16_PC_IN = 12768,
        TESTE16_A_ADDR = 17,
        TESTE16_B_ADDR = 18,
        TESTE16_A = 7000,
        TESTE16_B = 0,
        TESTE16_IMM = 1;

    parameter TESTE17_CTRL = CALL,
        TESTE17_PC_IN = 17541,
        TESTE17_A_ADDR = 19,
        TESTE17_B_ADDR = 0,
        TESTE17_A = 48000,
        TESTE17_B = 0,
        TESTE17_IMM = 0;

    parameter TESTE18_CTRL = RET,
        TESTE18_PC_IN = 48000,
        TESTE18_A_ADDR = 0,
        TESTE18_B_ADDR = 0,
        TESTE18_A = 0,
        TESTE18_B = 0,
        TESTE18_IMM = 0;

    parameter TESTE19_CTRL = NOP,
        TESTE19_PC_IN = 17542,
        TESTE19_A_ADDR = 0,
        TESTE19_B_ADDR = 0,
        TESTE19_A = 0,
        TESTE19_B = 0,
        TESTE19_IMM = 0;

    parameter TESTE20_CTRL = LW_IMM,
        TESTE20_PC_IN = 45000,
        TESTE20_A_ADDR = 8,
        TESTE20_B_ADDR = 0,
        TESTE20_A = 95,
        TESTE20_B = 0,
        TESTE20_IMM = 42;

    parameter TESTE21_CTRL = ADD,
        TESTE21_PC_IN = 17543,
        TESTE21_A_ADDR = 0,
        TESTE21_B_ADDR = 1,
        TESTE21_A = 0,
        TESTE21_B = 1,
        TESTE21_IMM = 1;

begin
    // status <= 1;
    case(testes)
    0: begin
        ctrl_in <= TESTE1_CTRL;
        pc_in   <= TESTE1_PC_IN;
        A_addr  <= TESTE1_A_ADDR;
        B_addr  <= TESTE1_B_ADDR;
        A       <= TESTE1_A;
        B       <= TESTE1_B;
        imm     <= TESTE1_IMM;
        if (pc_out == PC_INITIAL+1 && ctrl_out == NOP) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    1: begin
        ctrl_in <= TESTE2_CTRL;
        pc_in   <= TESTE2_PC_IN;
        A_addr  <= TESTE2_A_ADDR;
        B_addr  <= TESTE2_B_ADDR;
        A       <= TESTE2_A;
        B       <= TESTE2_B;
        imm     <= TESTE2_IMM;
        if (pc_out == TESTE1_PC_IN && ctrl_out == TESTE1_CTRL &&
          we == 0 && pc_chg == 0 && data == 0 &&
          addr == TESTE1_B + TESTE1_IMM && reg_addr == TESTE1_A_ADDR ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    2: begin
        ctrl_in <= TESTE3_CTRL;
        pc_in   <= TESTE3_PC_IN;
        A_addr  <= TESTE3_A_ADDR;
        B_addr  <= TESTE3_B_ADDR;
        A       <= TESTE3_A;
        B       <= TESTE3_B;
        imm     <= TESTE3_IMM;
        if (pc_out == TESTE2_PC_IN && ctrl_out == TESTE2_CTRL &&
          we == 1 && pc_chg == 0 && data == TESTE2_A &&
          addr == TESTE2_B + TESTE2_IMM && reg_addr == TESTE2_A_ADDR ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    3: begin
        ctrl_in <= TESTE4_CTRL;
        pc_in   <= TESTE4_PC_IN;
        A_addr  <= TESTE4_A_ADDR;
        B_addr  <= TESTE4_B_ADDR;
        A       <= TESTE4_A;
        B       <= TESTE4_B;
        imm     <= TESTE4_IMM;
        if (pc_out == TESTE3_PC_IN && ctrl_out == TESTE3_CTRL &&
          we == 0 && pc_chg == 0 && 
          data == TESTE3_A + (TESTE3_B + TESTE3_IMM) &&
          addr == 0 && reg_addr == TESTE3_A_ADDR ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    4: begin
        ctrl_in <= TESTE5_CTRL;
        pc_in   <= TESTE5_PC_IN;
        A_addr  <= TESTE5_A_ADDR;
        B_addr  <= TESTE5_B_ADDR;
        A       <= TESTE5_A;
        B       <= TESTE5_B;
        imm     <= TESTE5_IMM;
        if (
          pc_out == TESTE4_PC_IN                       &&
          ctrl_out == TESTE4_CTRL                      &&
          we == 0 && pc_chg == 0                       && 
          data == TESTE4_A - (TESTE4_B + TESTE4_IMM)   &&
          addr == 0                                    && 
          reg_addr == TESTE4_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    5: begin
        ctrl_in <= TESTE6_CTRL;
        pc_in   <= TESTE6_PC_IN;
        A_addr  <= TESTE6_A_ADDR;
        B_addr  <= TESTE6_B_ADDR;
        A       <= TESTE6_A;
        B       <= TESTE6_B;
        imm     <= TESTE6_IMM;
        if (
          pc_out == TESTE5_PC_IN                       &&
          ctrl_out == TESTE5_CTRL                      &&
          we == 0 && pc_chg == 0                       && 
          data == TESTE5_A * (TESTE5_B + TESTE5_IMM)   &&
          addr == 0                                    && 
          reg_addr == TESTE5_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    6: begin
        ctrl_in <= TESTE7_CTRL;
        pc_in   <= TESTE7_PC_IN;
        A_addr  <= TESTE7_A_ADDR;
        B_addr  <= TESTE7_B_ADDR;
        A       <= TESTE7_A;
        B       <= TESTE7_B;
        imm     <= TESTE7_IMM;
        if (
          pc_out == TESTE6_PC_IN                       &&
          ctrl_out == TESTE6_CTRL                      &&
          we == 0 && pc_chg == 0                       && 
          data == TESTE6_A / (TESTE6_B + TESTE6_IMM)   &&
          addr == 0                                    && 
          reg_addr == TESTE6_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    7: begin
        ctrl_in <= TESTE8_CTRL;
        pc_in   <= TESTE8_PC_IN;
        A_addr  <= TESTE8_A_ADDR;
        B_addr  <= TESTE8_B_ADDR;
        A       <= TESTE8_A;
        B       <= TESTE8_B;
        imm     <= TESTE8_IMM;
        if (
          pc_out == TESTE7_PC_IN                       &&
          ctrl_out == TESTE7_CTRL                      &&
          we == 0 && pc_chg == 0                       && 
          data == TESTE7_A & (TESTE7_B + TESTE7_IMM)   &&
          addr == 0                                    && 
          reg_addr == TESTE7_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    8: begin
        ctrl_in <= TESTE9_CTRL;
        pc_in   <= TESTE9_PC_IN;
        A_addr  <= TESTE9_A_ADDR;
        B_addr  <= TESTE9_B_ADDR;
        A       <= TESTE9_A;
        B       <= TESTE9_B;
        imm     <= TESTE9_IMM;
        if (
          pc_out == TESTE8_PC_IN                       &&
          ctrl_out == TESTE8_CTRL                      &&
          we == 0 && pc_chg == 0                       && 
          data == TESTE8_A | (TESTE8_B + TESTE8_IMM)   &&
          addr == 0                                    && 
          reg_addr == TESTE8_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    9: begin
        ctrl_in <= TESTE10_CTRL;
        pc_in   <= TESTE10_PC_IN;
        A_addr  <= TESTE10_A_ADDR;
        B_addr  <= TESTE10_B_ADDR;
        A       <= TESTE10_A;
        B       <= TESTE10_B;
        imm     <= TESTE10_IMM;
        if (
          pc_out == TESTE9_PC_IN                       &&
          ctrl_out == TESTE9_CTRL                      &&
          we == 0 && pc_chg == 0                       && 
          data == TESTE9_A - (TESTE9_B + TESTE9_IMM)   &&
          addr == 0                                    && 
          reg_addr == TESTE9_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    10: begin
        ctrl_in <= TESTE11_CTRL;
        pc_in   <= TESTE11_PC_IN;
        A_addr  <= TESTE11_A_ADDR;
        B_addr  <= TESTE11_B_ADDR;
        A       <= TESTE11_A;
        B       <= TESTE11_B;
        imm     <= TESTE11_IMM;
        if (
          pc_out == TESTE10_PC_IN                      &&
          ctrl_out == TESTE10_CTRL                     &&
          we == 0 && pc_chg == 0                       && 
          data == 0                                    &&
          addr == 0                                    && 
          reg_addr == TESTE10_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    11: begin
        ctrl_in <= TESTE12_CTRL;
        pc_in   <= TESTE12_PC_IN;
        A_addr  <= TESTE12_A_ADDR;
        B_addr  <= TESTE12_B_ADDR;
        A       <= TESTE12_A;
        B       <= TESTE12_B;
        imm     <= TESTE12_IMM;
        if (
          pc_out == TESTE11_A                          &&
          ctrl_out == TESTE11_CTRL                     &&
          we == 0 && pc_chg == 1                       && 
          data == 0                                    &&
          addr == 0                                    && 
          reg_addr == TESTE11_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    12: begin
        ctrl_in <= TESTE13_CTRL;
        pc_in   <= TESTE13_PC_IN;
        A_addr  <= TESTE13_A_ADDR;
        B_addr  <= TESTE13_B_ADDR;
        A       <= TESTE13_A;
        B       <= TESTE13_B;
        imm     <= TESTE13_IMM;
        if (
          pc_out == TESTE12_PC_IN + TESTE12_B + TESTE12_IMM  &&
          ctrl_out == TESTE12_CTRL                           &&
          we == 0 && pc_chg == 1                             && 
          data == 0                                          &&
          addr == 0                                          && 
          reg_addr == TESTE12_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    13: begin
        ctrl_in <= TESTE14_CTRL;
        pc_in   <= TESTE14_PC_IN;
        A_addr  <= TESTE14_A_ADDR;
        B_addr  <= TESTE14_B_ADDR;
        A       <= TESTE14_A;
        B       <= TESTE14_B;
        imm     <= TESTE14_IMM;
        if (
          pc_out == TESTE13_PC_IN                            &&
          ctrl_out == TESTE13_CTRL                           &&
          we == 0 && pc_chg == 0                             && 
          data == TESTE13_A - (TESTE13_B + TESTE13_IMM)      &&
          addr == 0                                          && 
          reg_addr == TESTE13_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    14: begin
        ctrl_in <= TESTE15_CTRL;
        pc_in   <= TESTE15_PC_IN;
        A_addr  <= TESTE15_A_ADDR;
        B_addr  <= TESTE15_B_ADDR;
        A       <= TESTE15_A;
        B       <= TESTE15_B;
        imm     <= TESTE15_IMM;
        if (
          pc_out == TESTE14_A                                &&
          ctrl_out == TESTE14_CTRL                           &&
          we == 0 && pc_chg == 1                             && 
          data == 0                                          &&
          addr == 0                                          && 
          reg_addr == TESTE14_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    15: begin
        ctrl_in <= TESTE16_CTRL;
        pc_in   <= TESTE16_PC_IN;
        A_addr  <= TESTE16_A_ADDR;
        B_addr  <= TESTE16_B_ADDR;
        A       <= TESTE16_A;
        B       <= TESTE16_B;
        imm     <= TESTE16_IMM;
        if (
          pc_out == TESTE15_PC_IN                            &&
          ctrl_out == TESTE15_CTRL                           &&
          we == 0 && pc_chg == 0                             && 
          data == TESTE15_A - (TESTE15_B + TESTE15_IMM)      &&
          addr == 0                                          && 
          reg_addr == TESTE15_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    16: begin
        ctrl_in <= TESTE17_CTRL;
        pc_in   <= TESTE17_PC_IN;
        A_addr  <= TESTE17_A_ADDR;
        B_addr  <= TESTE17_B_ADDR;
        A       <= TESTE17_A;
        B       <= TESTE17_B;
        imm     <= TESTE17_IMM;
        if (
          pc_out == TESTE16_PC_IN                            &&
          ctrl_out == TESTE16_CTRL                           &&
          we == 0 && pc_chg == 0                             && 
          data == 0                                          &&
          addr == 0                                          && 
          reg_addr == TESTE16_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    17: begin
        ctrl_in <= TESTE18_CTRL;
        pc_in   <= TESTE18_PC_IN;
        A_addr  <= TESTE18_A_ADDR;
        B_addr  <= TESTE18_B_ADDR;
        A       <= TESTE18_A;
        B       <= TESTE18_B;
        imm     <= TESTE18_IMM;
        if (
          pc_out == TESTE17_A                            &&
          ctrl_out == TESTE17_CTRL                           &&
          we == 0 && pc_chg == 1                             && 
          data == TESTE17_PC_IN                           &&
          addr == 0                                          && 
          reg_addr == REG_FUNC_RET                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    18: begin
        ctrl_in <= TESTE19_CTRL;
        pc_in   <= TESTE19_PC_IN;
        A_addr  <= TESTE19_A_ADDR;
        B_addr  <= TESTE19_B_ADDR;
        A       <= TESTE19_A;
        B       <= TESTE19_B;
        imm     <= TESTE19_IMM;
        if (
          pc_out == TESTE18_A                            &&
          ctrl_out == TESTE18_CTRL                           &&
          we == 0 && pc_chg == 1                             && 
          data == 0                                      &&
          addr == 0                                          && 
          reg_addr == TESTE18_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    19: begin
        ctrl_in <= TESTE20_CTRL;
        pc_in   <= TESTE20_PC_IN;
        A_addr  <= TESTE20_A_ADDR;
        B_addr  <= TESTE20_B_ADDR;
        A       <= TESTE20_A;
        B       <= TESTE20_B;
        imm     <= TESTE20_IMM;
        if (
          pc_out == TESTE19_PC_IN                            &&
          ctrl_out == TESTE19_CTRL                           &&
          we == 0 && pc_chg == 0                             && 
          data == 0                                      &&
          addr == 0                                          && 
          reg_addr == TESTE19_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    20: begin
        ctrl_in <= TESTE21_CTRL;
        pc_in   <= TESTE21_PC_IN;
        A_addr  <= TESTE21_A_ADDR;
        B_addr  <= TESTE21_B_ADDR;
        A       <= TESTE21_A;
        B       <= TESTE21_B;
        imm     <= TESTE21_IMM;
        if (
          pc_out == TESTE20_PC_IN                            &&
          ctrl_out == TESTE20_CTRL                           &&
          we == 0 && pc_chg == 0                             && 
          data == TESTE20_IMM                                      &&
          addr == 0                                          && 
          reg_addr == TESTE20_A_ADDR                ) begin
            status <= 0;
        end else begin
            status <= 1;
        end
    end
    default: begin
        status <= 0;        
    end
    endcase 
end
endtask

// mostra as entradas no console
task display_input;
    input integer testes;
    input reg status;
begin
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
    endcase
end
endtask

// mostra as saidas no console
task display_output;
    input integer testes;
    input reg status;
begin    
    $display("\t ------ SAIDAS -------  ");
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
    
    endcase
end
endtask

// faz o include do modelo de testbench
// ESTE INCLUDE DEVE VIR POR ULTIMO !!!
`include "testbench.v"

endmodule