#!python

import re
from regex import Regex

# expressoes regulares dos registradores do processador
class Registers(Regex):
	
	def __init__(self):
		super(Registers, self).__init__(flags=re.IGNORECASE)
		# defina os registradores do processador
		for reg in xrange(32):
			reg_bin = bin(reg)[2:]
			reg_bin = '0'*(5 - len(reg_bin)) + reg_bin
			self.add('r' + str(reg), r'\br%d\b' % reg, reg_bin)							