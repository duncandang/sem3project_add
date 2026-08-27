module pmu_controller (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        user_detected,
    output reg         pwr_ctrl
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwr_ctrl <= 1'b0; // Default sleep/low-power state
        end else begin
            if (user_detected)
                pwr_ctrl <= 1'b1; // Wake up blocks when user is detected
            else
                pwr_ctrl <= 1'b0; // Low power when not used
        end
    end

endmodule
