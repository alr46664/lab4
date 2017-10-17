#!python

import re
from regex import Regex

# expressoes regulares das instrucoes do processador
class Instructions(Regex):

	def __init__(self):
		super(Instructions, self).__init__(flags=re.IGNORECASE)
		# defina as instrucoes do processador e o opcode de cada uma
		regex_op = {
			'nop':(r'[ \t]*%(op)s',
				r'%(opcode)s r0 r0 0'),
			'imm':(r'[ \t]*%(op)s[ \t]*([0-9]+)',
				r'%(opcode)s r0 r0 \1'),
			'reg':(r'[ \t]*%(op)s[ \t]*(%(reg)s)',
				r'%(opcode)s \1 r0 0'),
			'reg_imm': (r'[ \t]*%(op)s[ \t]*(%(reg)s)[ \t]*,[ \t]*([0-9]+)',
				r'%(opcode_imm)s \1 r0 \2'),
			'reg_reg': (r'[ \t]*%(op)s[ \t]*(%(reg)s)[ \t]*,[ \t]*(%(reg)s)',
				r'%(opcode)s \1 \2 0'),
			'reg_reg_imm': (r'[ \t]*%(op)s[ \t]*(%(reg)s)[ \t]*,[ \t]*([0-9]+)\((%(reg)s)\)',
				r'%(opcode)s \1 \3 \2')
		}

		self.fmt['op']         = 'lw'
		self.fmt['opcode']     = '000000'
		self.fmt['opcode_imm'] = '010000'
		self.add('lw_imm',      regex_op['reg_imm'][0],     regex_op['reg_imm'][1])
		self.add('lw_base',     regex_op['reg_reg'][0],     regex_op['reg_reg'][1])
		self.add('lw_base_imm', regex_op['reg_reg_imm'][0], regex_op['reg_reg_imm'][1])

		self.fmt['op']     = 'sw'
		self.fmt['opcode'] = '000001'
		self.add('sw_base',     regex_op['reg_reg'][0],     regex_op['reg_reg'][1])
		self.add('sw_base_imm', regex_op['reg_reg_imm'][0], regex_op['reg_reg_imm'][1])

		self.fmt['op']     = 'add'
		self.fmt['opcode'] = '000010'
		self.add('add_base',  regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'sub'
		self.fmt['opcode'] = '000011'
		self.add('sub_base',  regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'mul'
		self.fmt['opcode'] = '000100'
		self.add('mul_base',  regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'div'
		self.fmt['opcode'] = '000101'
		self.add('div_base',  regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'and'
		self.fmt['opcode'] = '000110'
		self.add('and_base',  regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'or'
		self.fmt['opcode'] = '000111'
		self.add('or_base',   regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'not'
		self.fmt['opcode'] = '001000'
		self.add('not_base',  regex_op['reg'][0],         regex_op['reg'][1])

		self.fmt['op']     = 'cmp'
		self.fmt['opcode'] = '001001'
		self.add('cmp_base',  regex_op['reg_reg'][0],     regex_op['reg_reg'][1])

		self.fmt['op']     = 'jr'
		self.fmt['opcode'] = '001010'
		self.add('jr_base',   regex_op['reg'][0],         regex_op['reg'][1])

		self.fmt['op']     = 'jpc'
		self.fmt['opcode'] = '001011'
		self.add('jpc_base',  regex_op['imm'][0],         regex_op['imm'][1])

		self.fmt['op']     = 'brfl'
		self.fmt['opcode'] = '001100'
		self.add('brfl_base',
			r'[ \t]*%(op)s[ \t]*(%(reg)s)[ \t]*,[ \t]*([0-9]+)[ \t]*,[ \t]*([0-9]+)',
			r'%(opcode)s \1 \3 \2')

		self.fmt['op']     = 'call'
		self.fmt['opcode'] = '001101'
		self.add('call_base', regex_op['reg'][0],         regex_op['reg'][1])

		self.fmt['op']     = 'ret'
		self.fmt['opcode'] = '001110'
		self.add('ret_base', regex_op['nop'][0],         regex_op['nop'][1])

		self.fmt['op']     = 'nop'
		self.fmt['opcode'] = '001111'
		self.add('nop_base', regex_op['nop'][0],         regex_op['nop'][1])

		self.fmt['op']     = 'eof'
		self.fmt['opcode'] = '111111'
		self.add('eof_base', regex_op['nop'][0],         regex_op['nop'][1])
