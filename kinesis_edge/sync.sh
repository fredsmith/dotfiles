#! /usr/bin/env bash

sudo mount /dev/disk/by-label/FS\\x20EDGE /mnt || exit
sudo rsync -av --no-owner --no-group config/ /mnt
sudo umount /dev/disk/by-label/FS\\x20EDGE

