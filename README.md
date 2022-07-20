# Rebase Challenge 2022

## Description

The application is made to provide reading and insertion of medical exams data. The challenge is mainly to do that while using docker and multitask structure.

## Requirements

* Docker Compose

## Running

```bash
$ bash run
```

## Tests

Still in work an optimal way to run the tests.
For now you can run this while the containers are up:
```bash
$ bash run-tests
```

## Endpoints

### GET /tests

Return all the exams in the database

Request should be like:

```js
get ('localhost:3000/tests')
```

And Response something like:

```json
[
  ["1","ABCD12","B000BJ20J4","Maria Luiza Pires","denna@wisozk.biz","PI","048.973.170-88","Emilly Batista Neto","gerald.crona@ebert-quigley.com","2001-03-11","165 Rua Rafaela","Ituverava","Alagoas","2021-08-05","hemácias","45-52","97"],
  ["2","0W9I67","B0002IQM66","Maria Helena Ramalho","rayford@kemmer-kunze.info","SC","048.108.026-04","Juliana dos Reis Filho","mariana_crist@kutch-torp.com","1995-07-03","527 Rodovia Júlio","Lagoa da Canoa","Paraíba","2021-07-09","hdl","19-75","74"]
]
```

### POST /import

Receive a CSV file and insert the data on the database if the file format is valid

Request should be like:

```js
post ('localhost:3000/import', body: csv_file)
```

The csv_file variable should contain an CSV file on the following format:

```csv
patient_code;patient_name;patient_email;patient_birthday;patient_street;patient_city;patient_state;doctor_number;doctor_state;doctor_name;doctor_email;exam_token;exam_date;exam_type;exam_type_limit;exam_result
083.892.729-70;João Samuel Garcês;madonna@gerhold-bode.io;1967-07-06;s/n Rua Bento;Taubaté;Pará;B000BJ8TIA;PR;Ana Sophia Aparício Neto;corene.hane@pagac.io;EMHUW2;2021-04-20;tsh;25-80;40
009.898.217-65;João Guilherme Palmeira;hermelinda.swaniawski@klocko.biz;1961-06-01;9731 Viela Arthur Pereira;Barra de São Francisco;Paraíba;B000HB2O2O;ES;Núbia Godins;christy_dickinson@langworth.org;7Y35FE;2021-07-16;leucócitos;9-61;12
```

Response HTTP status 201 in success case. HTTP status 400 in case the file is not on the right format

## Development Info
* <a href="https://github.com/users/nicolasjesse/projects/2">Controle de Tarefas</a>
