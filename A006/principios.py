import datetime
import math
from typing import List

# class Pessoa:
#     def __init__(
#             self,
#             nome: str,
#             sobrenome: str, 
#             data_de_nascimento: datetime.date) -> None:
#         self.data_de_nascimento = data_de_nascimento
#         self.sobrenome = sobrenome
#         self.nome = nome
    
#     @property
#     def idade(self) -> int:
#         return math.floor((datetime.date.today() - self.data_de_nascimento).days / 365.2425)
    
#     def __str__(self) -> str:
#         return f"{self.nome} {self.sobrenome} tem {self.idade} anos"

# class Curriculo:
#     def __init__(self, pessoa: Pessoa, experiencias: List[str]):
#         self.experiencias = experiencias
#         self.pessoa = pessoa
    
#     @property
#     def quantidade_de_experiencias(self) -> int:
#         return len(self.experiencias)
    
#     @property
#     def empresa_atual(self) -> str:
#         return self.experiencias[-1]
    
#     def adiciona_experiencia(self, experiencia: str) -> None:
#         self.experiencias.append(experiencia)

#     def __str__(self):
#         return f"{self.pessoa.nome} {self.pessoa.sobrenome} tem {self.pessoa.idade} anos e já " \
#             f"trabalhou em {self.quantidade_de_experiencias} empresas e atualmente trabalha " \
#             f"na empresa {self.empresa_atual}"


# louise = Pessoa(nome='Louise', sobrenome='Castro', data_de_nascimento=datetime.date(1995, 1, 24))
# print(louise)
        
# curriculo_louise = Curriculo(
#     pessoa=louise, experiencias=['Fisk', 'Centro Britânico', 'Cultura Inglesa', 'Conquer', 'Qexpert']
# )

# print(curriculo_louise.pessoa.idade)

# curriculo_louise.adiciona_experiencia("L'occitane")
# print(curriculo_louise)


class Vivente:
    def __init__(self, nome: str, data_de_nascimento: datetime.date) -> None:
        self.nome = nome
        self.data_de_nascimento = data_de_nascimento

    @property
    def idade(self) -> int:
        return math.floor((datetime.date.today() - self.data_de_nascimento).days / 365.2425)

    def emite_ruido(self, ruido: str):
        print(f"{self.nome} fez ruido: {ruido}")

class PessoaHeranca(Vivente):
    def __str__(self) -> str:
        return f"{self.nome} tem {self.idade} anos"

    def fala(self, frase):
        return self.emite_ruido(frase)

class Cachorro(Vivente):
    def __init__(self, nome: str, data_de_nascimento: datetime.date, raca: str) -> None:
        super().__init__(nome, data_de_nascimento)
        self.raca = raca


    def __str__(self) -> str:
        return f"{self.nome} é da raça {self.raca} e tem {self.idade} anos"

    def late(self):
        return self.emite_ruido("Au au!")
    

louise2 = PessoaHeranca(nome='Louise', data_de_nascimento=datetime.date(1995, 1, 24))
print(louise2)

naomi = Cachorro(nome='Naomi', data_de_nascimento=datetime.date(2019, 4, 1), raca='Linguiça')
print(naomi)

naomi.late()
naomi.late()
naomi.late()
naomi.late()
louise2.fala("Cala Boca, Naomi!")
naomi.late()