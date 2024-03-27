export VERSION = $(shell cat version)
V1 := $(awk '{ gsub(/^v/, ""); print }' <<< "$(VERSION)")
CHK_VERSION := $(awk -v n1="$(V1)" -v n2="2.7.0" -v n3="2.8" 'BEGIN { if (n1 >= n2 && n1 < n3) print n2; else print n1 }')

all: dep patch

dep:
	git submodule update --init --recursive
	git submodule update --force --remote
	git submodule foreach -q --recursive 'git reset --hard && git checkout ${VERSION}'

patch:
	bash -c "git clone --branch $(VERSION) https://github.com/goharbor/harbor.git"
	cd harbor && sh -c "curl https://github.com/goharbor/harbor/compare/$(CHK_VERSION)...morlay:patch-$(CHK_VERSION).patch | git apply -v"