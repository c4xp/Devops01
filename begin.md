---
currentMenu: begin
layout: default
title: Devops01
subTitle: Început
---
## Început


- Deschideți o fereastră terminal: `❖ + R`, tastați: `cmd`
```
d:
mkdir workspace
cd workspace
git clone https://github.com/c4xp/Devops01.git Devops01
```

![Battle](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/battle.png)

Developer are rolul de a scrie cod de calitate, sa rezolve buguri si de a face mentenanta la un cod existent.

Operations pe de alta parte are rolul de a integra codul existent intr-o infrastructura functionala.

## Infrastructura

![Virtualizare](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/vmcnt00.png)

Virtualizare fata de Containere.
Nics, Discs, Cpus, Memories, Kernels..

![DevOps](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/vmcnt01.png)

Iadul dependintelor este iadul Ops.
Unde stau dependintele.

![DevOps](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/vmcnt02.png)

Acum avem Containere!
Plus ca am mai rezolvat ceva: Acum mediul de dezvoltare, serverul de test intotdeauna este la fel ca mediul de productie.
Toata lumea e fericita.

## Crearea imaginii docker

In primul rand trebuie sa avem o serie de fisiere in aplicatie pentru a putea lansa o imagine docker.
Pentru cursul de azi ele au fost create deja in directorul `assets\demox01`, dar vom explica fiecare fisier ce face.

```
.
├── demox
│   ├── lib
│   │   ├── db.class.php
│   │   └── singleton.class.php
│   └── public
│   │   ├── favicon.ico
│   │   ├── index.php
│   │   └── robots.txt
│   └── ?cfg.php
├── .gitignore
├── .php.dockerfile
├── cfg.php
├── composer.json
├── docker-compose.yml
├── nginx.conf
├── siteavailable.conf
└── supervisord.conf
```

```
docker-compose up -d
docker ps
docker exec -ti php.demox bash
```

## Cateva comenzi utile

```
docker images
docker rmi c0ff33

docker ps -a
docker rm c0ff33

docker volume ls
docker volume rm c0ff33

docker info
docker network inspect bridge
```

## Exercitii

Cum aflam IP-ul unei masini docker locale ?
Cum eliberăm toate resursele folosite de docker ? (Images, Containers, Volumes, Networks)

```
docker inspect c0ff33
docker system df
```

![Questions](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/questions.png)

[Learn→](learn.md)