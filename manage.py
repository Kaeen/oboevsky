#!/usr/bin/env python
import os
import sys

sys.path = ['/home/kaeen/webapps/oboevsky/lib/python2.7',] + sys.path
os.environ.setdefault("OBOEVSKY_SERVER", "stage")

if __name__ == "__main__":
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "oboevsky.settings")

    from django.core.management import execute_from_command_line

    execute_from_command_line(sys.argv)
