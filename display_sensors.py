import matplotlib.pyplot as plt
from collections import deque
import random
import time

dist_data = deque(maxlen=200)
red_data = deque(maxlen=200)
ir_data = deque(maxlen=200)

plt.ion()
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(8, 6))

print("Running in simulation mode (no hardware connected)...")

try:
    while True:
        # Generate mock sensor values simulating FPGA telemetry
        dist_val = random.randint(10, 50)  # Simulated distance in cm
        red_val = random.randint(50000, 60000)  # Simulated PPG Red
        ir_val = random.randint(40000, 50000)   # Simulated PPG IR
        
        dist_data.append(dist_val)
        red_data.append(red_val)
        ir_data.append(ir_val)
        
        # Plot Distance (SRF05)
        ax1.clear()
        ax1.plot(dist_data, label='Mock Distance (cm)', color='blue')
        ax1.set_ylim(0, 400)
        ax1.legend(loc='upper right')
        ax1.set_title('SRF05 Ultrasonic Range (Simulation)')
        
        # Plot PPG Signals (MAX30102)
        ax2.clear()
        ax2.plot(red_data, label='Mock PPG Red', color='red')
        ax2.plot(ir_data, label='Mock PPG IR', color='black')
        ax2.legend(loc='upper right')
        ax2.set_title('MAX30102 Oximetry (Simulation)')
        
        plt.pause(0.05)
        time.sleep(0.05)
except KeyboardInterrupt:
    print("Simulation stopped.")
