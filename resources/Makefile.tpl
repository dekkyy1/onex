MIUI_VERSION = {{MIUI_VERSION}}
PACKAGE_NAME = $(shell pwd | awk -F/ '{ print $$NF }')

include ../../Makefile

