# Projet IoT : Affichage Événementiel

## Membres du Groupe
- Pierre WADRA
- Baptiste COSTAMAGNA
- Axel DREUX

## Introduction
Ce projet a été développé dans le cadre d'une initiative IoT où nous avions la liberté de choisir notre sujet. Nous nous sommes décidés pour un système d'affichage événementiel. Ce dispositif permet la saisie d'informations relatives à des événements et utilise des Neopixels pour fournir une indication visuelle du temps restant avant ces événements. L'éclairage intensifie à mesure que la date de l'événement se rapproche, et le jour J, un buzzer retentit accompagné de Neopixels pleinement illuminés pour annoncer l'événement.

## Contexte d'Utilisation
L'application de ce projet est vaste, allant des contextes professionnels, comme les conférences, aux espaces éducatifs, en passant par les lieux publics ou commerciaux. L'interface interactive et les alertes lumineuses et sonores rendent la communication des informations temporelles à la fois intuitive et efficace.

## Description des Scripts

### autorun.lua
Script initial qui charge tous les composants nécessaires au démarrage de l'ESP32, y compris le stockage des événements (`events.lua`), l'affichage OLED (`projet.lua`), la gestion des Neopixels (`neopixel.lua`), et le lancement du serveur HTTP (`API.lua`).

### API.lua
Noyau de la communication serveur sur l'ESP32. Ce script gère les requêtes HTTP pour recevoir des commandes et mettre à jour les événements. Il traite les requêtes GET pour servir des événements et des fichiers, ainsi que des requêtes POST pour ajouter, supprimer ou synchroniser l'heure des événements.

### events.lua
Base de données simple stockant les événements dans un tableau Lua. Les événements sont manipulés via l'API HTTP.

### neopixel.lua
Contrôle des bandes de Neopixels qui visualisent le temps restant avant un événement. Les fonctions permettent d'activer et de désactiver les pixels individuellement et d'ajuster l'affichage en fonction du temps restant.

### projet.lua
Gère l'affichage OLED en affichant les informations d'événement et en tronquant les textes trop longs. Il comprend également des fonctions pour manipuler les dates et les timestamps et pour sauvegarder les événements.

## Interaction entre les Scripts
Les scripts travaillent conjointement pour former un système d'affichage événementiel complet. Le serveur HTTP (`API.lua`) reçoit les commandes, `events.lua` agit comme stockage des événements, `neopixel.lua` et `projet.lua` mettent à jour visuellement l'état des événements, tandis que `autorun.lua` s'assure que le système démarre avec tous les composants nécessaires.

## Limites et Améliorations
Le système actuel tronque les chaînes de caractères à 9 caractères, ce qui peut être ajusté en fonction des capacités de l'écran OLED. Des améliorations peuvent inclure une troncature dynamique, une prise en charge internationale des formats de date/heure, et une meilleure gestion des erreurs.

## Conclusion
Ce projet illustre notre capacité à intégrer diverses technologies IoT pour créer une solution complète. L'affichage événementiel développé est flexible et peut être adapté pour diverses applications, prouvant ainsi l'efficacité de notre approche.

