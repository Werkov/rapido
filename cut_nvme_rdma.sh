#!/bin/bash
#
# Copyright (C) SUSE LINUX GmbH 2017, all rights reserved.
#
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation; either version 2.1 of the License, or
# (at your option) version 3.
#
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
# License for more details.

RAPIDO_DIR="$(realpath -e ${0%/*})"
. "${RAPIDO_DIR}/runtime.vars"

KVER="`cat ${KERNEL_SRC}/include/config/kernel.release`" || exit 1
dracut --no-compress  --kver "$KVER" \
	--install "tail blockdev ps rmdir resize dd vim grep find df sha256sum \
		   strace mkfs.xfs /lib64/libkeyutils.so.1 killall nvme" \
	--include "$RAPIDO_DIR/nvme_rdma_autorun.sh" "/.profile" \
	--include "$RAPIDO_DIR/rapido.conf" "/rapido.conf" \
	--include "$RAPIDO_DIR/vm_autorun.env" "/vm_autorun.env" \
	--kmoddir "$KERNEL_SRC/mods" \
	--add-drivers "nvme-core nvme-fabrics nvme-rdma nvmet nvmet-rdma \
		       rdma_rxe zram lzo ib_core ib_uverbs rdma_ucm" \
	--no-hostonly --no-hostonly-cmdline \
	--modules "bash base network ifcfg" \
	--tmpdir "$RAPIDO_DIR/initrds/" \
	--force $DRACUT_OUT
