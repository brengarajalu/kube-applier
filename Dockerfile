# kubectl wrapper uses python 2.7
FROM box-registry.jfrog.io/jenkins/box-sl6-python:2.7.x

LABEL com.box.name="kube-applier"

ADD build/kube-applier /
ADD build/templates /templates
ADD build/static /static
ADD kubectl /

# Need Git version 1.8.5+ for use of -C flag
# Specify 2.7.0 to avoid using a cached earlier version
RUN yum install -y --enablerepo=box-apps-stable-sl6 git-2.7.0

RUN yum install -y --enablerepo=box-apps-stable-sl6 kubernetes-kubectl-1.4.7-60.2017_01_11_16_21_59.54024.x86_64

# Extend the path so that the kube-applier ends up using the kubectl wrapper script.
# TODO: Naming the wrapper also kubectl may be confusing and difficult to maintain.
# If we are going to deploy this wrapper to other hosts, its name probably should be
# changed to something descriptive like kubectl-15-apply-workaround.
ENV PATH="/:${PATH}"

