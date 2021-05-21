#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash

CURRENT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BUILD_DIR=${CURRENT_DIR}/build

#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
default: build 
.PHONY: build

install-prequisitories:
	@make -C deps


build:install-prequisitories
	@$(call msg,Building  the DL Streamer for ARM ...) 
	@if [ ! -f "${CURRENT_DIR}/dlstreamer_gst/build/" ]; then \
		rm -rf ${CURRENT_DIR}/dlstreamer_gst && \
		git clone https://github.com/openvinotoolkit/dlstreamer_gst && 
		mkdir ${CURRENT_DIR}/dlstreamer_gst/build && \
		cd ${CURRENT_DIR}/dlstreamer_gst/build && \
			cmake -DENABLE_ITT=OFF -DENABLE_VAS_TRACKER=OFF -DDOWNLOAD_VAS_TRACKER=OFF ..;
	fi
	@cd ${CURRENT_DIR}/dlstreamer_gst/build && \
		make -j`nproc` ' && \
		sudo make install
		
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

