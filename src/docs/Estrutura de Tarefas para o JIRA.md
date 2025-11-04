# Estrutura de Tarefas para o JIRA

## Épico: Melhorias Estruturais no Middleware ForUP

**Descrição:** Implementar melhorias estruturais no projeto de middleware para aumentar a manutenibilidade, testabilidade e escalabilidade da aplicação.

### Tarefas:

**História de Usuário: Como desenvolvedor, quero uma camada de modelo de dados clara e bem definida para facilitar o desenvolvimento e a manutenção.**

*   **Tarefa:** Definir e implementar a entidade `TUsuario`.
    *   **Sub-tarefa:** Criar a unidade `forup.model.usuario.pas`.
    *   **Sub-tarefa:** Definir as propriedades da classe `TUsuario` (ID, Nome, Email, Senha).
    *   **Sub-tarefa:** Mapear as propriedades para as colunas do banco de dados usando atributos.
    *   **Sub-tarefa:** Registrar a classe `TUsuario`.

*   **Tarefa:** Criar o script de criação da tabela `usuarios`.
    *   **Sub-tarefa:** Definir a estrutura da tabela `usuarios` em um arquivo SQL.
    *   **Sub-tarefa:** Adicionar o script ao controle de versão.

**História de Usuário: Como desenvolvedor, quero ter um ORM funcional para realizar operações de CRUD de forma simples e segura.**

*   **Tarefa:** Implementar a funcionalidade de `Save` no ORM.
    *   **Sub-tarefa:** Implementar a lógica para `INSERT` de novos registros.
    *   **Sub-tarefa:** Implementar a lógica para `UPDATE` de registros existentes.

*   **Tarefa:** Implementar a funcionalidade de `Delete` no ORM.
    *   **Sub-tarefa:** Implementar a lógica para `DELETE` de registros.

*   **Tarefa:** Implementar a funcionalidade de `Find` no ORM.
    *   **Sub-tarefa:** Implementar a busca por ID.
    *   **Sub-tarefa:** Implementar a busca por critérios.

**História de Usuário: Como desenvolvedor, quero ter uma camada de testes automatizados para garantir a qualidade e a estabilidade do código.**

*   **Tarefa:** Criar testes de CRUD para a entidade `TUsuario`.
    *   **Sub-tarefa:** Configurar o ambiente de teste no projeto `test_project`.
    *   **Sub-tarefa:** Criar um teste para a operação de `Create` (inserir um novo usuário).
    *   **Sub-tarefa:** Criar um teste para a operação de `Read` (buscar um usuário).
    *   **Sub-tarefa:** Criar um teste para a operação de `Update` (atualizar um usuário).
    *   **Sub-tarefa:** Criar um teste para a operação de `Delete` (remover um usuário).

**História de Usuário: Como desenvolvedor, quero uma clara separação de responsabilidades entre a camada de apresentação, a camada de negócio e a camada de acesso a dados.**

*   **Tarefa:** Refatorar a arquitetura para incluir uma camada de serviço (lógica de negócio).
    *   **Sub-tarefa:** Criar uma unidade de serviço para `Usuario` (`forup.service.usuario.pas`).
    *   **Sub-tarefa:** Mover a lógica de negócio relacionada a `Usuario` para a camada de serviço.
    *   **Sub-tarefa:** Fazer com que os *endpoints* do Horse consumam os serviços em vez de acessar o ORM diretamente.
