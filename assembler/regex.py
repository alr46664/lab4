#!python

import re

# classe que define como as expressoes regulares serao usadas
class Regex(object):

	# cria um regex que da match se o texto comeca ou contem a 
	# palavra begin
	@staticmethod
	def createBeginWith(begin):
		return r'(^[ \t]*|(?<=[\r\n])[ \t]*)%(begin)s\b' % {'begin': begin}		
		# return r'^[%(begin)s)(?!\S)' % {'begin': begin}

	# cria um regex que da match se o texto contem a palavra
	# begin
	@staticmethod
	def createHasWord(begin):
		return r'(\b%(begin)s|^%(begin)s)\b' % {'begin': begin}				
		# return r'((?<=\s)%(begin)s|^%(begin)s)(?!\S)' % {'begin': begin}		

	def __init__(self, flags=0):
		# defina os regex para serem substituidos		
		self._flags = flags
		self._regexReplace = {}	
		self.fmt = {
			'alpha': r'[a-zA-Z]',
			'alphanum': r'[a-zA-Z0-9]',
			'reg': r'r[0-9]{1,2}'
			}

	# substitui as entradas definidas em name, por text
	def split(self, delimiters, text):
		return re.split(r'[%s]' % (delimiters), text, flags=self._flags)

	# substitui as entradas definidas em name, por text
	def replace(self, name, text):
		if (name not in self._regexReplace):
			return ''
		regexObj = self._regexReplace[name]
		return regexObj['regex'].sub(regexObj['repl'], text)
	
	# adiciona uma nova entrada em regexReplace
	def add(self, name, regex, repl):
		self._regexReplace[name] = {
			'regex': re.compile(regex % self.fmt, flags=self._flags),
			'repl':  repl % self.fmt
		}
	
	# esta funcao executa os regexes em ordem
	def run(self, text):	
		for name in self._regexReplace:			
			text = self.replace(name, text)
		return text