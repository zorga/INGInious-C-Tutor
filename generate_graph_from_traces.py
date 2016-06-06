#!/usr/bin/env python2
"""
This is the implementation of the application translating the execution
trace files to beautiful graphs to be shown to the sinf1252 student on the
INGInious platform at UCL
"""
__author__  = "Nicolas Ooghe"

import sys
from pygraphviz import *
import json
from pprint import pprint
import llist_graph_utils as llist
import argparse

def get_exec_point_info (obj):
  info = {}
  info["heap"] = obj["heap"] 
  info["frame_name"] = obj["func_name"] 
  info["frames"] = obj["stack_to_render"]
  return info



def output_graph(graph, name):
  """
  A simple function to output the source-code of the produced graph
  and the image files containing the graphics

  Args:
    graph (graph_object): the final graph of the current execution point

    name (string): the name of the current graph
  """
  graph.layout(prog="dot")
  graph.draw("img/" + name + ".png")
  graph.write("dots/" + name + ".dot")
    


def main():
  # Command line parse to get the filename and to pass some options.
  parser = argparse.ArgumentParser()
  parser.add_argument("trace_filename", help="A path to a .trace file")
  parser.add_argument("-v", "--verbose", help="Explain what is being done",
    action="store_true")
  args = parser.parse_args()
  # print an error to stderr and return if the file is not a .trace file :
  if not args.trace_filename.endswith('.trace'):
    print >> sys.stderr, "Error : need a \".trace\" file !"
    return

  if (args.verbose):
    print("Opening " + args.trace_filename + " file...")
  with open(args.trace_filename) as trace_file:
    trace = json.load(trace_file)
    nTraces = len(trace["trace"])
    if (args.verbose):
      print("Generating graphics of " + str(nTraces) + " execution points...")
    i = 0
    # Get the useful informations from each exec point and put them into
    # the 'obj' list.
    # Then call the 'build_graph_from' function from 'llist_graph_utils' to
    # build the graphs of each exec point.
    for exec_point in trace["trace"]:
      if (args.verbose):
        print ("Processing exec point number " + str(i))
      obj = get_exec_point_info(exec_point)
      graph_file_name = "exec_point_" + str(i)
      # Getting the graph of the current exec point:
      # The following line can be replace by a graph script of your choice
      # depending on the type of C exercise you work with
      # Don't forget to import your module !
      exec_point_graph = llist.build_graph_from(obj)
      # Generating the image and dot files:
      output_graph(exec_point_graph, graph_file_name)
      i = i + 1

  sys.exit(0)

if __name__ == '__main__':
    main()

