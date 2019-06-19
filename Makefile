DOCKER_TAG = bamboog130/emacs:26.2
DOCKER_BUILD_TAG = bamboog130/emacs:build-26.2

RANDOMIZE_VA_SPACE = /proc/sys/kernel/randomize_va_space
RANDOMIZE_VA_SPACE_VAL = $(shell cat /proc/sys/kernel/randomize_va_space)


build: build-emacs-src
	-docker build --cache-from $(DOCKER_BUILD_TAG) -t $(DOCKER_TAG)  .
	docker image prune -f

build-emacs-src:
	sudo su -c "echo 0 > $(RANDOMIZE_VA_SPACE)"
	-docker build --no-cache --target build-stage -t $(DOCKER_BUILD_TAG) .
	sudo su -c "echo $(RANDOMIZE_VA_SPACE_VAL) > $(RANDOMIZE_VA_SPACE)"
	docker image prune -f
