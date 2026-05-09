module uart_tx(
    input clk,
    input start,
    input [7:0] data,

    output reg tx = 1'b1,
    output reg busy = 0
);

parameter CLK_FREQ = 100_000_000;
parameter BAUD_RATE = 115200;

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [15:0] clk_count = 0;
reg [3:0] bit_index = 0;

reg [9:0] tx_shift = 10'b1111111111;

always @(posedge clk)
begin

    if(start && !busy)
    begin
        busy <= 1'b1;

        // stop bit + data + start bit
        tx_shift <= {1'b1, data, 1'b0};

        tx <= 1'b0;   // start bit immediately

        clk_count <= 0;
        bit_index <= 0;
    end

    else if(busy)
    begin

        if(clk_count < CLKS_PER_BIT-1)
        begin
            clk_count <= clk_count + 1;
        end

        else
        begin
            clk_count <= 0;

            if(bit_index < 9)
            begin
                bit_index <= bit_index + 1;

                tx_shift <= {1'b1, tx_shift[9:1]};

                tx <= tx_shift[1];
            end

            else
            begin
                busy <= 0;
                tx <= 1'b1;
            end

        end

    end

end

endmodule
