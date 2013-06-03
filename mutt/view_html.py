#!/usr/bin/python2

# Requires python2-cchardet

import cchardet
from sys import argv
from subprocess import check_output

path = argv[1]
msg = file(path).read()
enc = cchardet.detect(msg)
enc = enc['encoding']

out = check_output("iconv -f " + enc + " -t UTF8 " + path + " | pandoc -f html -t markdown", shell=True)

print(out)
