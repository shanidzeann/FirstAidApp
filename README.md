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
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/theory1.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/theory2.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/theory3.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/lesson1.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/lesson2.png)


2) Текстовый квест
- Квест хранится в JSON
- Парсинг JSON (Decodable)
- Для сохранения прогресса пользователя используется Core Data
- Время выбора ответа ограничено таймером (SRCountdownTimer)
- Если время заканчивается - выводится последняя сцена, описывающая проигрыш

![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/quests.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/quest1.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/quest2.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/stop.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/again.png)


3) Вывод новостей здоровья и медицины (https://newsapi.org/s/russia-health-news-api)
- Парсинг JSON (Decodable)
- Работа с сетью (URLSession)

![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/FirstAid11.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/FirstAid9.png)
![Image alt](https://github.com/shanidzeann/Screenshots/blob/main/FirstAid10.png)
