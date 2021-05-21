#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash
export TERM=xterm

CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

OPENVINO_RELEASE ?= 2020.3.355



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
	       mesa-utils 
	@pip3 install --user meson
	
openvino:
	@if [ ! -f /opt/intel/openvino/bin/setupvars.sh ]; then \
		@$(call msg,Installing OpenVINO ...) 
		wget https://storage.openvinotoolkit.org/repositories/openvino/packages/2020.3.2/l_openvino_toolkit_runtime_raspbian_p_${OPENVINO_RELEASE}.tgz && \
		sudo tar -xf  l_openvino_toolkit_runtime_raspbian_p_${OPENVINO_RELEASE}.tgz --strip 1 -C /opt/intel/openvino && \
		sudo usermod -a -G users "$(whoami)" && \
		source /opt/intel/openvino/bin/setupvars.sh && \
		sh /opt/intel/openvino_2021/install_dependencies/install_NCS_udev_rules.sh; \
	fi
	
gstreamer: install-prequisitories
	@if [ ! -f "${CURRENT_DIR}/gst-build/.done" ]; then \
		@$(call msg,Installing gstreamer ...) \
		rm -rf ${CURRENT_DIR}/gst-build && \
               git clone https://gitlab.freedesktop.org/gstreamer/gst-build.git && \
               cd gst-build && mkdir build && \
               meson build && \
               cd build && ninja && \
	       touch ${CURRENT_DIR}/gst-build/.done; \
        fi


clean:
	@$(call msg,Cleaning the prequisitories ...) 
	@rm -rf ${CURRENT_DIR}/gst-build/.done

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
