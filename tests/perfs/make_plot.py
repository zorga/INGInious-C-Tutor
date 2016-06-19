#!/usr/bin/env python2.7

import argparse
import csv
import matplotlib.pyplot as plt
import numpy as np

TOTAL=20

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("csv_file", help=" a .csv file")
  parser.add_argument("plot_name", help="name of the plot")
  args = parser.parse_args()
  filename = args.csv_file
  plotname = args.plot_name + ".png"

  # x -> number of mallocs
  # y -> execution time in milliseconds
  x,y = np.loadtxt(filename, delimiter=",", unpack=True)

  # Compute average time:
  total = sum(y)
  average = total / TOTAL
  print("Average running time : " + str(average))

  fig = plt.figure()
  plt.plot(x, y)

  if (args.plot_name == "valgrind_measure"):
    #plt.axis([0, TOTAL, 0, 5000])
    plt.axis([0, TOTAL, 0, 10000])
  elif (args.plot_name == "trace_measure"):
    plt.axis([0, TOTAL, 0, 10000])
  elif (args.plot_name == "graph_measure"):
    plt.axis([0, TOTAL, 0, 100000])
  else:
    plt.axis([0, TOTAL, 0, 100000])

  plt.xlabel("Amount of dynamically allocated node struct")
  plt.ylabel("Running time (ms)")
  fig.savefig(plotname)

if __name__ == '__main__':
  main()
