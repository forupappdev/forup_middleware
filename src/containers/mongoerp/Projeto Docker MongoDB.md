# Projeto Docker MongoDB

Este projeto Docker permite que você execute uma instância do MongoDB 7.0.14 Community Edition com persistência de dados. Isso significa que seus dados não serão perdidos quando o container for reiniciado ou removido.

## Pré-requisitos

Antes de começar, certifique-se de ter o Docker e o Docker Compose instalados em sua máquina. Você pode baixá-los e instalá-los a partir dos links abaixo:

*   **Docker Desktop:** [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
*   **Docker Compose:** Geralmente vem incluído com o Docker Desktop. Se não, siga as instruções em [https://docs.docker.com/compose/install/](https://docs.docker.com/compose/install/)

## Estrutura do Projeto

```
mongodb-docker-project/
├── data/             # Diretório para persistência dos dados do MongoDB
├── .env              # Variáveis de ambiente para o container MongoDB
├── Dockerfile        # Define a imagem Docker do MongoDB (opcional, pois usamos a imagem oficial)
├── docker-compose.yml # Define os serviços Docker para o MongoDB
└── README.md         # Este arquivo de instruções
```

## Configuração

O arquivo `.env` contém as variáveis de ambiente para o container MongoDB. Você pode editá-lo para personalizar o nome de usuário e a senha do administrador.

```dotenv
MONGO_INITDB_ROOT_USERNAME=admin
MONGO_INITDB_ROOT_PASSWORD=adminpassword
MONGO_DATA_PATH=./data
```

*   `MONGO_INITDB_ROOT_USERNAME`: Nome de usuário para o usuário root do MongoDB.
*   `MONGO_INITDB_ROOT_PASSWORD`: Senha para o usuário root do MongoDB.
*   `MONGO_DATA_PATH`: Caminho relativo para o diretório onde os dados do MongoDB serão armazenados. Por padrão, é o diretório `data` dentro do projeto.

## Como Usar

Siga os passos abaixo para iniciar e gerenciar seu container MongoDB:

1.  **Navegue até o diretório do projeto:**

    ```bash
    cd mongodb-docker-project
    ```

2.  **Inicie o container MongoDB:**

    ```bash
    docker-compose up -d
    ```

    Este comando irá:
    *   Baixar a imagem `mongo:7.0.14-jammy` (se ainda não tiver).
    *   Criar e iniciar um container chamado `mongodb_container`.
    *   Mapear a porta `27017` do seu host para a porta `27017` do container.
    *   Montar o diretório `./data` do seu host no diretório `/data/db` dentro do container, garantindo a persistência dos dados.
    *   Configurar o usuário e senha root do MongoDB usando as variáveis do arquivo `.env`.

3.  **Verifique o status do container:**

    ```bash
    docker-compose ps
    ```

    Você deverá ver o `mongodb_container` com o status `Up`.

4.  **Conecte-se ao MongoDB (usando `mongosh` ou outro cliente):**

    Se você tiver o `mongosh` instalado localmente, pode se conectar usando:

    ```bash
    mongosh "mongodb://localhost:27017" -u admin -p adminpassword
    ```

    Substitua `admin` e `adminpassword` pelos valores que você definiu no seu arquivo `.env`.

5.  **Pare o container MongoDB:**

    ```bash
    docker-compose down
    ```

    Este comando irá parar e remover o container `mongodb_container` e a rede Docker criada pelo `docker-compose`. Os dados persistirão no diretório `./data`.

6.  **Remova os dados persistentes (opcional):**

    Se você quiser remover completamente os dados do MongoDB, basta excluir o diretório `data`:

    ```bash
    rm -rf data
    ```

## Persistência de Dados

Os dados do MongoDB são armazenados no diretório `./data` do seu host, que é mapeado para `/data/db` dentro do container. Isso garante que seus dados não sejam perdidos mesmo se o container for removido. Você pode verificar o conteúdo deste diretório para ver os arquivos de dados do MongoDB.

## Solução de Problemas

*   **Porta já em uso:** Se você receber um erro de porta já em uso, certifique-se de que nenhum outro serviço esteja usando a porta `27017` em sua máquina. Você pode alterar a porta mapeada no `docker-compose.yml`.
*   **Problemas de permissão:** Certifique-se de que o Docker tenha permissão para gravar no diretório `data`.
*   **Container não inicia:** Verifique os logs do container para obter mais informações:

    ```bash
    docker-compose logs mongodb
    ```

## Contribuição

Sinta-se à vontade para contribuir com este projeto, abrindo issues ou pull requests no repositório.

## Licença

Este projeto está licenciado sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes. (Nota: Não incluímos um arquivo LICENSE neste exemplo, mas é uma boa prática em projetos reais.)


