# -*- coding: utf-8 -*-
"""
Created on Sun Oct 18 12:33:57 2020

@author: USER
"""

import os
import zipfile

os.chdir("C:\\Users\\USER\\Nextcloud\\Hard drive\\Windows Current\\Blog\\FFIEC Post\\FFIEC_Data")
zipfile_list = os.listdir()

def zip_fun(file_path):
    zipfile.ZipFile(file = file_path).extractall()
    
[zip_fun(x) for x in zipfile_list]


# Note: Use bash command to put txt files into directory.
