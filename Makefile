DOCKER_TAG = bamboog130/emacs:26.2
DOCKER_TAG_BUILD = bamboog130/emacs:build-26.2

RANDOMIZE_VA_SPACE = /proc/sys/kernel/randomize_va_space
RANDOMIZE_VA_SPACE_VAL = $(shell cat /proc/sys/kernel/randomize_va_space)


build: build-emacs-src
	-docker build --no-cache -t $(DOCKER_TAG) -f Dockerfile-emacs26 .
	docker image prune -f

build-emacs-src:
	sudo su -c "echo 0 > $(RANDOMIZE_VA_SPACE)"
	-docker build --no-cache -t "$(DOCKER_TAG_BUILD)" -f Dockerfile-emacs26_build .
	sudo su -c "echo $(RANDOMIZE_VA_SPACE_VAL) > $(RANDOMIZE_VA_SPACE)"
	docker image prune -f
