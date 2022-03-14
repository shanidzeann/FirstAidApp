# FirstAid

UIKit

MVVM, Data binding via Boxing (как минимум, я пыталась)

UI: Storyboard/код (NSLayoutAnchor, SnapKit)

Реализовано:

1) Вывод теоретических материалов
- Материалы хранятся в JSON
- Парсинг JSON (Decodable)
- Для сохранения прогресса пользователя лекции хранятся в plist
- Фильтрация лекций (прочитанные/непрочитанные/все) - UIMenu
- Лекции выводятся в table view с двумя типами ячеек

![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/launch.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f1.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f2.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f3.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/lesson1.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/lesson2.png)


2) Текстовый квест
- Квест хранится в JSON
- Парсинг JSON (Decodable)
- Для сохранения прогресса пользователя используется Core Data
- Время выбора ответа ограничено таймером (SRCountdownTimer)
- Переходы между сценами анимированы

![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f5.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f6.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f7.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f8.png)

- Квест пройден успешно
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f9.png)

- Выбран неверный ответ 
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f10.png)

- Истекло время 
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f11.png)



3) Вывод новостей здоровья и медицины (https://newsapi.org/s/russia-health-news-api)
- Парсинг JSON (Decodable)
- Работа с сетью (URLSession)

![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/FirstAid11.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/FirstAid9.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/f12.png)
