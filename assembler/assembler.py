#!python

# imports do sistema do python
import sys
import re

# criados por nos
from instructions import Instructions
from registers import Registers

instr = Instructions()	
regs = Registers()	

def parse_immediate(line):
	line = line.split()
	for i, token in enumerate(line):				
		if (i == 0 or token[0] == 'r'):
			continue
		word_size = (5 if i < 3 else 16)
		line[i] = '0'*(word_size-len(token)) + token
	return ' '.join(line)

# faz o parse da linha do arquivo asm
def parse(line):
	# a ordem dessas expressoes importa!
	line = re.sub(r'[\n\r]', '', line)
	# parse das instrucoes
	line = instr.run(line)
	# parse dos numeros inteiros para 16 bits	
	line = parse_immediate(line)	
	# parse dos registradores
	line = regs.run(line)
	print(line)	
	line = re.sub(r'\s', r'', line)	
	return line+'\n' if line != '' else ''

# perform checks to see if all is good
if __name__ == "__main__":		
	# print('ok')
	if len(sys.argv) != 3:
		print('\nERRO: Programa precisa de 2 arquivos: "inputfile.asm" , "outputfile.bin".\n\nSINTAXE:\nassembler.py inputfile.asm outputfile.bin')
		exit(1)	
	inFilename, outFilename = sys.argv[1], sys.argv[2]
	inFile = outFile = None
	with open(inFilename, 'r') as inFile:		
		with open(outFilename, 'w') as outFile:
			outStream = map(parse,inFile.readlines())
			outFile.writelines(outStream)		
			# print(outStream)
			print('\nArquivo "%s" realizado com SUCESSO' % (outFilename))			

