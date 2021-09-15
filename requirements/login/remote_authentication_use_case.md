# Remote Authentication Use Case

> ## Case de Sucesso

1. ✅ Sistema valida os dados
2. ✅ Sistema faz uma requisição para a URL da API de Login
3. ✅ Sistema valida os dados recebidos da API
4. ✅ Sistema entrega os dados da conta do usuário

> ## Exceção - URL inválida

1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Dados inválidos

1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Resposta inválida

1. Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Falha no servidor

1. ✅ Sistema retorna uma mensagem de erro inesperado

> ## Exceção - Credenciais inválidas

1. Sistema retorna uma mensagem de erro informando que as credenciais estão erradas
