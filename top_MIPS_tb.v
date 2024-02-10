
`timescale 1 ns / 1 ps
module top_MIPS_tb;
  
  parameter   PERIOD = 10;
  reg         i_clk, i_rst_n;
  integer     error_cnt;
  top inst_top_MIPS (.i_clk(i_clk), .i_rst_n(i_rst_n));
  
  initial 
  begin
    i_clk = 0;
    forever #(PERIOD / 2) i_clk = ~i_clk;
  end
  
    
  initial 
  begin
    
    error_cnt = 0;
    
    // Test first program
    
    i_rst_n = 0;
    
    $readmemb("mips_test1.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    @(negedge i_clk)
    i_rst_n = 1;
 
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[0] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[5] == 3500)
      $display("TEST1 SUCCESSFUL");
    else
      begin
        $display("TEST1 FAILED");
        $display("Expected result: 3500, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[5] );
        error_cnt = error_cnt + 1;
      end
      
    // Test second program
    
    i_rst_n = 0;
    
    $readmemb("mips_test2.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    
    @(negedge i_clk)
    i_rst_n = 1;
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[1] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[6] == 55)
      $display("TEST2 SUCCESSFUL");
    else
      begin
        $display("TEST2 FAILED");
        $display("Expected result: 55, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[6]);
        error_cnt = error_cnt + 1;      
      end
    
    // Test third program   
    
    i_rst_n = 0;
    
    $readmemb("mips_test3.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    
    @(negedge i_clk)
    i_rst_n = 1;
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[11] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[12] == 2112)
      $display("TEST3 SUCCESSFUL");
    else
      begin
        $display("TEST3 FAILED");
        $display("Expected result: 2112, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[12]);
        error_cnt = error_cnt + 1;
      end
       
    // Test fourth program   
    
    i_rst_n = 0;
    
    $readmemb("mips_test4.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    
    @(negedge i_clk)
    i_rst_n = 1;
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[13] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[14] == 16464)
      $display("TEST4 SUCCESSFUL");
    else
      begin
        $display("TEST4 FAILED");
        $display("Expected result: 16464, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[14]);
        error_cnt = error_cnt + 1;
      end
      
    // Test fifth program  
     
    i_rst_n = 0;
    
    $readmemb("mips_test5.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    
    @(negedge i_clk)
    i_rst_n = 1;
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[19] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[15] == 100)
      $display("TEST5.1 SUCCESSFUL");
    else 
      begin
        $display("TEST5.1 FAILED");
        $display("Expected: 100, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[15]);  
        error_cnt = error_cnt + 1;
      end
      
    if(inst_top_MIPS.inst_Data_Mem.data_mem[16] == -2147483648)
      $display("TEST5.2 SUCCESSFUL");
    else 
      begin
        $display("TEST5.2 FAILED");
        $display("Expected: -2147483648, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[16]);
        error_cnt = error_cnt + 1;
      end
    
    if(inst_top_MIPS.inst_Data_Mem.data_mem[17] == 200)
      $display("TEST5.3 SUCCESSFUL");
    else 
      begin
        $display("TEST5.3 FAILED");
        $display("Expected: 200, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[17]);
        error_cnt = error_cnt + 1;
      end
      
    if(inst_top_MIPS.inst_Data_Mem.data_mem[18] == 2147483647)
      $display("TEST5.4 SUCCESSFUL");
    else 
      begin
        $display("TEST5.4 FAILED");
        $display("Expected: 2147483647, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[18]);
        error_cnt = error_cnt + 1;
      end
      
    // Sixth program 
    i_rst_n = 0;
    $readmemb("mips_test6.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    @(negedge i_clk)
    i_rst_n = 1;
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[22] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[20] == 2147483647)
      $display("TEST6.1 SUCCESSFUL");
    else 
      begin
        $display("TEST6.1 FAILED");
        $display("Expected: 2147483647, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[20]);  
        error_cnt = error_cnt + 1;
      end
      
      if(inst_top_MIPS.inst_Data_Mem.data_mem[21] == -2147483648)
      $display("TEST6.2 SUCCESSFUL");
    else 
      begin
        $display("TEST6.2 FAILED");
        $display("Expected: -2147483648, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[21]);  
        error_cnt = error_cnt + 1;
      end
      
    // Test seventh program
    
    i_rst_n = 0;
    
    $readmemb("mips_test7.dat", inst_top_MIPS.inst_Instruct_Mem.inst_mem);
    
    @(negedge i_clk)
    i_rst_n = 1;
    
    while (inst_top_MIPS.inst_Data_Mem.data_mem[26] !== 1)
    begin
      @(negedge i_clk);
    end
    if(inst_top_MIPS.inst_Data_Mem.data_mem[25] == 4144)
      $display("TEST7 SUCCESSFUL");
    else
      begin
        $display("TEST7 FAILED");
        $display("Expected result: 4144, Actual: %0d", inst_top_MIPS.inst_Data_Mem.data_mem[25]);
        error_cnt = error_cnt + 1;
      end
      
    if(error_cnt == 0)
      $display("MIPS test completed successfully");
    else
      begin
        $display("MIPS test completed failure");
        $display("Content of error counter: %0d", error_cnt);
      end
       
    $finish();
  end
endmodule