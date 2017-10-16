#!python

# imports do sistema do python
import sys
import re

# criados por nos
from instructions import Instructions
from registers import Registers

instr = Instructions()
regs = Registers()

# parse dos registradores
def parse_immediate(line):
	line = line.split()
	for i, token in enumerate(line):
		# ignore a instrucao e os registradores,
		# processe somente numeros decimais
		# (imediatos e numeros crus)
		if (i == 0 or token[0] == 'r'):
			continue
		# verifique o tamanho final das palavra
		word_size = (5 if i < 3 else 16)
		# altere o token (que e um numero)
		token = bin(int(token))[2:]
		# faca o prepend de zeros na frente do token pra que
		# ele tenha o tamanho correto
		line[i] = '0'*(word_size-len(token)) + token
	return ' '.join(line)

# ajuste a ordem da instrucao para o Verilog [MSB:LSB]
def binary_order_adjust(line):
	line = line.split()
	line.reverse()
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
	# ajuste a ordem da instrucao para o Verilog [MSB:LSB]
	line = binary_order_adjust(line)
	# remova os espacos em branco
	line = re.sub(r'\s', r'', line)
	# ignore as linhas em branco, e coloque um
	# \n nas nao nulas
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

