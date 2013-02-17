DEV-ENV
=======

Настройки для разработки на python + js

Установка
_________
::
    make

Note: git submodule init and git submodule update need to be run every time a new submodule is added. git submodule foreach git pull command is used to pull latest upstream changes.

vim
___

| **Горячие клавиши.**

,w - быстрый save
,bd - закрыть текущий буфер
,ba - закрыть все буферы
,cd - переключится на директорию в которой находится открытый фаил.
,ss - включить и выключить проверку правописания
,pp - paste mode
,bb - cd ..

| **Smart mappings.**
||В командной строке:
$h e ~/
$d e ~/Desktop/
$j e ./
$c e <C-\>eCurrentFileDir("e")<cr>





| **Python.**

$i - import
$d - import ipdb; ipdb.set_trace()
$r - return
$p - print
