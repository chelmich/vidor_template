#!/usr/bin/env python3

# A program to reverse the bytes of a quartus generated bitstream for use
# programming the MKR Vidor 4000 board with the Arduino IDE.
#
# Among the files in the output folder from quartus there is a .ttf bitstream
# that contains comma delimited bytes represented in decimal. This program
# flips those bytes bitwise. For example 105 (0b01101001) becomes 150
# (0b10010110).

import sys

def reverse(num):
    binary = bin(num)

    reverse = binary[:1:-1]
    reverse += (8 - len(reverse))*'0'

    return int(reverse, 2)

def main():
    if len(sys.argv) != 3:
        print('Usage: ./ReverseByte.py <input file> <output file>')
        sys.exit(1)

    inName = sys.argv[1]
    outName = sys.argv[2]

    print('Reversing bytes from ' + inName + ' and outputting to ' + outName)

    fpIn = open(inName, 'r')
    fpOut = open(outName, 'w')

    for line in fpIn:
        nums = [int(i.strip()) for i in line.split(',') if i != '\n']
        out = ''

        for i in nums:
            out += str(reverse(i)) + ','

        out += '\n'

        fpOut.write(out)

    fpIn.close()
    fpOut.close()

if __name__ == '__main__':
    main()
