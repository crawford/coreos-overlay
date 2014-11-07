# Copyright 2014 VMware
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="A library for Microsoft compression formats"
HOMEPAGE="http://www.cabextract.org.uk/libmspack/"
SRC_URI="http://www.cabextract.org.uk/libmspack/libmspack-0.4alpha.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="static-libs test"

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}alpha

src_configure() {
       # Install into OEM, don't bother with a sbin directory.
       econf \
               --prefix=/usr/share/oem \
               --sbindir=/usr/share/oem/bin \
               $(use_enable static-libs static)
}

