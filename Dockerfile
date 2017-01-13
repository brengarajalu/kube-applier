FROM docker-registry-vip.dev.box.net/jenkins/box-sl6

LABEL com.box.name="kube-applier"

ADD build/kube-applier /
ADD build/templates /templates
ADD build/static /static

# Need Git version 1.8.5+ for use of -C flag
# Specify 2.7.0 to avoid using a cached earlier version
RUN yum install -y --enablerepo=box-apps-stable-sl6 git-2.7.0

RUN yum install -y --enablerepo=box-apps-stable-sl6 kubernetes-kubectl-1.3.9-51.2016_10_26_10_13_53.3b973.x86_64
