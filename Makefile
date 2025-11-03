# Runtime variables
RELEASE = 0.5.0
CONTAINERFILE ?= container/Dockerfile.create
CACHE_CONTAINERFILE = container/Dockerfile.cache
CONTAINER_ENGINE = docker

# rm to rm -f
RM := rm -f

# All targets that don't produce a file should be phony.
.PHONY: usage build remove run copy all cache cache-build copy-cache generate-sha256sums default

usage:
	@echo "Please execute with one of the following options:"
	@echo " make build          : Build a Docker container image for creating an ISO using the Dockerfile"
	@echo " make cache-build    : Build a Docker container image for downloading DEB files using the Dockerfile"
	@echo " make run            : Run a Docker container to build the COEN ISO image"
	@echo " make remove         : Remove the Docker container"
	@echo " make copy           : Copy the resultant COEN ISO image from the Docker container into the host directory"
	@echo " make copy-cache     : Copy the downloaded DEB packages from the Docker container into the repository"
	@echo " make all            : Execute build, remove, run, and copy with Docker"
	@echo " make cache          : Execute cache-build, copy-cache with Docker"


# --- Cache and Repository Management ---

cache-build:
	$(CONTAINER_ENGINE) build -t coen-cache:$(RELEASE) -f $(CACHE_CONTAINERFILE) .

copy-cache:
	@mkdir -p ./tools/archives-distro # Ensure destination exists
	$(CONTAINER_ENGINE) create --name temp-deb-container coen-cache:$(RELEASE)
	$(RM) ./tools/archives-distro/*
	$(CONTAINER_ENGINE) cp temp-deb-container:/packages/. ./tools/archives-distro
	$(CONTAINER_ENGINE) rm temp-deb-container

generate-sha256sums:
	sha256sum variables.sh create-iso.sh > SHA256SUMS
	find tools/ -type f -exec sha256sum {} + >> SHA256SUMS

# --- Main ISO Build Targets ---

iso-build:
	$(CONTAINER_ENGINE) build -t coen:$(RELEASE) -f $(CONTAINERFILE) .

remove:
	-$(CONTAINER_ENGINE) rm --force coen

run:
	$(CONTAINER_ENGINE) run --init --interactive --tty \
	--privileged \
	--userns=host --ipc=host --network=host --pid=host --uts=host \
	--name=coen \
	coen:$(RELEASE)

copy:
	$(CONTAINER_ENGINE) cp coen:/opt/coen-${RELEASE}-amd64.iso .

# --- Orchestration Targets ---
cache: cache-build copy-cache generate-sha256sums

build: remove iso-build run copy remove

all: remove cache iso-build run copy remove

default: usage
