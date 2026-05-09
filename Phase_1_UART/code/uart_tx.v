module uart_rx(
    input clk,
    input rx,

    output reg [7:0] data = 0,
    output reg done = 0
);

parameter CLK_FREQ = 100_000_000;
parameter BAUD_RATE = 115200;

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

reg [15:0] clk_count = 0;
reg [2:0] bit_index = 0;

reg [7:0] rx_shift = 0;

reg [1:0] state = 0;

localparam IDLE  = 2'd0;
localparam START = 2'd1;
localparam DATA  = 2'd2;
localparam STOP  = 2'd3;

always @(posedge clk)
begin

    done <= 0;

    case(state)

    IDLE:
    begin
        clk_count <= 0;
        bit_index <= 0;

        if(rx == 0)
        begin
            state <= START;
        end
    end

    START:
    begin

        if(clk_count == (CLKS_PER_BIT/2))
        begin

            if(rx == 0)
            begin
                clk_count <= 0;
                state <= DATA;
            end

            else
            begin
                state <= IDLE;
            end

        end

        else
        begin
            clk_count <= clk_count + 1;
        end

    end

    DATA:
    begin

        if(clk_count < CLKS_PER_BIT-1)
        begin
            clk_count <= clk_count + 1;
        end

        else
        begin

            clk_count <= 0;

            rx_shift[bit_index] <= rx;

            if(bit_index < 7)
            begin
                bit_index <= bit_index + 1;
            end

            else
            begin
                bit_index <= 0;
                state <= STOP;
            end

        end

    end

    STOP:
    begin

        if(clk_count < CLKS_PER_BIT-1)
        begin
            clk_count <= clk_count + 1;
        end

        else
        begin

            data <= rx_shift;
            done <= 1;

            clk_count <= 0;
            state <= IDLE;

        end

    end

    endcase

end

endmodule
