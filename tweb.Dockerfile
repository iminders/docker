FROM tradingai/tweb:latest

# 更换为阿里云境像
RUN sed -i "s/archive.ubuntu.com/mirrors.aliyun.com/g" /etc/apt/sources.list
# 更换默认pip源
RUN mkdir /root/.pip
RUN echo "[global]" >> /root/.pip/pip.conf
RUN echo "index-url=http://mirrors.aliyun.com/pypi/simple/" >> /root/.pip/pip.conf
RUN echo "trusted-host=mirrors.aliyun.com" >> /root/.pip/pip.conf

CMD ["bin/bash"]
