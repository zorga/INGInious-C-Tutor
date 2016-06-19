FROM ingi/inginious-c-cpp

RUN yum -y install python-devel graphviz graphviz-devel
RUN pip install pygraphviz
RUN yum -y install openssh-clients

