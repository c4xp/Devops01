---
currentMenu: home
layout: default
title: Devops01
subTitle: Introducere
---
# Devops01 - Dockerizarea unei aplicații Php <sup>Incepatori</sup>

- Ce vrea DevOps de la mine ?!

![Squint](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/futurama.png)

## Ce subiecte vom acoperi în acest atelier:

- Docker este o unealtă facută pentru a ușura munca de creare, instalare și rulare ale aplicațiilor folosind containere.
- În acest atelier vom dockeriza o aplicație simplă Php, pentru ca s-o putem pregati pentru Integrare Continuă / Livrare Continuă.
- Cum să ne auto-documentam codul
- Tipuri, trucuri și unelte utile

## Ce trebuie să știe participanții:

Pentru a participa la acest atelier în mod activ, cursanții trebuie să aibă un pic de experiență cu Php, Linux, și familiaritate cu git, composer, si comenzi de la consola.

## Ce vom invăța până la sfârșit:

Participantii vor stii ce inseamna Docker la un nivel de baza: ce aduce nou in IT, de ce este o idee buna.
Bonus: Alte unelte bune de știut.

## De ce avem nevoie:

- Laptop cu Windows 64-bit: Pro, Enterprise sau Education
![AppsFeatures](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/00.apps-features.png)
![TurnOn](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/01.turnonfeatures.png)
![HyperV](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/02.hyperv.png)
![Cmd](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/03.cmd.png)
- Un cont pe [Github](https://github.com/)
- Opțiunea de Virtualizare activă în BIOS. Deschideți o fereastră `PowerShell` cu drepturi de Administrator:
```
Enable-WindowsOptionalFeature –Online -FeatureName Microsoft-Hyper-V –All -NoRestart
```
```
Enable-WindowsOptionalFeature -Online -FeatureName containers –All
```

![Dockerinstall](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/04.dockerinstall.png)

- Docker-Desktop instalat [download.docker.com](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe)
- Un procesor capabil de SLAT. ( Utilitare: [Speccy](https://www.ccleaner.com/speccy) [Coreinfo](http://technet.microsoft.com/en-us/sysinternals/cc835722) )
- Măcar 4GB de memorie RAM.

## Testarea mediului Windows

- Deschideți o fereastră terminal: `❖ + R`, tastați: `cmd`, urmat de `Ctrl + Shift + Enter`
```
Microsoft Windows [Version 10.0.???.???]
(c) 2019 Microsoft Corporation. All rights reserved.
```

- Tastați: `docker --version`
```
Docker version 18.09.2, build 6247962
```
- Descărcați imaginea simplă hello-world din Docker-Hub si rulați-o: `docker run hello-world`
```
docker : Unable to find image 'hello-world:latest' locally
...
latest:
Pulling from library/hello-world
...
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```
- Pentru mai multe detalii vizitati [Ghidul Docker](https://docs.docker.com/docker-for-windows/)

## Bonus nr.1 - [Chocolatey](https://chocolatey.org/) manager de pachete

- Deschideți o fereastră terminal: `❖ + R`, tastați: `cmd`, urmat de `Ctrl + Shift + Enter`
```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```

- Cateva pachete utile: (Instalate fara prompt `choco feature enable -n allowGlobalConfirmation`)
```
choco install git heidisql vscode vcredist-all php curl
```

Poate fi util si pentru lucrul de zi cu zi: jdk8 gimp k-litecodecpackfull peazip ?!

## Bonus nr.2 - Composer și Couscous pentru generare documentație

```
choco install composer
composer global require couscous/couscous
couscous preview
couscous generate
```

## Bonus nr.3 - Composer sub Windows Subsystem for Linux

- Deschideți o fereastră `PowerShell` cu drepturi de Administrator:
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

![Questions](https://raw.githubusercontent.com/c4xp/Devops01/master/assets/questions.png)

[Begin→](begin.md)
