# -*- encoding: utf-8 -*-
# Author: Epix
import re

r = re.compile(r'^    S:(.*\.name)=(.*)')
with open('GregTech.lang', 'r') as fin:
    with open('GregTech.table', 'w') as fout:
        for line in fin:
            m = r.match(line)
            if m:
                pass
                k, v = m.groups()
                fout.write('{}={}\n'.format(k, v))
