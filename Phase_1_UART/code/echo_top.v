module echo_top(
    input clk,
    input rx,
    output tx
);

wire [7:0] rx_data;
wire rx_done;

reg tx_start = 0;

wire tx_busy;

uart_rx RX (
    .clk(clk),
    .rx(rx),
    .data(rx_data),
    .done(rx_done)
);

uart_tx TX (
    .clk(clk),
    .start(tx_start),
    .data(rx_data),
    .tx(tx),
    .busy(tx_busy)
);

always @(posedge clk)
begin

    tx_start <= 0;

    if(rx_done && !tx_busy)
    begin
        tx_start <= 1;
    end

end

endmodule
