import sys


def computeAverage(argv):
    '''computing average of pvalues over a list of file
    key value
    '''
    path_list = argv[0]
    key_index = int(argv[1])
    value_index = int(argv[2])

    d = {}
    for p in map(lambda t: t.strip(), open(path_list, 'r').readlines()):
        with open(p, 'r') as f:
            for line in f:
                k = line.split()[key_index]
                pval = float(line.split()[value_index])
                if k in d.keys():
                    d[k] = (d[k][0] + 1, d[k][1] + pval)
                else:
                    d[k] = (1, pval)
            f.close()

    for k in d.keys():
        print('{:s}\t{:4f}'.format(k, d[k][1]/d[k][0]))


if __name__ == "__main__":
    computeAverage(sys.argv[1:])
