#!/usr/bin/python

# Python script that takes an EXE file, automatically figures out all the DLL dependencies,
# and copies them next to the EXE.
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Martin Preisler <martin at preisler dot me>
# Copyright (c) 2016 Gilles Caulier <caulier dot gilles at gmail dot com>
#
# Blog post         : https://martin.preisler.me/2015/03/mingw-bundledlls-automatically-bundle-dlls/
# Github repository : https://github.com/mpreisler/mingw-bundledlls
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import subprocess
import os.path
import argparse
import shutil
import string

# -----------------------------------------------

# The mingw pathes matches in MXE build directory
default_path_prefixes = [ 
    os.getcwd() + "/build/usr/i686-w64-mingw32.shared/qt5/bin/", 
    os.getcwd() + "/build/usr/x86_64-w64-mingw32.shared/qt5/bin/", 
    os.getcwd() + "/build/usr/i686-w64-mingw32.shared/bin/", 
    os.getcwd() + "/build/usr/x86_64-w64-mingw32.shared/bin/"
]

# Blacklist of native Windows dlls (may need extending)
blacklist = [
    "advapi32.dll",
    "kernel32.dll", 
    "msvcrt.dll", 
    "ole32.dll", 
    "user32.dll",
    "ws2_32.dll", 
    "comdlg32.dll", 
    "gdi32.dll", 
    "imm32.dll", 
    "oleaut32.dll",
    "shell32.dll", 
    "winmm.dll", 
    "winspool.drv", 
    "wldap32.dll",
    "ntdll.dll", 
    "d3d9.dll", 
    "mpr.dll", 
    "crypt32.dll", 
    "dnsapi.dll",
    "shlwapi.dll", 
    "version.dll", 
    "iphlpapi.dll", 
    "msimg32.dll",
    "netapi32.dll",
    "userenv.dll",
    "opengl32.dll",
    "secur32.dll",
    "psapi.dll",
    "wsock32.dll",
    "setupapi.dll",
    "avicap32.dll",
    "avifil32.dll",
    "comctl32.dll",
    "msvfw32.dll",
]

# -----------------------------------------------

def find_full_path(filename, path_prefixes):

    path = None
    #print(filename)

    for path_prefix in path_prefixes:
        path_candidate1 = os.path.join(path_prefix, filename)
        #print(path_candidate1)

        if os.path.exists(path_candidate1):
            path = path_candidate1
            #print("Found")
            break

        path_candidate2 = os.path.join(path_prefix, filename.lower())
        #print(path_candidate2)

        if os.path.exists(path_candidate2):
            path = path_candidate2
            #print("Found")
            break

    if path is None:
        raise RuntimeError(
            "Can't find " + filename + ". If it is an inbuilt Windows DLL, "
            "please add it to the blacklist variable in the script and send "
            "a pull request!")

    return path

# -----------------------------------------------

def gather_deps(path, path_prefixes, seen):

    ret    = [path]
    output = subprocess.check_output(["objdump", "-p", path]).decode('utf-8').split("\n")

    for line in output:

        if not line.startswith("\tDLL Name: "):
            continue

        dep  = line.split("DLL Name: ")[1].strip()
        ldep = dep.lower()

        #print("Searching: " + ldep)

        if ldep in blacklist:
            continue

        if ldep in seen:
            continue

        dep_path = find_full_path(dep, path_prefixes)
        seen.extend([ldep])
        subdeps  = gather_deps(dep_path, path_prefixes, seen)

        ret.extend(subdeps)

    return ret

# -----------------------------------------------

def main():

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "exe_file",
        help = "EXE or DLL file that you need to bundle dependencies for"
    )

    parser.add_argument(
        "--copy",
        action = "store_true",
        help   = "In addition to printing out the dependencies, also copy them next to the exe_file"
    )

    parser.add_argument(
        "--upx",
        action = "store_true",
        help   = "Only valid if --copy is provided. Run UPX on all the DLLs and EXE. See https://en.wikipedia.org/wiki/UPX for details"
    )

    args = parser.parse_args()

    if args.upx and not args.copy:
        raise RuntimeError("Can't run UPX if --copy hasn't been provided.")

    print("Scan dependencies for " + args.exe_file + "\n")

    all_deps = set(gather_deps(args.exe_file, default_path_prefixes, []))
    all_deps.remove(args.exe_file)

    print("\n".join(all_deps))

    if args.copy:

        print("Copying enabled, will now copy all dependencies near to the exe file.\n")

        parent_dir = os.path.dirname(os.path.abspath(args.exe_file))

        for dep in all_deps:
            target = os.path.join(parent_dir, os.path.basename(dep))
            print("Copying '%s' to '%s'" % (dep, target))
            shutil.copy(dep, parent_dir)

            if args.upx:
                subprocess.call(["upx", target])

# -----------------------------------------------

if __name__ == "__main__":
    main()
