import serial

port = "/dev/ttyUSB1"
baudrate = 1000000 # 如果不通，尝试 115200

def check_id(ser, motor_id):
    # 这是 Starai/通用协议常见的读取指令简化版
    # 我们通过尝试打开端口并发送测试信号来观察是否有回信
    # 这里的逻辑是看哪些 ID 会让程序不报错
    pass 

print(f"正在扫描 {port} 上的电机...")
# 建议直接看打印出的报错，如果能跳过 0,1,2,3,4 说明它们是存在的