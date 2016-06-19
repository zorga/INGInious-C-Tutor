#!/usr/bin/env python2.7

import argparse
import re
import csv

def main():
  parser = argparse.ArgumentParser()
  parser.add_argument("measurements_file", help="A path to data a valid data file")
  parser.add_argument("part", help="part of the software being tested. Ex: gcc")
  args = parser.parse_args()
  # execution time will be in 'tmp' list
  # tmp[0] -> User time
  # tmp[1] -> System time
  tmp = []
  # CSV file for results
  resultFileName = args.part + ".csv"
  resultFile = open(resultFileName, "w")
  writer = csv.writer(resultFile)
  i = 1
  
  with open(args.measurements_file) as mFile:
    for line in mFile:
      # CPU Time = User Time + System Time:
      tmp = re.findall("\d+\.\d+", line)
      user_time = float(tmp[0])
      system_time = float(tmp[1])
      # multiply by 1000 to get result in milliseconds
      cpu_time = (user_time + system_time) * 1000
      result = [i, cpu_time]
      writer.writerow(result)
      i = i + 1
  resultFile.close()
  
if __name__ == '__main__':
  main()
