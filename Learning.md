# 备份到github
>>git init  #初始化

>>git remote add origin https://github.com/wzdontheway/lerobot-learning #本地绑定你的 GitHub 仓库

#你在任何一台设备（无论是电脑还是 Orin）上开始敲代码前，第一步永远是执行：
git pull origin master  # (或者 main) 先把云端最新的变动同步到本地

#1. 标记所有修改的文件（新增/修改/删除都包含）
>>git add .

#2. 写备份备注
>>git commit -m "我的LeRobot代码备份"

#3. 上传到GitHub（完成备份！）
>>git push origin main

# 查找真实脚本路径
cat pyproject.toml | grep -A 10 "project.scripts"

#  docker
#在新板子上，把 GitHub 上的“菜谱”（代码和 Dockerfile）原封不动地 git clone 下来。
#在新板子上，运行 sudo docker build...，按照菜谱重新烤一个新蛋糕。
#1. 把代码从你刚推上去的 GitHub 拉下来
git clone https://github.com/wzdontheway/lerobot-learning.git

#2. 进入项目主目录（这步非常重要，必须进到这个文件夹里）
cd lerobot-learning

#3. 赋予脚本执行权限并运行
chmod +x docker/setup_orin.sh
./docker/setup_orin.sh 

#构建 Docker 镜像
sudo docker build -t lerobot_orin_env:v1 -f docker/Dockerfile .

#启动容器（硬件大穿透）
sudo docker run -it \
    --runtime nvidia \
    --privileged \
    --network host \
    -v /dev:/dev \
    -v $(pwd):/workspace/lerobot-learning \
    lerobot_orin_env:v1 \
    /bin/bash