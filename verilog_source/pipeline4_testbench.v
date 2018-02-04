module pipeline4_testbench();

// faz o include dos parameters das instrucoes
`include "params_proc.v"

// indica o numero de testes a serem feitos
parameter N_TESTES = 5;

// declaracao das input e output
reg clk_in, RST;
reg [CTRL_WIDTH-1:0] ctrl_in;
reg we;
reg signed [DATA_WIDTH-1:0] data;
reg [MEM_WIDTH-1:0] addr;
reg [REG_ADDR_WIDTH-1:0] reg_addr_in;

wire signed [DATA_WIDTH-1:0] reg_data_out;
wire [REG_ADDR_WIDTH-1:0] reg_addr_out;
wire [CTRL_WIDTH-1:0] ctrl_out;

// instancia do modulo a ser testado
pipeline4 pipeline40(
    .clk_in(clk_in),
    .RST(RST),
    .ctrl_in(ctrl_in),
    .we(we),
    .data(data),
    .addr(addr),
    .reg_addr_in(reg_addr_in),
    .reg_data_out(reg_data_out),
    .reg_addr_out(reg_addr_out),
    .ctrl_out(ctrl_out)
);

// inicializa os inputs do modulo (acima) a ser testado
task init_input;
begin
    ctrl_in = NOP;
    we = 0;
    data = 0;
    addr = 0;
    reg_addr_in = 0;
end
endtask

// executa o teste numero 'testes' emitindo status como resultado do teste
task execute_test;
    input integer testes;
    output reg status;

    // dados dos testes
    parameter TESTE1_DATA = 5,
        TESTE1_CTRL = SW,
        TESTE1_ADDR = 0,
        TESTE1_REG_ADDR = 15;

    parameter TESTE2_DATA = 15,
        TESTE2_CTRL = LW,
        TESTE2_ADDR = TESTE1_ADDR,
        TESTE2_REG_ADDR = 20;

    parameter TESTE3_DATA = 25,
        TESTE3_CTRL = ADD,
        TESTE3_ADDR = TESTE1_ADDR+1,
        TESTE3_REG_ADDR = 22;

    parameter TESTE4_DATA = 37,
        TESTE4_CTRL = SUB,
        TESTE4_ADDR = TESTE3_ADDR,
        TESTE4_REG_ADDR = 30;
begin
    case(testes)
    0: begin
        ctrl_in <= TESTE1_CTRL;
        we <= 1;
        data <= TESTE1_DATA;
        addr <= TESTE1_ADDR;
        reg_addr_in <= TESTE1_REG_ADDR;
        status <= 0;        
    end
    1: begin        
        ctrl_in <= TESTE2_CTRL;
        we <= 0;
        data <= TESTE2_DATA;
        addr <= TESTE2_ADDR;
        reg_addr_in <= TESTE2_REG_ADDR;
        if (reg_data_out == TESTE1_DATA && ctrl_out == TESTE1_CTRL && reg_addr_out == TESTE1_REG_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end
    2: begin
        ctrl_in <= TESTE3_CTRL;
        we <= 1;
        data <= TESTE3_DATA;
        addr <= TESTE3_ADDR;
        reg_addr_in <= TESTE3_REG_ADDR;
        if (reg_data_out == TESTE1_DATA && ctrl_out == TESTE2_CTRL && reg_addr_out == TESTE2_REG_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end
    3: begin
        ctrl_in <= TESTE4_CTRL;
        we <= 0;
        data <= TESTE4_DATA;
        addr <= TESTE4_ADDR;
        reg_addr_in <= TESTE4_REG_ADDR;
        if (reg_data_out == TESTE3_DATA && ctrl_out == TESTE3_CTRL && reg_addr_out == TESTE3_REG_ADDR) begin
          status <= 0;
        end else begin
          status <= 1;                      
        end
    end
    4: begin
        ctrl_in <= TESTE1_CTRL;
        we <= 0;
        data <= TESTE1_DATA;
        addr <= TESTE4_ADDR;
        reg_addr_in <= TESTE1_REG_ADDR;
        if (reg_data_out == TESTE3_DATA && ctrl_out == TESTE4_CTRL && reg_addr_out == TESTE4_REG_ADDR) begin
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
    $display("\t WE: %b  ", we);
    $display("\t ADDR: %6d  -  DATA: %6d  ", addr, data);
    $display("\t REG_ADDR_IN: %3d  ", reg_addr_in);                
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
    $display("\t REG_DATA_OUT: %6d  ", reg_data_out);        
    $display("\t REG_ADDR_OUT: %3d  ", reg_addr_out);        
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
