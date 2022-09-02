import datetime
import math

class Pessoa:
    def __init__(self, nome: str, sobrenome: str, data_de_nascimento: datetime.date):
        self.data_de_nascimento = data_de_nascimento
        self.sobrenome = sobrenome
        self.nome = nome
    
    @property
    def idade(self) -> int:
        return math.floor((datetime.date.today() - self.data_de_nascimento).days / 365.2425)
    
    def __str__(self) -> str:
        return f"{self.nome} {self.sobrenome} tem {self.idade} anos"
        
louise = Pessoa(nome='Louise', sobrenome='Castro', data_de_nascimento=datetime.date(1995, 1, 24))

print(louise)
print(louise.nome)
print(louise.sobrenome)
print(louise.data_de_nascimento)
print(louise.idade)