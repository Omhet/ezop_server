# coding: utf-8

#Пути к возможным папкам с файлами онтологий пролога
EXPATH=["../../EXE/Example/", "../../EXE/BaseExample/"]

#Путь к файлу kernel.tmt
KERNEL = "../../EXE/kernel.tmt"

#Файл-легенда, который показывается на страничке с картинкой непосредственно перед ней
LEGEND = "./legend.png"

#Имя директории временных файлов. Не должна совпадать с системной!
TMPDIR = './tmp/'

#Время существования файла во временной директории. По истечении этого времени при следующем выхове скрипта файл будет удален.
CLEAR_PERIOD = 300

#Обозначение размеров выводимой онтологии (может быть важно при формировании странички с формой, которая вызывает скрипт)
SMALL='small'
FULL='full'

#Типы вывода, используются там же
OWL = 'owl'
PIC = 'pic'

#Кодировка файлов пролога, подаваемых на вход.
ENC_IN = 'cp1251'

#Кодировка результата (НЕ МЕНЯТЬ! Dot понимает только utf-8)
ENC_OUT = 'utf-8'