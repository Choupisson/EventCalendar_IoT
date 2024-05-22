# Projet IoT : NEBULA (Neopixel Event-Based Utility for Luminous Alerts)

## Membres du Groupe
- Pierre WADRA
- Baptiste COSTAMAGNA
- Axel DREUX

## Introduction
Dans le cadre d'un projet en IoT de notre choix, nous avons opté pour un système d'affichage événementiel. L'objectif est de saisir les informations relatives à un événement et de bénéficier d'une indication visuelle du temps restant grâce à des Neopixels. À mesure que l'échéance approche, l'éclairage des Neopixels s'intensifie pour refléter visuellement le décompte. Lorsque le jour de l'événement est arrivé, tous les Neopixels brillent pleinement et un buzzer retentit pour signaler qu'un événement est prévu pour aujourd'hui. 

Le projet d'affichage événementiel trouve son utilité dans une multitude de contextes où la visualisation du temps est cruciale. Par exemple, il pourrait être mis en place lors d'événements professionnels comme des conférences ou des réunions pour indiquer les sessions à venir et signaler le début imminent d'une présentation. Dans un cadre éducatif, il pourrait servir à afficher le calendrier des cours ou des examens, offrant ainsi aux étudiants et au personnel un rappel visuel et sonore des échéances importantes. Il serait également idéal pour les espaces publics ou commerciaux, tels que les gares ou les centres commerciaux, pour informer les visiteurs des événements spéciaux ou des promotions en temps réel. Ce système, grâce à son interface interactive et ses rappels lumineux et sonores, améliore la communication des informations de manière intuitive et efficace.

## Description des Scripts

### autorun.lua
Ce script est utilisé comme point d'entrée pour initialiser le système. Il charge tous les scripts nécessaires, dont events.lua qui stocke les événements, projet.lua qui gère l'affichage sur l'écran OLED, neopixel.lua pour la gestion des LEDs Neopixels, et API.lua qui lance le serveur HTTP. Cela permet d'assurer que tous les composants nécessaires sont en place au démarrage de l'ESP32.

### API.lua
Ce script est le cœur de la communication serveur pour l'ESP32. Il crée un serveur HTTP qui écoute sur le port 80. Le serveur peut gérer plusieurs types de requêtes HTTP :

- **GET /events** : Envoie une réponse JSON avec la liste des événements.
- **GET /** : Sert le fichier **`index.html`** qui constitue l'interface utilisateur pour ajouter, supprimer ou modifier des événements.
- **POST /add, /remove, /setTime** : Gère l'ajout et la suppression d'événements ainsi que la synchronisation de l'heure actuelle. Après chaque POST, la fonction **`saveEvents()`** est appelée pour sauvegarder les changements, et **`mainLoop()`** est exécutée pour mettre à jour l'affichage et les Neopixels.

Le script utilise des sockets pour accepter les connexions entrantes, lire les requêtes, et envoyer les réponses appropriées. Il gère également la fermeture des connexions clients.

### events.lua
Ce fichier est une base de données simple pour les événements. Il stocke les événements dans un tableau Lua nommé events. Les événements sont ajoutés, supprimés ou modifiés via l'API HTTP.

### neopixel.lua
Ce script contrôle trois bandes de Neopixels représentant les mois, les jours et les heures jusqu'à un événement, (une couleur pour chaque barre). **`allumer_neopixel(neo,n,r,g,b)`** sert a contrôler allumer les différents pixels à mesure qu'on se rapproche de la date du prochain évènement. **`neopixelExec(currentEvent)`** s'occupe   d'appeler les fonctions contrôlant les leds pour les allumer. Enfin, **`alert()`** est utilisée pour déclencher une alerte auditive et visuelle lorsque l'événement approche.

### projet.lua
Ce script gère l'affichage des informations d'événement sur un écran OLED. Il inclut la fonction truncateString pour limiter la longueur des chaînes de caractères affichées, assurant que le texte ne dépasse pas les limites de l'écran. La fonction displayEvent est responsable de l'affichage des informations sur l'écran OLED. Elle commence par nettoyer l'écran, définir la police de texte, puis extrait les informations de l'événement - date, description, et lieu - à partir d'une chaîne donnée, et les affiche de manière concise. Elle ajuste la taille du contenu textuel pour qu'il corresponde aux limites de l'écran et termine par rafraîchir l'affichage pour montrer les informations mises à jour.

Le script propose également des outils pour la manipulation de dates et de timestamps. La fonction getTimestamp convertit une date au format standard en un timestamp UNIX. Cette fonction est utilisée pour analyser la date et l'heure des événements et les convertir en format numérique pour un traitement ultérieur.

Enfin, la fonction saveEvents s'occupe de la persistance des événements. Elle écrit les détails des événements dans un fichier Lua, permettant leur stockage et réutilisation ultérieurs. Cette fonction crée ou ouvre le fichier /events.lua, y inscrit le contenu d'un tableau représentant les événements, et ferme le fichier pour sauvegarder les données.

Le script gère également un calendrier d'événements, avec la fonction mainLoop qui fait partie d'une boucle continue pour mettre à jour régulièrement l'affichage et gérer l'ordre des événements à venir. Il prend en compte l'heure actuelle et ajuste l'affichage en conséquence, y compris la gestion de signaux visuels via des Neopixels.

## Interaction entre les Scripts
- **`API.lua`** sert de serveur HTTP pour recevoir des commandes et mettre à jour la liste des événements.
- **`autorun.lua`** initialise le système et assure que toutes les parties du programme sont lancées.
- **`events.lua`** sert de stockage pour les événements qui sont manipulés via l'API.
- **`neopixel.lua`** reçoit des informations sur les événements à venir et met à jour les bandes de Neopixels en conséquence.
- **`projet.lua`** affiche les informations de l'événement sur l'écran OLED.
- **`mainLoop`** dans **`projet.lua`** synchronise l'affichage et les Neopixels avec l'état actuel des événements.

## Limites
- **Taille de l'écran OLED**: La troncature à 9 caractères pourrait ne pas être adaptée à tous les écrans OLED. Si l'écran peut afficher plus de caractères, cette limite pourrait être inutilement restrictive.

## Améliorations
- **Adaptation dynamique de la troncature** : Ajuster dynamiquement le nombre de caractères tronqués en fonction de la taille de l'écran OLED.
- **Support international** : Ajouter une prise en charge des formats de date et d'heure internationaux.
- **Gestion des erreurs** : Ajouter une gestion d'erreurs pour les entrées de date invalides ou les problèmes lors de l'écriture dans le fichier.
- **Adaptation à plusieurs tailles de neopixel** : Actuellement les scripts neopixels n'allument que jusqu'a 8 leds (contrainte dû au matériel que l'on dispose). Rentrer dans une variable la taille des neopixels (eventuellement les 3 ayant des tailles différentes) pour adapter les calculs pour les affichages sur les neopixels.
  
## Conclusion
Ce projet illustre notre capacité à intégrer diverses technologies IoT pour créer une solution complète. L'affichage événementiel développé est flexible et peut être adapté pour diverses applications.

