#!/bin/bash
# -*- coding: utf-8 -*-

clear
ansible-playbook ./site.yml -i ./staging/ --flush-cache
