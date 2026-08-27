module max30102_ctrl (
    input  wire        clk,
    input  wire        rst_n,
    inout  wire        i2c_sda,
    inout  wire        i2c_scl,
    output reg [23:0]  red_data,
    output reg [23:0]  ir_data
);

    // Simple I2C Master Stub / State Engine for fetching Red/IR FIFO data
    reg [7:0]  fsm_state;
    reg [15:0] clk_div;
    reg        scl_internal, sda_internal;

    assign i2c_scl = scl_internal ? 1'bz : 1'b0;
    assign i2c_sda = sda_internal ? 1'bz : 1'b0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fsm_state    <= 0;
            clk_div      <= 0;
            scl_internal <= 1;
            sda_internal <= 1;
            red_data     <= 24'h123456; // Placeholder mock stream data
            ir_data      <= 24'h654321;
        end else begin
            // Generate 400kHz I2C clock ticks from 10MHz master clock
            if (clk_div == 9) begin
                clk_div      <= 0;
                scl_internal <= ~scl_internal;
            end else begin
                clk_div      <= clk_div + 1;
            end
        end
    end
endmodule
