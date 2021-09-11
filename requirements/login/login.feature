Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responder enquetes de forma rápida e fácil

Cenário: Credenciais Válidas
Dado que o cliente informou os dados corretos
Quando solicitar para fazer o login
Então o sistema deve enviar o usuário para tela de pesquisa
E manter o usuário logado

Cenário: Credenciais Inválidas
Dado que o cliente informou os dados incorretos
Quando solicitar para fazer o login
Então o sistema deve informar que as credenciais estão incorretas