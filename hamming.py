parity_num = 0  # numero de bits de paridad que se adjuntaran
error_bit = 0  # guarda el indice de donde se encuentra el bit erroneo
list_ = []  # lista con nuestro codigo


def hamming(code):
    global parity_num
    global list_
    global error_bit

    parity_num = parity_bits(len(code))
    list_ = add_parity_bits(code)
    power = 1
    print(f'listOriginal_ {list_}')

    for i in range(parity_num):
        power = 2 ** i
        j = 1
        total = 0

        while j * power - 1 < len(list_):
            print(f'power {power}')
            if j * power - 1 == len(list_) - 1:
                lower_index = j * power - 1
                tmp = list_[lower_index: len(list_)]
            elif (j + 1) * power - 1 >= len(list_):
                lower_index = j * power - 1
                tmp = list_[lower_index: len(list_)]
            elif (j + 1) * power - 1 < len(list_) - 1:
                lower_index = j * power - 1
                upper_index = (j + 1) * power - 1
                tmp = list_[lower_index: upper_index]

            total += sum(int(k) for k in tmp)
            j += 2
        if total % 2 > 0:
            list_[power - 1] = 1
            error_bit += power  # en este bit esta el error
    return list_


# retorna la cantidad de bits que se agregaran
def parity_bits(bits):
    power = 0
    while 2**power <= bits + 1:
        power += 1

    return power


# añade los pbits de paridad
def add_parity_bits(code):
    global parity_num
    power = 0  # num de paridad
    aux = 0  # num de bits
    aux_list = []

    for i in range(parity_num + len(code)):
        if i == 2 ** power - 1:
            aux_list.insert(i, 0)
            power += 1
        else:
            aux_list.insert(i, code[aux])
            aux += 1

    return aux_list


# cambia el objeto en el indice del bit erroneo
def error_solve():
    global parity_num
    global error_bit
    global list_

    if error_bit >= 1:
        if list_[error_bit - 1] == '0' or list_[error_bit - 1] == 0:
            list_[error_bit - 1] = 1
        else:
            list_[error_bit - 1] = 0


# script entry point
if __name__ == "__main__":
    code = '1011'
    hamming_ = hamming(code)

    hamming_str = ''.join(map(str, hamming_))
    print(hamming_str)
