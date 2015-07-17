# Copyright (c) 2015 CoreOS, Inc.. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_PROJECT="coreos/coreos-metadata"
CROS_WORKON_LOCALNAME="coreos-metadata"
CROS_WORKON_REPO="git://github.com"
CARGO_HASH="0a35038f75765ae4"
EGIT_REPO_URI="https://github.com/rust-lang/crates.io-index.git"
EGIT_CHECKOUT_DIR="${WORKDIR}/.cargo/registry/index/github.com-${CARGO_HASH}"
inherit cros-workon git-r3 systemd

if [[ "${PV}" == 9999 ]]; then
	KEYWORDS="~amd64 ~arm64"
else
	CROS_WORKON_COMMIT=""
	KEYWORDS="amd64 arm64"
fi

DESCRIPTION="coreos-metadata"
HOMEPAGE="https://github.com/coreos/coreos-metadata"

crate_uris() {
	while (( "$#" )); do
		local name version
		name="${1%-*}"
		version="${1##*-}"
		echo "https://crates.io/api/v1/crates/${name}/${version}/download -> ${1}.crate"
		shift
	done
}

CRATES="
	advapi32-sys-0.1.2
	ansi_term-0.6.3
	bitflags-0.3.2
	clap-1.1.6
	cookie-0.1.21
	gcc-0.3.12
	hpack-0.2.0
	httparse-0.1.5
	hyper-0.6.8
	kernel32-sys-0.1.3
	language-tags-0.0.7
	lazy_static-0.1.14
	libc-0.1.8
	libressl-pnacl-sys-2.1.6
	log-0.3.1
	matches-0.1.2
	mime-0.1.0
	num_cpus-0.2.6
	openssl-0.6.4
	openssl-sys-0.6.4
	pkg-config-0.3.5
	pnacl-build-helper-1.4.10
	rand-0.3.9
	rustc-serialize-0.3.15
	solicit-0.4.1
	strsim-0.4.0
	tempdir-0.3.4
	time-0.1.32
	traitobject-0.0.1
	typeable-0.1.2
	unicase-0.1.0
	url-0.2.36
	winapi-0.2.1
	winapi-build-0.1.1
"

SRC_URI="
	$(crate_uris ${CRATES})
"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	dev-lang/rust-bin
"

src_unpack() {
	cros-workon_src_unpack
	git-r3_src_unpack

	CRATE_DIR="${WORKDIR}/.cargo/registry/cache/github.com-${CARGO_HASH}"
	mkdir --parent "${CRATE_DIR}" || die
	for archive in ${A}; do
		cp "${DISTDIR}/${archive}" "${CRATE_DIR}" || die
	done
}

src_compile() {
	CARGO_HOME="${WORKDIR}/.cargo" cargo build \
		--release --verbose --no-default-features || die
}

src_install() {
	systemd_dounit "${FILESDIR}/coreos-metadata.service"
}
