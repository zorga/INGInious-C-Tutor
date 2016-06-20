# INGInious-C-Tutor
This is the code of the tool used to build extended feedbacks on the students submissions for the INGInious platform developed at UCL.
The tool was developed in the context of my Master Thesis. It was originally forked from the Github [opt-cpp-backend](https://github.com/pgbovine/opt-cpp-backend) project of pgbovine.

This project is intended to be used inside the [INGInious](https://github.com/UCL-INGI/INGInious) platform. A sample `run` file is provided in order to show how to use the tool with INGInious tasks. This `run` file is similar to those described in the [INGInious documentation](http://inginious.readthedocs.io/en/latest/teacher_doc/run_file.html). A `Dockerfile` is also provided to build the required Docker image to use the tool in the platform.
The tool could also be used outside INGInious with an arbitrary C program. However, the feedback pages are located on a web-server only reachable from the INGI department of UCL. That is a temporary solution. 

The graphs can be generated using the `generate_feedback.sh` script. But still, to be able to build the feedback pages, it is required to be a member of the INGI department to have access to the web server.

**Dependencies :**
- Python 2.7

