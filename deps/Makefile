#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash
export TERM=xterm

CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

OPENVINO_RELEASE ?= releases/2021/3

OPENVINO_INSTALL_DIR ?= /opt/intel/openvino_2021/

UDEV_RULES='\
SUBSYSTEM=="usb", ATTRS{idProduct}=="2485", ATTRS{idVendor}=="03e7", GROUP="users", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"\n\
SUBSYSTEM=="usb", ATTRS{idProduct}=="f63b", ATTRS{idVendor}=="03e7", GROUP="users", MODE="0666", ENV{ID_MM_DEVICE_IGNORE}="1"'

#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
default: install 

install-prequisitories:
	@$(call msg,Installing the prequisitories ...) 
	@sudo apt update && sudo apt install -y --no-install-recommends \
	       wget \
	       cpio \
	       cmake \
	       lsb-release \
	       gcc \
	       g++ \
	       libpython3-dev \
	       python-gi-dev \
	       make \
	       mesa-utils \
	       libusb-1.0-0-dev
	       
	
openvino:
	@if [ ! -f ${OPENVINO_INSTALL_DIR}/bin/setupvars.sh ]; then \
		@$(call msg,Building & Installing OpenVINO ...) \
		mkdir -p ${OPENVINO_RELEASE} && \
		rm -rf ./openvino && \
		git clone https://github.com/openvinotoolkit/openvino && \
		cd openvino && \
			git checkout ${OPENVINO_RELEASE} && \
			git submodule update --init --recursive && \
			chmod a+x ./install_build_dependencies.sh && sudo ./install_build_dependencies.sh && \
			mkdir build && cd ./build && \
			 cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_SSE42=OFF -DTHREADING=SEQ  -DENABLE_GNA=OFF \
			  	-DCMAKE_INSTALL_PREFIX=${OPENVINO_INSTALL_DIR} .. && \
			make -j`nproc` && \
			sudo make install && \
		sudo usermod -a -G users "$(whoami)" && \
		echo -e ${UDEV_RULES} > 97-myriad-usbboot.rules && \
		sudo cp 97-myriad-usbboot.rules /etc/udev/rules.d/ && \
		sudo udevadm control --reload-rules && \
		sudo udevadm trigger && \
		sudo ldconfig && \
		rm 97-myriad-usbboot.rules; \
	fi
	
install: install-prequisitories openvino 

clean:
	@$(call msg,Cleaning the prequisitories ...) 
	

#----------------------------------------------------------------------------------------------------------------------
# helper functions
#----------------------------------------------------------------------------------------------------------------------
define msg
	tput setaf 2 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo  "" && \
	echo "         "$1 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo "" && \
	tput sgr0
endef
