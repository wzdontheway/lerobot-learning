# 1. 选择基础镜像：不要用普通的 ubuntu，用 NVIDIA 为 Orin 优化的 L4T PyTorch 镜像
# 这能保证容器内直接调用 Orin 的 GPU，而且不用你自己折腾 CUDA 驱动
FROM nvcr.io/nvidia/l4t-pytorch:r35.2.1-pth2.0-py3

# 2. 避免在安装 apt 包时卡在交互提示上
ENV DEBIAN_FRONTEND=noninteractive

# 3. 设置容器内的工作目录
WORKDIR /workspace/robotics_project

# 4. 安装项目需要的系统级 C++ 依赖 (比如 ROS 相关的底层库、图像处理库)
RUN apt-get update && apt-get install -y \
    libopencv-dev \
    python3-opencv \
    && rm -rf /var/lib/apt/lists/* # 清理缓存，减小镜像体积

# 5. 复制项目代码（或者依赖表）到容器内
# 假设你的项目里有一个 requirements.txt 记录了所有 Python 依赖
COPY requirements.txt .

# 6. 安装 Python 依赖
# 使用清华源加速下载
RUN pip3 install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 7. (可选) 暴露容器的某个端口，比如你要在容器里开 Jupyter 或者可视化服务
EXPOSE 8888

# 8. 默认执行的命令，进入容器后默认打开一个 bash 终端
CMD ["/bin/bash"]

# 怎么用
# 构建镜像（打包）：在 Dockerfile 所在的目录下运行，它会一步步下载并配置好所有东西，打包成一个叫 my_vla_env 的“集装箱”。
# Bash
# sudo docker build -t my_vla_env:v1 .
# 运行容器（一键恢复）：当你需要在隔离环境里跑代码时，启动这个容器，并把物理机里的代码目录挂载（映射）进去，同时把 Orin 的 GPU 权限给它。
# sudo docker run -it --runtime nvidia --network host -v $(pwd):/workspace/robotics_project my_vla_env:v1