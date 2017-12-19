#!/usr/bin/python

import sys
import os


def build_table(args):
    '''takes input a list of folders of each experiment containing
    files of the GT counting
    '''

    header = "PF\tAD\tAF\t0/0-0/1\t0/1-0/1\t0/1-1/1\t1/1-0/1"

    table_count = header + "\n"

    for i in range(len(args)):
        row = ""
        path = args[i][:-1].split("/")
        param = path[len(path)-1].split("_")
        row = "\t".join(param) + "\t5%\t"

        f_count = os.path.join(args[i], "GT_count.txt")

        for line in open(f_count, 'r'):
            row += line.strip().split()[0] + "\t"
        table_count += row + "\n"

    open("gt_table.txt", 'w').writelines(table_count)


if __name__ == "__main__":
    build_table(sys.argv[1:])
