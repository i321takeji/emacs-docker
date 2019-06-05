DOCKER_TAG = bamboog130/emacs26

RANDOMIZE_VA_SPACE = /proc/sys/kernel/randomize_va_space
RANDOMIZE_VA_SPACE_VAL = $(shell cat /proc/sys/kernel/randomize_va_space)


build: build-emacs-src

build-emacs-src:
	sudo su -c "echo 0 > $(RANDOMIZE_VA_SPACE)"
	-docker build --no-cache -t $(DOCKER_TAG) -f Dockerfile-emacs26 .
	sudo su -c "echo $(RANDOMIZE_VA_SPACE_VAL) > $(RANDOMIZE_VA_SPACE)"
	docker image prune -f
