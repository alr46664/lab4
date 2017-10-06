#!python

import re

# expressoes regulares dos opcodes do processador
regex = {
	'load': re.compile(r'lw')
}

# run main function
if __name__ == "__main__":
	print(regex['load'].sub('ok', 'test lw'))
	print('ok')

