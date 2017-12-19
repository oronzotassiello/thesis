#!/usr/bin/python

import sys
import os
from scipy import stats


def ranking(args):
    '''takes input a list of folders of each experiment containing
    files of the GT counting
    '''
    x_ = list(map(int, open(args[0], 'r').readlines()))
    y_ = list(map(int, open(args[1], 'r').readlines()))

    x, y = normalize(x_, y_)

    rho, pval = stats.spearmanr(x, y)
    tau, pval_k = stats.kendalltau(x, y)
    pcc, pval_p = stats.pearsonr(x, y)

    print ("==>spearman")
    print (rho, pval)
    print ("==>kendalltau")
    print (tau, pval_k)
    print ("==>pearson")
    print (pcc, pval_p)

def normalize(list_a, list_b):
    len_a = len(list_a)
    len_b = len(list_b)

    if len_a > len_b:
        list_b.extend([0] * (len_a - len_b))
    elif len_a < len_b:
        list_a.extend([0] * (len_b - len_a))

    return list_a, list_b


if __name__ == "__main__":
    ranking(sys.argv[1:])
