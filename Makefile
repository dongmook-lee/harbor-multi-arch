export VERSION = $(shell cat version)
# V1 := $(shell echo "$(VERSION)" | awk '{ gsub(/^v/, ""); print }')
# V2 := "2.7.0"
# V3 := "2.8.0"
# CHK_VERSION := $(shell awk -v n1="$(V1)" -v n2="$(V2)" -v n3="$(V3)" 'BEGIN { if (n1 >= n2 && n1 < n3) print "v"$(V2); else print "$(VERSION)" }')

all: dep patch

dep:
	git submodule update --init --recursive
	git submodule update --force --remote
	git submodule foreach -q --recursive 'git reset --hard && git checkout ${VERSION}'

patch:
	bash -c "git clone --branch $(VERSION) https://github.com/goharbor/harbor.git"
	bash -c "cp -r template/harbor/v2.7.4/Makefile harbor/Makefile"
	bash -c "cp -r template/harbor/v2.7.4/make/photon/* harbor/make/photon/"
# cd harbor && sh -c "curl https://github.com/goharbor/harbor/compare/$(VERSION)...morlay:patch-$(CHK_VERSION).patch | git apply -v"
