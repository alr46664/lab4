
// contador de testes a serem feitos
integer testes;

// status dos testes
reg status;
reg [N_TESTES-1:0] status_geral;

// inicializando testes em 0
initial begin
    testes = -1;
    status = 0;
    status_geral = 0;
    // inicilizacao dos inputs
    init_input();
    // inicialize clk
    clk_in = 0;
    // faca rotina de reset
    RST = 1;
    #3;
    RST = 0;
    #3;
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
    // DESCREVA OS CASOS DE TESTE ABAIXO
    execute_test(testes, status);
end

// mostre os resultados dos testes
always @(posedge clk_in) begin
    // gere casos de teste
    testes <= testes+1;    
    // aqui aparecem os resultados dos testes
    if (testes >= 0 && testes  < N_TESTES) begin        
        display_input(testes, status);
    end
end

always @(negedge clk_in) begin
    if (testes >= 1) begin
        // verifique o status geral dos testes (qtd de testes que falharam)
        status_geral[testes-1] <= status;

        if (testes <= N_TESTES) begin

            // ENTRADAS (estaveis)
            display_output(testes, status);
            
            // mostre o status do processo
            $display("\t ------ STATUS -------  ");
            if (status == 0) begin
                $display("\t OK  ");          
            end else begin
                $display("\t FAILED  ");          
            end

        end else if (testes <= N_TESTES+1) begin
            $display("  ");              
            $display("  ------------  STATUS GERAL  -------------  ");            
            if (status_geral == 0) begin
                $display("\t\t OK  ");          
            end else begin
                $display("\t\t FAILED  ");          
            end
            $display("  ");              
        end                        
        $display("  ");  
    end
end