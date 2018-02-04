module pipeline5_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 18;

// declaracao das input e output
reg clk_in, RST;
reg [CTRL_WIDTH-1:0] ctrl_in;
reg signed [DATA_WIDTH-1:0] data;
reg [REG_ADDR_WIDTH-1:0] addr;

wire signed [DATA_WIDTH-1:0] data_out;
wire [REG_ADDR_WIDTH-1:0] addr_out;
wire en_out;

// instancia do modulo a ser testado
pipeline5 pipeline50(
    .clk_in(clk_in),
    .RST(RST),
    .ctrl_in(ctrl_in),
    .data(data),
    .addr(addr),
    .data_out(data_out),
    .addr_out(addr_out),
    .en_out(en_out)
);

// inicializa os inputs do modulo (acima) a ser testado (sem clk e RST)
task init_input;
begin    
    ctrl_in = NOP;
    data = 0;
    addr = 0;    
end
endtask

// executa o teste numero 'testes' emitindo status como resultado do teste
task execute_test;
    input integer testes;
    output reg status;

    parameter TESTE1_CTRL = LW,
        TESTE1_DATA = 15,
        TESTE1_ADDR = 1,
        TESTE1_EN = 1;

    parameter TESTE2_CTRL = LW_IMM,
        TESTE2_DATA = 27,
        TESTE2_ADDR = 2,
        TESTE2_EN = 1;

    parameter TESTE3_CTRL = SW,
        TESTE3_DATA = 3562,
        TESTE3_ADDR = 3,
        TESTE3_EN = 0;

    parameter TESTE4_CTRL = ADD,
        TESTE4_DATA = 1712,
        TESTE4_ADDR = 4,
        TESTE4_EN = 1;

    parameter TESTE5_CTRL = SUB,
        TESTE5_DATA = 645,
        TESTE5_ADDR = 5,
        TESTE5_EN = 1;

    parameter TESTE6_CTRL = MUL,
        TESTE6_DATA = 12,
        TESTE6_ADDR = 6,
        TESTE6_EN = 1;

    parameter TESTE7_CTRL = DIV,
        TESTE7_DATA = 956,
        TESTE7_ADDR = 7,
        TESTE7_EN = 1;

    parameter TESTE8_CTRL = AND,
        TESTE8_DATA = 4754,
        TESTE8_ADDR = 8,
        TESTE8_EN = 1;

    parameter TESTE9_CTRL = OR,
        TESTE9_DATA = 666,
        TESTE9_ADDR = 9,
        TESTE9_EN = 1;

    parameter TESTE10_CTRL = NOT,
        TESTE10_DATA = 75,
        TESTE10_ADDR = 10,
        TESTE10_EN = 1;

    parameter TESTE11_CTRL = CMP,
        TESTE11_DATA = 145,
        TESTE11_ADDR = 11,
        TESTE11_EN = 0;

    parameter TESTE12_CTRL = JR,
        TESTE12_DATA = 321,
        TESTE12_ADDR = 12,
        TESTE12_EN = 0;

    parameter TESTE13_CTRL = JPC,
        TESTE13_DATA = 451,
        TESTE13_ADDR = 13,
        TESTE13_EN = 0;

    parameter TESTE14_CTRL = BRFL,
        TESTE14_DATA = 555,
        TESTE14_ADDR = 14,
        TESTE14_EN = 0;

    parameter TESTE15_CTRL = CALL,
        TESTE15_DATA = 777,
        TESTE15_ADDR = 15,
        TESTE15_EN = 0;

    parameter TESTE16_CTRL = RET,
        TESTE16_DATA = 999,
        TESTE16_ADDR = 16,
        TESTE16_EN = 0;

    parameter TESTE17_CTRL = NOP,
        TESTE17_DATA = 6300,
        TESTE17_ADDR = 17,
        TESTE17_EN = 0;        

begin
    case(testes)
    0: begin
        ctrl_in = TESTE1_CTRL;
        data = TESTE1_DATA;
        addr = TESTE1_ADDR;  
        status <= 0;        
    end
    1: begin        
        ctrl_in = TESTE2_CTRL;
        data = TESTE2_DATA;
        addr = TESTE2_ADDR;  
        if (data_out == TESTE1_DATA && en_out == TESTE1_EN && addr_out == TESTE1_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end
    2: begin        
        ctrl_in = TESTE3_CTRL;
        data = TESTE3_DATA;
        addr = TESTE3_ADDR;  
        if (data_out == TESTE2_DATA && en_out == TESTE2_EN && addr_out == TESTE2_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end   
    3: begin        
        ctrl_in = TESTE4_CTRL;
        data = TESTE4_DATA;
        addr = TESTE4_ADDR;  
        if (data_out == TESTE3_DATA && en_out == TESTE3_EN && addr_out == TESTE3_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end   
    4: begin        
        ctrl_in = TESTE5_CTRL;
        data = TESTE5_DATA;
        addr = TESTE5_ADDR;  
        if (data_out == TESTE4_DATA && en_out == TESTE4_EN && addr_out == TESTE4_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    5: begin        
        ctrl_in = TESTE6_CTRL;
        data = TESTE6_DATA;
        addr = TESTE6_ADDR;  
        if (data_out == TESTE5_DATA && en_out == TESTE5_EN && addr_out == TESTE5_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    6: begin        
        ctrl_in = TESTE7_CTRL;
        data = TESTE7_DATA;
        addr = TESTE7_ADDR;  
        if (data_out == TESTE6_DATA && en_out == TESTE6_EN && addr_out == TESTE6_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    7: begin        
        ctrl_in = TESTE8_CTRL;
        data = TESTE8_DATA;
        addr = TESTE8_ADDR;  
        if (data_out == TESTE7_DATA && en_out == TESTE7_EN && addr_out == TESTE7_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    8: begin        
        ctrl_in = TESTE9_CTRL;
        data = TESTE9_DATA;
        addr = TESTE9_ADDR;  
        if (data_out == TESTE8_DATA && en_out == TESTE8_EN && addr_out == TESTE8_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    9: begin        
        ctrl_in = TESTE10_CTRL;
        data = TESTE10_DATA;
        addr = TESTE10_ADDR;  
        if (data_out == TESTE9_DATA && en_out == TESTE9_EN && addr_out == TESTE9_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    10: begin        
        ctrl_in = TESTE11_CTRL;
        data = TESTE11_DATA;
        addr = TESTE11_ADDR;  
        if (data_out == TESTE10_DATA && en_out == TESTE10_EN && addr_out == TESTE10_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    11: begin        
        ctrl_in = TESTE12_CTRL;
        data = TESTE12_DATA;
        addr = TESTE12_ADDR;  
        if (data_out == TESTE11_DATA && en_out == TESTE11_EN && addr_out == TESTE11_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    12: begin        
        ctrl_in = TESTE13_CTRL;
        data = TESTE13_DATA;
        addr = TESTE13_ADDR;  
        if (data_out == TESTE12_DATA && en_out == TESTE12_EN && addr_out == TESTE12_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    13: begin        
        ctrl_in = TESTE14_CTRL;
        data = TESTE14_DATA;
        addr = TESTE14_ADDR;  
        if (data_out == TESTE13_DATA && en_out == TESTE13_EN && addr_out == TESTE13_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    14: begin        
        ctrl_in = TESTE15_CTRL;
        data = TESTE15_DATA;
        addr = TESTE15_ADDR;  
        if (data_out == TESTE14_DATA && en_out == TESTE14_EN && addr_out == TESTE14_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    15: begin        
        ctrl_in = TESTE16_CTRL;
        data = TESTE16_DATA;
        addr = TESTE16_ADDR;  
        if (data_out == TESTE15_DATA && en_out == TESTE15_EN && addr_out == TESTE15_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    16: begin        
        ctrl_in = TESTE17_CTRL;
        data = TESTE17_DATA;
        addr = TESTE17_ADDR;  
        if (data_out == TESTE16_DATA && en_out == TESTE16_EN && addr_out == TESTE16_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    17: begin        
        ctrl_in = TESTE1_CTRL;
        data = TESTE1_DATA;
        addr = TESTE1_ADDR;  
        if (data_out == TESTE17_DATA && en_out == TESTE17_EN && addr_out == TESTE17_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end  
    default: begin
        // nenhum teste em execucao, logo status padrao e de SUCESSO
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
    $display("\t ADDR: %6d  -  DATA: %6d  ", addr, data);   
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
    $display("\t DATA_OUT: %6d  ", data_out);        
    $display("\t ADDR_OUT: %6d  ", addr_out);        
    $display("\t EN_OUT: %b  ", en_out);        
end
endtask

// faz o include do modelo de testbench
// ESTE INCLUDE DEVE VIR POR ULTIMO !!!
`include "testbench.v"

endmodule
