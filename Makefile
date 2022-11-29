############################################################################
##
##     This file is part of Purdue CS 536.
##
##     Purdue CS 536 is free software: you can redistribute it and/or modify
##     it under the terms of the GNU General Public License as published by
##     the Free Software Foundation, either version 3 of the License, or
##     (at your option) any later version.
##
##     Purdue CS 536 is distributed in the hope that it will be useful,
##     but WITHOUT ANY WARRANTY; without even the implied warranty of
##     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##     GNU General Public License for more details.
##
##     You should have received a copy of the GNU General Public License
##     along with Purdue CS 536. If not, see <https://www.gnu.org/licenses/>.
##
#############################################################################

####################################################################
############### Set up Mininet and Controller ######################
####################################################################

SCRIPTS = ./scripts

export bw ?= 100

.PHONY: mininet mininet-monut controller cli netcfg host-h1 host-h2

mininet:
	$(SCRIPTS)/mn-stratum

# Set Maximum Bandwidth between 0 - 1000
# ex: 100 -> 100 Mbps
mininet-bandwidth:
	$(SCRIPTS)/mn-stratum --link=tc,bw=$(bw)

mininet-prereqs:
	docker exec -it mn-stratum bash -c \
		"echo deb http://deb.debian.org/debian buster main non-free contrib > /etc/apt/sources.list.d/test.list ; \
		 apt-get update ; \
		 apt-get install libgtk-3-0 libnss3-tools libc6 iptraf -y ; \
		 apt-get install /workdir/google-chrome-stable_current_amd64.deb -y ; \
		 mkdir -p /workdir/.pki/nssdb ; \
		 certutil -d /workdir/.pki/nssdb -N --empty-password ; \
		 certutil -d sql:/workdir/.pki/nssdb -A -t "C,," -n quic_cert -i /workdir/quic/certs/2048-sha256-root.pem ; \
		 mkdir -p /var/run/dbus ; \
		 dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address"

controller:
	ONOS_APPS=gui,proxyarp,drivers.bmv2,lldpprovider,hostprovider \
	$(SCRIPTS)/onos

cli:
	$(SCRIPTS)/onos-cli

netcfg:
	$(SCRIPTS)/onos-netcfg cfg/netcfg.json

host-h1:
	$(SCRIPTS)/utils/mn-stratum/exec h1

host-h2:
	$(SCRIPTS)/utils/mn-stratum/exec h2

quic-server:
	$(SCRIPTS)/utils/mn-stratum/exec-d-script h2 \
		"./quic/Quic/quic_server --quic_response_cache_dir=www.example.org --certificate_file=quic/out/leaf_cert.pem --key_file=quic/out/leaf_cert.pkcs8"
