#!/bin/bash
sed -i -e 's/\r$//' arch/*
chmod +x arch/*
exec arch/base-install.sh
