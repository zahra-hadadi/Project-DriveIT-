## DriveIT - Databassystem för körskola
Slutprojekt i databaser
skapat av Zahra Hadadi, Gabriella Ottosson och Johanna Swann YH25

## Projektbeskrivning
Vi har skapat ett databassystem för en körskola som lagrar och hanterar information om elever, instruktörer, lektioner och bokningar. Databasen används för att boka körlektioner samt analysera bokningar.
Vi har även utvecklat en enkel hemsida som fungerar som ett användargränssnitt för att interagera med databasen.

## Designval
Vi har valt att använda MySQL eftersom det är ett relationsdatabassystem som är stabilt, lätt att använda och passar bra för strukturerad data. MySQL stödjer även funktioner som constraints, triggers, stored procedures och index, vilket gör det lämpligt för vårt projekt.
Vi valde bort NoSQL eftersom vår data är tydligt strukturerad och innehåller många relationer mellan tabeller, vilket hanteras bättre i en relationsdatabas.

## Databasstruktur
Databasen består av följande tabeller:

● Elever

● Instruktörer

● Lektioner

● Bokningar

● Bokningslogg

Tabellerna är kopplade med primärnycklar (PK) och främmande nycklar (FK).

## Relationer
● En elev kan ha flera bokningar

● En instruktör kan ha flera bokningar

● En lektion kan bokas flera gånger

● Bokningar kopplar ihop elever, instruktörer och lektioner med hjälp av främmande nycklar

● Tabellen bokningslogg används för att registrera händelser i databasen när en ny bokning skapas via en trigger

## Funktionalitet
Databasen innehåller:

● Bokningar av lektioner

● Uppdatering av bokningsstatus (t.ex. avbokad)

● Visar bokningar med JOIN-frågor

● Visar statistik med GROUP BY (t.ex. antal bokningar per instruktör)

● Stored procedure för att hämta bokningar per elev

● TRIGGER som loggar när en ny bokning skapas

● TRIGGER som förhindrar dubbelbokningar genom att kontrollera att en instruktör inte bokas flera gånger vid samma tid.

● Enkel hemsida som användargränssnitt för att hantera bokningar

## Dataintegritet
● NOT NULL för att säkerställa att viktiga fält alltid fylls i

● UNIQUE för att undvika dubbletter (t.ex. email)

● CHECK för att validera värden (t.ex. status och pris > 0)

● DEFAULT -värden (t.ex. status = ‘Bokad’)

● FOREIGN KEY för att säkerställa korrekta relationer mellan tabellerna

● TRIGGER som hjälper till att förhindra felaktiga bokningar

## Prestanda och säkerhet

● Index för snabbare sökningar

● Användare och rättigheter (GRANT/REVOKE) för att styra åtkomst

## Vidareutveckling
Databasen kan vidareutvecklas med förbättringar av den befintliga hemsidan för att minska risken för fel när man fyller i information. Vi kan exempelvis implementera personliga inloggningar för både elever och instruktörer, vilket gör det möjligt för användarna att se sina egna bokade tider, hitta lediga tider och hantera sina scheman direkt i systemet.
Det går även att utöka databasen med fler funktioner, till exempel betalningar, historik och bättre hantering av bokningar och tider. Det hade också varit viktigt att göra regelbundna backuper av databasen, så att ingen data försvinner om något går fel.

## Sammanfattning
Vårt projekt visar hur en körskola kan hantera bokningar och data på ett strukturerat sätt med hjälp av MySQL relationsdatabas. Genom att använda tabeller, relationer och olika SQL-funktioner säkerställs dataintegritet och effektiv hantering av information.
Vi har även utvecklat en enkel hemsida som fungerar som ett användargränssnitt för att interagera med databasen, vilket gör systemet mer användarvänligt och praktiskt att använda i verkliga situationer.
Projektet visar vår förståelse för hur databaser kan designas, implementeras och användas i praktiska sammanhang.


