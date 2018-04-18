# kubectl wrapper uses python 2.7
FROM box-registry.jfrog.io/jenkins/box-sl6-python:2.7.x

LABEL com.box.name="kube-applier"

ADD build/kube-applier /
ADD build/templates /templates
ADD build/static /static

# Need Git version 1.8.5+ for use of -C flag
# Specify 2.7.0 to avoid using a cached earlier version
RUN yum install -y --enablerepo=box-apps-stable-sl6 git-2.7.0

RUN yum install -y --enablerepo=box-apps-stable-sl6 kubernetes-kubectl-1.6.13-75.2017_11_30_21_49_24.cd28b.x86_64

RUN yum install -y --enablerepo=box-apps-stable-sl6 python-kubectlwrapper-0.0.3-5

# Extend the path so that the kube-applier ends up using the kubectl wrapper script.
# Wrapper script is installed at /box/bin/kubectl as defined in the RPM spec.
ENV PATH="/box/bin/:${PATH}"

