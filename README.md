**Zadanie 1** Pascal ( [Kod](./task_1) )

:white_check_mark: 3.0 Procedura do generowania 50 losowych liczb od 0 do 100

:white_check_mark: 3.5 Procedura do sortowania liczb

:white_check_mark: 4.0 Dodanie parametrów do procedury losującej określającymi zakres
losowania: od, do, ile

:white_check_mark: 4.5 5 testów jednostkowych testujące procedury

:white_check_mark: 5.0 Skrypt w bashu do uruchamiania aplikacji w Pascalu via docker


**Zadanie 2**  Symfony (PHP) ( [Kod](./task_2) )

:white_check_mark: 3.0 Należy stworzyć jeden model z kontrolerem z produktami, zgodnie z
CRUD

:white_check_mark: 3.5 Należy stworzyć skrypty do testów endpointów via curl

:white_check_mark: 4.0 Należy stworzyć dwa dodatkowe kontrolery wraz z modelami

:white_check_mark: 4.5 Należy stworzyć widoki do wszystkich kontrolerów

:x: 5.0 Stworzenie panelu administracyjnego z mockowanym logowaniem

**Zadanie 3**  Spring Boot (Kotlin) ( [Kod](./task_3) )

:white_check_mark: 3.0 Należy stworzyć jeden kontroler wraz z danymi wyświetlanymi z
listy na endpoint’cie w formacie JSON - Kotlin + Spring Boot

:white_check_mark: 3.5 Należy stworzyć klasę do autoryzacji (mock) jako Singleton w
formie eager

:white_check_mark: 4.0 Należy obsłużyć dane autoryzacji przekazywane przez użytkownika

:white_check_mark: 4.5 Należy wstrzyknąć singleton do głównej klasy via @Autowired

:white_check_mark: 5.0 Obok wersji Eager do wyboru powinna być wersja Singletona w wersji
lazy

**Zadanie 4**  Wzorce strukturalne Echo (Go) ( [Kod](./task_4) )

:white_check_mark: 3.0 Należy stworzyć aplikację we frameworki echo w j. Go, która będzie
miała kontroler Pogody, która pozwala na pobieranie danych o pogodzie
(lub akcjach giełdowych)

:white_check_mark: 3.5 Należy stworzyć model Pogoda (lub Giełda) wykorzystując gorm, a
dane załadować z listy przy uruchomieniu

:white_check_mark: 4.0 Należy stworzyć klasę proxy, która pobierze dane z serwisu
zewnętrznego podczas zapytania do naszego kontrolera

:white_check_mark: 4.5 Należy zapisać pobrane dane z zewnątrz do bazy danych

:white_check_mark: 5.0 Należy rozszerzyć endpoint na więcej niż jedną lokalizację
(Pogoda), lub akcje (Giełda) zwracając JSONa

**Zadanie 5**  Wzorce behawioralne React (JavaScript/Typescript) ( [Kod](./task_5) )

:white_check_mark: 3.0 W ramach projektu należy stworzyć dwa komponenty: Produkty oraz
Płatności; Płatności powinny wysyłać do aplikacji serwerowej dane, a w
Produktach powinniśmy pobierać dane o produktach z aplikacji
serwerowej;

:white_check_mark: 3.5 Należy dodać Koszyk wraz z widokiem; należy wykorzystać routing

:white_check_mark: 4.0 Dane pomiędzy wszystkimi komponentami powinny być przesyłane za
pomocą React hooks

:white_check_mark: 4.5 Należy dodać skrypt uruchamiający aplikację serwerową oraz
kliencką na dockerze via docker-compose

:white_check_mark: 5.0 Należy wykorzystać axios’a oraz dodać nagłówki pod CORS

**Zadanie 6** Zapaszki

:white_check_mark: 3.0 Należy dodać eslint w hookach gita

:white_check_mark: 3.5 Należy wyeliminować wszystkie bugi w kodzie w Sonarze (kod
aplikacji klienckiej)

:white_check_mark: 4.0 Należy wyeliminować wszystkie zapaszki w kodzie w Sonarze (kod
aplikacji klienckiej)

:white_check_mark: 4.5 Należy wyeliminować wszystkie podatności oraz błędy bezpieczeństwa
w kodzie w Sonarze (kod aplikacji klienckiej)

:white_check_mark: 5.0 Zredukować duplikaty kodu do 0%

[Kod klienta](https://github.com/Idlealist/studia_sonar_client)

**Zadanie 7** Vapor (Swift) ( [Kod](./task_7) )

:white_check_mark: 3.0 Należy stworzyć kontroler wraz z modele Produktów zgodny z CRUD w
ORM Fluent

:white_check_mark: 3.5 Należy stworzyć szablony w Leaf

:white_check_mark: 4.0 Należy stworzyć drugi model oraz kontroler Kategorii wraz z
relacją

:x: 4.5 Należy wykorzystać Redis do przechowywania danych

:x: 5.0 Wrzucić aplikację na heroku

**Zadanie 8** Testy ( [Kod](./task_8) )

:white_check_mark: 3.0 Należy stworzyć 30 przypadków testowych w Pythonie w WebDriverze

:white_check_mark: 3.5 Należy rozszerzyć testy funkcjonalne, aby zawierały minimum 100
asercji

:x: 4.0 Należy stworzyć testy jednostkowe do wybranego wcześniejszego
projektu z minimum 100 asercjami

:x: 4.5 Należy dodać testy API, należy pokryć wszystkie endpointy z
minimum jednym scenariuszem negatywnym per endpoint

:x: 5.0 Należy uruchomić testy funkcjonalne na Browserstacku na urządzeniu
mobilnym

**Zadanie 9** Mobile first (Android) ( [Kod](./task_9) )

:white_check_mark: 3.0 stworzyć listę kategorii oraz produktów

:white_check_mark: 3.5 dodać widok koszyka

:white_check_mark: 4.0 stworzyć bazę w Realmie

:x: 4.5 dodać płatności w Stripe

:x: 5.0 dodać logowanie i rejestrację via Oauth2