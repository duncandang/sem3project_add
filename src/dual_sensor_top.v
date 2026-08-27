module dual_sensor_top (
    input  wire        clk_10mhz,
    input  wire        rst_n,
    // SRF05 Interface
    output wire        srf_trig,
    input  wire        srf_echo,
    // MAX30102 Interface
    inout  wire        i2c_sda,
    inout  wire        i2c_scl,
    // Power Management Control Output
    output wire        pwr_ctrl,
    // UART TX Output
    output wire        uart_tx_pin,
    output wire [2:0]  led_status
);

    wire        user_detected;
    wire [15:0] distance_out;
    wire [23:0] red_data, ir_data;
    wire        fifo_wr_en, fifo_rd_en, fifo_full, fifo_empty;
    wire [7:0]  fifo_din, fifo_dout;
    wire        uart_busy;

    // Power Management Controller (FSM)
    pmu_controller u_pmu (
        .clk(clk_10mhz),
        .rst_n(rst_n),
        .user_detected(user_detected),
        .pwr_ctrl(pwr_ctrl)
    );

    // SRF05 Distance Sensor Controller
    srf05_ctrl u_srf_ctrl (
        .clk(clk_10mhz),
        .rst_n(rst_n),
        .srf_trig(srf_trig),
        .srf_echo(srf_echo),
        .user_detected(user_detected),
        .distance_out(distance_out)
    );

    // MAX30102 Health Sensor Controller (Gated by pwr_ctrl)
    max30102_ctrl u_max30102_ctrl (
        .clk(clk_10mhz),
        .rst_n(rst_n && pwr_ctrl),
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl),
        .red_data(red_data),
        .ir_data(ir_data)
    );

    // Multiplexed FIFO & Data Packager
    packet_assembler u_packet_assembler (
        .clk(clk_10mhz),
        .rst_n(rst_n && pwr_ctrl),
        .distance(distance_out),
        .red(red_data),
        .ir(ir_data),
        .fifo_full(fifo_full),
        .fifo_wr_en(fifo_wr_en),
        .fifo_din(fifo_din)
    );

    fifo_buffer u_fifo (
        .clk(clk_10mhz),
        .rst_n(rst_n),
        .wr_en(fifo_wr_en),
        .rd_en(fifo_rd_en),
        .din(fifo_din),
        .dout(fifo_dout),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    uart_tx u_uart (
        .clk(clk_10mhz),
        .rst_n(rst_n),
        .fifo_empty(fifo_empty),
        .fifo_dout(fifo_dout),
        .rd_en(fifo_rd_en),
        .tx(uart_tx_pin),
        .busy(uart_busy)
    );

    assign led_status = {user_detected, ~fifo_empty, uart_busy};

endmodule
