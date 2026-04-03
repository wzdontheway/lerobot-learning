# 环境部署（Conda + 源码安装）
#安装 Miniconda + 创建环境（Ubuntu 22.04 示例）
>>mkdir -p ~/miniconda3
cd ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
source ~/miniconda3/bin/activate
conda init --all

>>conda create -y -n lerobot_ws python=3.12
  conda activate lerobot_ws
# 克隆并安装 LeRobot
>>git clone https://github.com/huggingface/lerobot ~/lerobot_ws
>>conda install -y -c conda-forge ffmpeg #视频处理工具
  cd ~/lerobot
>>pip install -e . -i https://pypi.tuna.tsinghua.edu.cn/simple
# 对于 Jetson Jetpack 设备（请确保在执行此步骤前按照此链接教程第 5 步安装了 Pytorch-gpu 和 Torchvision）：

conda install -y -c conda-forge "opencv>=4.10.0.84"  # 通过 conda 安装 OpenCV 和其他依赖，仅适用于 Jetson Jetpack 6.0+
conda remove opencv   # 卸载 OpenCV
pip3 install opencv-python==4.10.0.84  # 使用 pip3 安装指定版本 OpenCV
conda install -y -c conda-forge ffmpeg
conda uninstall numpy
pip3 install numpy==1.26.0  # 该版本需与 torchvision 兼容

# 安装双臂 teleop / follower 依赖
pip install lerobot_teleoperator_bimanual_leader
pip install lerobot_robot_bimanual_follower
# 检查 PyTorch 是否为 GPU 版本
import torch
print(torch.cuda.is_available())
#若为 False，按官方/Jetson 对应方式重新安装 GPU 版 torch/torchvision
# 手臂端口设置
lsusb
#识别成功，查看ttyusb的信息。https://files.seeedstudio.com/wiki/robotics/projects/lerobot/starai/Calibrate1.png
sudo dmesg | grep ttyUSB
#最后一行显示断连，因为brltty在占用该USB设备号，移除掉就可以了。https://files.seeedstudio.com/wiki/robotics/projects/lerobot/starai/Calibrate2.png
sudo apt remove brltty
#https://files.seeedstudio.com/wiki/robotics/projects/lerobot/starai/Calibrate3.png
#最后，赋予权限。https://files.seeedstudio.com/wiki/robotics/projects/lerobot/starai/Calibrate3.png
sudo chmod 666 /dev/ttyUSB*

# 双臂校准
#！！先断电，调整初始位置
#按先后插主，先插一个
ls /dev/ttyUSB*
#再插一个
ls /dev/ttyUSB*
sudo chmod 666 /dev/ttyUSB*  #权限

lerobot-calibrate     --teleop.type=lerobot_teleoperator_bimanual_leader  --teleop.left_arm_port=/dev/ttyUSB0  --teleop.right_arm_port=/dev/ttyUSB2  --teleop.id=bi_starai_violin_leader

lerobot-calibrate     --robot.type=lerobot_robot_bimanual_follower  --robot.arm_name=starai_cello  --robot.left_arm_port=/dev/ttyUSB1  --robot.right_arm_port=/dev/ttyUSB3 --robot.id=bi_starai_cello_follower

#校准文件保存位置可到此处查看对应的校准文件，为JSON文件，对应机械臂各个关节
- ~/.cache/huggingface/lerobot/calibration/robots
- ~/.cache/huggingface/lerobot/calibration/teleoperators

#sb东西有个悬停按钮
sudo chmod 666 /dev/ttyUSB0 /dev/ttyUSB1 /dev/ttyUSB2 /dev/ttyUSB3

#  运行双臂 teleop / follower
lerobot-teleoperate   --robot.type=lerobot_robot_bimanual_follower   --robot.arm_name=starai_viola   --robot.left_arm_port=/dev/ttyUSB1   --robot.right_arm_port=/dev/ttyUSB3   --robot.id=bi_starai_viola_follower   --teleop.type=lerobot_teleoperator_bimanual_leader   --teleop.left_arm_port=/dev/ttyUSB0   --teleop.right_arm_port=/dev/ttyUSB2   --teleop.id=bi_starai_violin_leader   --display_data=true  //false 主循环频率会立刻飙升

# 添加摄像头
#运行ls /dev/v4l/by-id/。你会看到一串长长的、带有相机品牌和序列号的路径。
#在 LeRobot 或 ROS 的配置文件里，不要写 /dev/video0，直接写by-id的长路径