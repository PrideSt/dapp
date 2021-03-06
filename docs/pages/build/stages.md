---
title: Стадии сборки
sidebar: doc_sidebar
permalink: stages_for_build.html
folder: build
---

Что _обычно_ нужно запустить во время сборки?

* добавить код
* установить системное ПО
* установить системные зависимости
* установить прикладные зависимости
* настроить системное ПО
* настроить приложение

В каком порядке нужно выполнять эти шаги, чтобы сборка была быстрой, а _пересборка_ не занимала лишнего места? Нужно разделить сборку на более крупные шаги с чётким назначением. В dapp такие шаги называются стадиями. Есть 4 пользовательских стадии. Полный список вместе с внутренними стадиями доступен в главе [Стадии](stages.html).

## Стадии

Логично было бы выделить стадии install и setup. install для установки ПО, а setup для настройки. Однако есть системное ПО, есть прикладное ПО, зависимости нашего приложения. Для разделения этого многообразия были введены ещё две стадии: before_install и before_setup.

![Диаграмма пользовательских стадий сборки](images/build/stages_01.png "Диаграмма пользовательских стадий сборки")


### before_install

На этой стадии производятся долгоживущие настройки ОС, устанавливаются пакеты, версия которых меняется не часто. Например, устанавливается нужная локаль и часовой пояс, выполняются apt-get update, устанавливается nginx, php, расширения для php (версии которых не будут меняться очень часто).

По практике коммиты с измененими команд или версий ПО на этой стадии составляют менее 1%  от всех коммитов в репозитории. При этом эта стадия самая затратная по времени.

Подсказка: before_install — в эту стадию добавлять редко изменяющиеся или тяжелые пакеты и долгоживущие настройки ОС.

Мнемоника: _перед установкой_ приложения нужно настроить ОС, установить системные пакеты

### install

В этот момент лучше всего ставить прикладные зависимости приложения. Например, composer, нужные расширения для php. Можно добавить общие настройки php (отключение ошибок в браузер, включение логов и прочее, что не часто изменяется).

Коммиты с изменениями в этих вещах составляют примерно 5% от общего числа коммитов. Эта стадия может являться менее затратной по времени, чем before_install.

Подсказка: install — стадия для прикладных зависимостей и их общих настроек.

Мнемоника: _установка_ всего что нужно для приложения.

### before_setup

Основные действия по сборке самого приложения производятся на этой стадии. Компилирование исходных текстов, компилирование ассетов, копирование исходных текстов в особую папку или сжатие исходных текстов — всё это тут.

Здесь выполняютс действия, которые нужно произвести, чтобы приложение запустилось после изменения исходных текстов.

Подсказка: before_setup — стадия с действиями над исходными текстами.

Мнемоника: _перед настрокой_ приложения нужно установить само приложение.

### setup

Эта стадия выделена для конфигурации приложения, это может быть копирование файлов в /etc, создание программного модуля с версией приложения. В основном это лёгкие, быстрые действия, которые нужно выполнять при сборке для каждого коммита, либо примерно для 2% коммитов, в которых изменяются конфигурационные файлы приложения.

Стадия выполняется быстро, поэтому выполняется после сборки приложения. Возможны два сценария: либо стадия выполняется каждый коммит, либо изменились исходные тексты и будет перевыполнены стадии before_setup и setup.

Подсказка: setup — стадия для конфигурации приложения и для действий на каждый коммит.

Мнемоника: _настройка_ параметров приложения

### docker.*

Если оглянуться на главу [Первое приложение на dapp](get_started.html), то встанет вопрос: "На каких стадиях выполняются docker.from и docker.run"? На самом деле для этих директив выделены отдельные, внутренние, стадии. Для docker.from это стадия from — базовый образ меняется очень редко в процессе разработки, поэтому стадия from выполняется перед before_install. Для всех остальных директив docker.* выделена стадия docker_instructions, которая выполняется после setup.

## порядок сборки

Действия по сборке выполняются по порядку стадий на диаграмме. То есть сначала docker.from, затем команды, определённые для стадии before_install, затем install, потом before_setup и, наконец, setup. После чего выполняются docker.* директивы. Результат выполнения каждой стадии это docker-образ. Т.е. стадия install создаётся на основе образа, созданного на стадии before_install и так далее. Забегая вперёд, нужно упомянуть, что у каждой стадии есть контрольная сумма, вычисляемая из команд, которые определены для стадии (похоже на чексумму директив Dockerfile). Если команды стадии изменились, то изменится чексумма и приложение будет пересобрано начиная с изменившейся стадии (опять же аналогично сборке на основе Dockerfile). Нужно повысить версию imagemagick? Значит изменится install и пересоберутся стадии install, before_setup, setup, docker_instructions.

Итоговая диаграмма выглядит так:

![Диаграмма пользовательских стадий сборки](images/build/stages_02.png "Диаграмма пользовательских стадий сборки")


В дальнейшем эта диаграмма будет расширена, т.к.[артефакт](artifact_for_advanced_build.html) или [dimod (модули chef)](chef_dimod_for_advanced_build.html) добавляют свои стадии. Но пока можно перейти к главе про [shell-сборщик](shell_for_build.md), чтобы увидеть стадии в работе.
