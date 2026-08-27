module srf05_ctrl (
    input  wire        clk,        // 1 MHz tick or derived from 10 MHz
    input  wire        rst_n,
    output reg         srf_trig,
    input  wire        srf_echo,
    output reg         user_detected,
    output reg [15:0]  distance_out
);

    reg [20:0]  timer;
    reg [15:0]  echo_counter;
    reg         echo_sync_0, echo_sync_1;
    
    localparam S_IDLE     = 2'b00;
    localparam S_TRIG     = 2'b01;
    localparam S_WAIT     = 2'b10;
    localparam S_CALC     = 2'b11;
    
    reg [1:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= S_IDLE;
            srf_trig     <= 0;
            timer        <= 0;
            echo_counter <= 0;
            distance_out <= 0;
            user_detected<= 0;
            echo_sync_0  <= 0;
            echo_sync_1  <= 0;
        end else begin
            // Double flop synchronizer for asynchronous echo input
            echo_sync_0 <= srf_echo;
            echo_sync_1 <= echo_sync_0;

            case (state)
                S_IDLE: begin
                    srf_trig <= 0;
                    if (timer >= 21'd1000000) begin // Poll every ~100ms
                        timer <= 0;
                        state <= S_TRIG;
                    end else begin
                        timer <= timer + 1;
                    end
                end

                S_TRIG: begin
                    if (timer < 21'd10) begin // 10us trigger pulse
                        srf_trig <= 1;
                        timer    <= timer + 1;
                    end else begin
                        srf_trig     <= 0;
                        timer        <= 0;
                        echo_counter <= 0;
                        state        <= S_WAIT;
                    end
                end

                S_WAIT: begin
                    if (echo_sync_1) begin
                        echo_counter <= echo_counter + 1;
                        if (timer > 21'd30000) state <= S_CALC; // Timeout safeguard
                    end else if (echo_counter > 0) begin
                        state <= S_CALC;
                    end
                    timer <= timer + 1;
                end

                S_CALC: begin
                    // Distance in cm = (echo_time_us * 0.0343) / 2 ≈ (counter * 343) / 20000
                    distance_out  <= (echo_counter * 8'd17) >> 10; 
                    // Wake up if distance is within 50 cm
                    user_detected <= (((echo_counter * 8'd17) >> 10) <= 16'd50);
                    state         <= S_IDLE;
                end
            endcase
        end
    end
endmodule
