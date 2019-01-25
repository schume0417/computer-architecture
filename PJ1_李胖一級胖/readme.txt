在我們的pipelined CPU裡，我們使用了五個MUX來實作，其中MUX2跟MUX3置於ALU前，判斷是否要用forwarding來取代當前的data，而MUX_PC用來處理beq program counter的狀況，MUX_ALUSRC則是選擇data2或immediate的值去做ALU運算，最後MUXhazard則是當stall發生時，改變由control傳出來的signal，讓後續的運算不會造成任何影響。
在control的部分，我們先在module裡就找出該instruction確切的指令，用0到8來代表，並傳給ID_EX，有利於之後的判斷，例如決定ALU的operation，還有是否寫入memory or register等，
在hazard detection的部分，我們把signal傳給pc跟IF_ID，如果stall發生，"pc_o <= pc_o" "instr_o <= instr_o" 來把值保留一個cycle，如果需要flush "instr_o <= 0" "addr_o <= 0" 讓IF_ID傳去的值歸零
forwarding => if (EX_MEM_wb_i[0] != 0 && EX_MEM_rd_i != 0 && EX_MEM_rd_i == ID_EX_rs_i) => 傳 10 給MUX2
			  if (EX_MEM_wb_i[0] != 0 && EX_MEM_rd_i != 0 && EX_MEM_rd_i == ID_EX_rt_i) => 傳 10 給MUX3
			  if (MEM_WB_wb_i != 0 && MEM_WB_rd_i != 0 && MEM_WB_rd_i == ID_EX_rs_i) => 傳 01 給MUX2
			  if (MEM_WB_wb_i != 0 && MEM_WB_rd_i != 0 && MEM_WB_rd_i == ID_EX_rt_i) => 傳 01 給MUX3
sign_extend => 取immediate的值
add_shift => 把immediate的位置重組成正確的值
add_PC => pc+4
euqal => 判斷beq是否成立

遇到的問題：
"=" 會直接附值而 "<=" 會在begin end 結束後才附值，剛開始遇到很多小的bug都是這個問題，弄清楚其中的差異後就把問題解決了