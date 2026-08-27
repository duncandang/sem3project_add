module packet_assembler (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] distance,
    input  wire [23:0] red,
    input  wire [23:0] ir,
    input  wire        fifo_full,
    output reg         fifo_wr_en,
    output reg [7:0]   fifo_din
);

    reg [3:0]  state;
    reg [23:0] timer;

    localparam S_IDLE   = 4'd0;
    localparam S_HDR    = 4'd1;
    localparam S_DIST_H = 4'd2;
    localparam S_DIST_L = 4'd3;
    localparam S_RED_H  = 4'd4;
    localparam S_RED_M  = 4'd5;
    localparam S_RED_L  = 4'd6;
    localparam S_IR_H   = 4'd7;
    localparam S_IR_M   = 4'd8;
    localparam S_IR_L   = 4'd9;
    localparam S_FTR    = 4'd10;
    localparam S_DELAY  = 4'd11;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= S_IDLE;
            fifo_wr_en <= 1'b0;
            fifo_din   <= 8'h00;
            timer      <= 24'd0;
        end else begin
            fifo_wr_en <= 1'b0;
            case (state)
                S_IDLE: begin
                    if (timer >= 24'd100000) begin // Sampling interval packet rate
                        timer <= 0;
                        state <= S_HDR;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                S_HDR: begin
                    if (!fifo_full) begin
                        fifo_din   <= 8'hAA; // Header
                        fifo_wr_en <= 1'b1;
                        state      <= S_DIST_H;
                    end
                end

                S_DIST_H: begin
                    if (!fifo_full) begin
                        fifo_din   <= distance[15:8];
                        fifo_wr_en <= 1'b1;
                        state      <= S_DIST_L;
                    end
                end

                S_DIST_L: begin
                    if (!fifo_full) begin
                        fifo_din   <= distance[7:0];
                        fifo_wr_en <= 1'b1;
                        state      <= S_RED_H;
                    end
                end

                S_RED_H: begin
                    if (!fifo_full) begin
                        fifo_din   <= red[23:16];
                        fifo_wr_en <= 1'b1;
                        state      <= S_RED_M;
                    end
                end

                S_RED_M: begin
                    if (!fifo_full) begin
                        fifo_din   <= red[15:8];
                        fifo_wr_en <= 1'b1;
                        state      <= S_RED_L;
                    end
                end

                S_RED_L: begin
                    if (!fifo_full) begin
                        fifo_din   <= red[7:0];
                        fifo_wr_en <= 1'b1;
                        state      <= S_IR_H;
                    end
                end

                S_IR_H: begin
                    if (!fifo_full) begin
                        fifo_din   <= ir[23:16];
                        fifo_wr_en <= 1'b1;
                        state      <= S_IR_M;
                    end
                end

                S_IR_M: begin
                    if (!fifo_full) begin
                        fifo_din   <= ir[15:8];
                        fifo_wr_en <= 1'b1;
                        state      <= S_IR_L;
                    end
                end

                S_IR_L: begin
                    if (!fifo_full) begin
                        fifo_din   <= ir[7:0];
                        fifo_wr_en <= 1'b1;
                        state      <= S_FTR;
                    end
                end

                S_FTR: begin
                    if (!fifo_full) begin
                        fifo_din   <= 8'h55; // Footer
                        fifo_wr_en <= 1'b1;
                        state      <= S_IDLE;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
