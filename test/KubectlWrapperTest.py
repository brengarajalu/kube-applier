#!/usr/bin/env python2.7

# Verify that the kubectl command in bin works correctly.
# These tests needs to execute in an environment where the original kubectl command
# exists.

import os
import subprocess
import sys
import argparse
import subprocess
import tempfile

# Some hardcoded objects used in the tests as data.
namespace = """
{
   "apiVersion": "v1",
   "kind": "Namespace",
   "metadata": {
      "name": "skynet-tools-test-namespace"
   }
}
"""

pki = """
{
   "apiVersion": "box-pki.com/v1",
   "kind": "Pki",
   "metadata": {
      "name": "pki-skynet-tools-test-namespace",
      "namespace": "skynet-tools-test-namespace"
   },
   "spec": {
      "trusts": [
         {
            "services": []
         }
      ]
   }
}
"""

def extend_path():
    """Add the binary file directory in skynet-tools to the start of the PATH.
    In this test file we use the binaries in this repo. So they should be in
    the PATH if they were not """
    p = os.environ.get("PATH","")
    os.environ["PATH"] = os.path.abspath("../") + os.pathsep + p

def namespace_file():
    with tempfile.NamedTemporaryFile(delete=False) as f:
        f.write("\n---\n")
        f.write(namespace)
        f.write("\n---\n")
    return os.path.abspath(f.name)

def pki_file():
    with tempfile.NamedTemporaryFile(delete=False) as f:
        f.write("\n---\n")
        f.write(pki)
        f.write("\n---\n")
    return os.path.abspath(f.name)

def namespace_pki_file():
    with tempfile.NamedTemporaryFile(delete=False) as f:
        f.write("\n---\n")
        f.write(namespace)
        f.write("\n---\n")
        f.write(pki)
        f.write("\n---\n")
    return os.path.abspath(f.name)

def test_apply_with_file(p,additional_args):
    subprocess.check_call(["kubectl", "apply", "-f", p])
    subprocess.check_call(["kubectl", "apply", "-f", p] + additional_args)
    subprocess.check_call(["kubectl", "apply", "--filename",p])
    subprocess.check_call(["kubectl", "apply", "--filename",p] + additional_args)
    os.remove(p)

def main():
    extend_path()

    # Some other subcommand than apply is called
    subprocess.check_call(["kubectl", "cluster-info"])

    # kubectl is called without any parameters.
    subprocess.check_call(["kubectl"])

    # apply is called without any command line options. Wrong !
    try:
        subprocess.check_call(["kubectl", "apply"])
        assert not "Unexpected successful command completion"
    except subprocess.CalledProcessError as e:
        pass

    # apply is called with command line options but not -f. Something else. For
    # example -h
    subprocess.check_call(["kubectl", "apply", "-h"])


    # apply is called with -f option but the filename does not exist
    try:
        subprocess.check_call(["kubectl", "apply", "-f",
            "some_file_that_doesnt_exist"])
        assert not "Unexpected successful command completion"
    except subprocess.CalledProcessError as e:
        pass

    # apply is called with --filename option but the filename does not exist
    try:
        subprocess.check_call(["kubectl", "apply", "--filename",
            "some_file_that_doesnt_exist"])
        assert not "Unexpected successful command completion"
    except subprocess.CalledProcessError as e:
        pass

    # apply with a file name that exists, but the file does not contain any TPR's
    # Also pass additional command line params to make sure they are processed
    # correctly.
    fp = namespace_file()
    test_apply_with_file(fp,["--recursive=false"])

    # apply with a file that exists, the file only contains TPR's
    fp = pki_file()
    test_apply_with_file(fp,["--recursive=false"])

    # apply with a file that exists, the file contains both non-TPR and TPR
    fp = namespace_pki_file()
    test_apply_with_file(fp,["--recursive=false"])


if __name__=="__main__":
    main()

#
# Remaining Test Cases.
# The path contains multiple kubectl versions
# The path does not have any kubectl.
