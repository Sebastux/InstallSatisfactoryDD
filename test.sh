#!/bin/bash
# -*- coding: utf-8 -*-

source ./venv/bin/activate

ansible-playbook ./site.yml -i ./staging/ --flush-cache --tags "toto"

deactivate
