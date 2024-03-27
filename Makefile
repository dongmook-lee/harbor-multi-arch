export VERSION = $(shell cat version)

all: dep patch

dep:
	git submodule update --init --recursive
	git submodule update --force --remote
	git submodule foreach -q --recursive 'git reset --hard && git checkout ${VERSION}'

patch:
	echo "version = $(VERSION)"
	cd harbor && sh -c "curl https://github.com/goharbor/harbor/compare/$(VERSION)...morlay:patch-$(VERSION).patch | git apply -v"
	# bash -c "git clone --branch $(VERSION) https://github.com/goharbor/harbor.git"
