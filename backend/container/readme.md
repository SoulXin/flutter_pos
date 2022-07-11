#Konfigurasi Docker Container

## Struktur Folder

Clone semua project terkait dan tempatkan pada susunan folder serperti berikut:

.
├── backend    # repo:https://repository

## Build Docker Container

Buka terminal dan set aktif directore ke folder `backend`. Kemudian ekseskusi command berikut pada terminal.

```
$ make build        #untuk mem-build docker image yang dibutuhkan
$ make setup        #membuat volume dan start container
$ make create-db    #membuat database yang dibutuhkan
$ make init         
```
