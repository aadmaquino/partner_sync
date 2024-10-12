# Partner Sync

The **Partner Sync** project aims to streamline the updating of internal partner data. By allowing bulk updates through CSV file uploads, we can reduce the time and effort spent on manual data entry, enhancing overall efficiency.

- [Technologies](#technologies)
- [Getting Started](#getting-started)
  - [Running with Docker](#running-with-docker)
  - [Running locally with ASDF](#running-locally-with-asdf)
- [API Endpoints](#api-endpoints)
- [Libraries](#libraries)
- [Code Quality](#code-quality)
- [Tests and Coverage Report](#tests-and-coverage-report)

## Technologies

* Elixir 1.14.2
* Phoenix 1.6.15
* Erlang 25.1.2
* PostgreSQL 14

## Getting Started

There are two ways to run the application: using [Docker](https://www.docker.com/) or running it locally with [ASDF](https://asdf-vm.com/).

### Running with Docker

**1-** Download and install Docker: https://docs.docker.com/get-docker/

**2-** Once the installation is complete, verify that Docker is running. Open your preferred terminal and execute the commands below:

```bash
$ docker -v
# Docker version 20.10.21, build baeda1f

$ docker-compose -v
# docker-compose version 1.29.2, build unknown
```

If the version information appear, you're ready to proceed. If not, you'll need to install Docker using an alternative method. Below are some commands for different operating systems:

```bash
macOS:
$ brew update
$ brew install docker && brew install docker-compose

Linux (Ubuntu):
$ sudo apt-get update
$ sudo apt-get install docker docker-compose
```

**3-** In the terminal, with Docker running, navigate to the project root directory:

```bash
$ cd ~/partner_sync/
```

**4-** Run the command below to start the application and wait for it to initialize:

```bash
$ docker-compose up --build
```

**5-** That's it! The application is now accessible at the following URL: http://localhost:4000/

### Running locally with ASDF

**1-** Download and install ASDF: https://asdf-vm.com/guide/getting-started.html

**2-** Once the installation is complete, verify that ASDF is running. Open your preferred terminal and execute the command below:

```bash
$ asdf --version
# v0.10.2-7e7a1fa
```

If the command above didn't work, check if the `asdf` command is present in your system's environment variables.

**3-** In the terminal, navigate to the project root directory:

```bash
$ cd ~/partner_sync/
```

**4-** Add the plugins for [Erlang](https://github.com/asdf-vm/asdf-erlang.git) and [Elixir](https://github.com/asdf-vm/asdf-elixir.git) by following the provided instructions.

> [!WARNING]
> Please read the README files of these 2 repositories carefully! There are dependencies that need to be installed, which vary depending on the operating system.

Run the commands below:

```bash
$ asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
$ asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
```

**5-** Install the versions of Erlang and Elixir using the commands below:

```bash
$ asdf install erlang 25.1.2
$ asdf install elixir 1.14.2
```

**6-** To verify that both have been installed, use the following command:

```bash
$ asdf current
# elixir          1.14.2          /path/partner_sync/.tool-versions
# erlang          25.1.2          /path/partner_sync/.tool-versions
```

Now that ASDF is properly configured, the next step is to install the database.

**7-** Download and install PostgreSQL 14: https://www.postgresql.org/download/ or use one of the commands below:

```bash
macOS:
$ brew install postgresql

Linux (Ubuntu):
$ sudo apt-get install postgresql
```

> [!TIP]
> You can also use ASDF to install PostgreSQL 14:
>
> ```bash
> $ asdf plugin add postgres https://github.com/smashedtoatoms/asdf-postgres.git
> $ asdf install postgres 14.6
> $ asdf global postgres 14.6
> ```

**8-** Configure the database username and password by following this [tutorial](https://chartio.com/resources/tutorials/how-to-set-the-default-user-password-in-postgresql/). The default value are both `postgres`.

**9-** Your environment is ready to run the application. To get started, execute the following commands in the project directory:

```bash
$ mix deps.get # Installs the project's dependencies
$ mix ecto.setup # Creates the project's database
$ mix phx.server # Starts the Phoenix Endpoint (without debug)
$ iex -S mix phx.server # Starts the Phoenix Endpoint with debugging
```

**10-** That's it! The application is now accessible at the following URL: http://localhost:4000/

## API Endpoints

Method | Endpoint | Description | Parameters / Body
-------|----------|-----------|-----------
GET | /api/v1/addresses | Lists all addresses |
GET | /api/v1/addresses/:cep | Shows an address by ZIP Code |
GET | /api/v1/partners | Lists all partners |
GET | /api/v1/partners/:cnpj | Shows a partner by CNPJ |
POST | /api/v1/partners | Imports a CSV file ([Ver template](https://github.com/aadmaquino/partner_sync/blob/main/template.csv)) and inserts/updates each valid record | `csv (file)`
GET | /dev/mailbox | Provides access to the default email interface for viewing emails sent during development |

> [!NOTE]
> To set up the request `POST - /api/v1/partners` in Postman, [click here](https://www.postman.com/postman/workspace/postman-answers/documentation/13455110-00378d5c-5b08-4813-98da-bc47a2e6021d) for detailed instructions.
>
> ![image](https://user-images.githubusercontent.com/20209857/204148564-3eac1208-23f8-4bfc-be42-526c95113a22.png)

## Libraries

* [Credo](https://github.com/rrrene/credo): A static code analysis tool that ensures code follows best practices and recommended standards.
* [Excoveralls](https://github.com/parroty/excoveralls): Generates detailed test coverage reports, with easy integration into CI tools.
* [CSV](https://github.com/beatrichartz/csv): A library for parsing and generating CSV files efficiently in Elixir.
* [HTTPoison](https://github.com/edgurgel/httpoison): A simple and flexible HTTP client for making HTTP requests in Elixir applications.
* [Brcpfcnpj](https://github.com/williamgueiros/Brcpfcnpj): Provides functions for validating and formatting Brazilian CPF and CNPJ numbers.
* [Oban](https://github.com/sorentwo/oban): A robust background job processing framework with support for distributed queues and persistence via PostgreSQL.

## Code Quality

To run the analysis, execute:

```bash
$ mix credo --strict
```

## Tests and Coverage Report

To run the tests, execute:

```bash
$ mix test
```

To generate an HTML coverage report, execute:

```bash
$ mix coveralls.html
```

The report will be saved at: `~/partner_sync/cover/excoveralls.html`
