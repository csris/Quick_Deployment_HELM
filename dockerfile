FROM nvidia/cuda:11.3.0-cudnn8-devel-ubuntu20.04

# init workdir
RUN mkdir -p /build
WORKDIR /build

# install common tool & conda
RUN apt update && \
    apt install wget -y && \
    apt install git -y && \
    apt install vim -y && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    mkdir -p /opt/conda/envs/alpa && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
# echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
# echo "conda activate base" >> ~/.bashrc

# install conda alpa env
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda create --name alpa python=3.8 -y && \
    conda activate alpa && \
    apt install coinor-cbc -y && \
    pip3 install --upgrade pip && \
    pip3 install cupy-cuda113 && \
    pip3 install alpa && \
    pip3 install jaxlib==0.3.22+cuda113.cudnn820 -f https://alpa-projects.github.io/wheels.html && \
    pip3 install together_worker && \
    pip3 install accelerate && \
    pip3 install "transformers<=4.23.1" fastapi uvicorn omegaconf jinja2  && \
    pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113  && \
    cd /build && \
    git clone https://github.com/alpa-projects/alpa.git && \
    cd alpa/examples && \
    pip3 install -e . && \
    echo "conda activate alpa" >> ~/.bashrc

ENV PATH /opt/conda/condabin/conda/bin:$PATH

