#!/bin/sh
ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1