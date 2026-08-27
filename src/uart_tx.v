module uart_tx (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       fifo_empty,
    input  wire [7:0] fifo_dout,
    output reg        rd_en,
    output reg        tx,
    output reg        busy
);

    // Assuming 10MHz clock and 115200 baud -> ~87 clock cycles per bit
    localparam CLK_PER_BIT = 87;

    reg [3:0]  state;
    reg [13:0] clk_count;
    reg [2:0]  bit_index;
    reg [7:0]  tx_data_reg;

    localparam S_IDLE  = 4'd0;
    localparam S_START = 4'd1;
    localparam S_DATA  = 4'd2;
    localparam S_STOP  = 4'd3;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= S_IDLE;
            tx          <= 1'b1;
            rd_en       <= 1'b0;
            busy        <= 1'b0;
            clk_count   <= 0;
            bit_index   <= 0;
            tx_data_reg <= 0;
        end else begin
            rd_en <= 1'b0;
            case (state)
                S_IDLE: begin
                    tx   <= 1'b1;
                    busy <= 1'b0;
                    if (!fifo_empty) begin
                        rd_en       <= 1'b1; // Pop byte from FIFO
                        tx_data_reg <= fifo_dout;
                        state       <= S_START;
                        busy        <= 1'b1;
                    end
                end

                S_START: begin
                    tx <= 1'b0; // Start bit (Low)
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        bit_index <= 0;
                        state     <= S_DATA;
                    end
                end

                S_DATA: begin
                    tx <= tx_data_reg[bit_index];
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            state <= S_STOP;
                        end
                    end
                end

                S_STOP: begin
                    tx <= 1'b1; // Stop bit (High)
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state     <= S_IDLE;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
