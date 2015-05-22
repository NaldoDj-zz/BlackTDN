import os
import re

searchDir = 'C:/GitHub/BlackTDN/'
exclude = ['.git', 'node_modules','bin']
os.chdir(searchDir)

for root, dirs, files in os.walk(searchDir):
    dirs[:] = [d for d in dirs if d not in exclude]
    for f in files:
        if re.match(r'[A-Z]', f):
            fullPath = os.path.join(root, f)
            fullPathLower = os.path.join(root,f.lower())
            command = 'git mv --force ' + fullPath + ' ' + fullPathLower
            print(command)
            os.system(command)
