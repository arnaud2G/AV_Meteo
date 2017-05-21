# AV_Meteo


- Voici mon travail sur le test technique : application météo à 5 jours sur Paris. Par manque de temps je n'ai pas vraiment travaillé l'aspect graphique (pas du tout en fait)

- J'ai utilisé 2 bibliothèque : 
   - RealmSwift pour la base de donnée que je voulais essayer (a regret, CoreData est plus mature)
   - ObjectMapper pour le dechiffrage des JSON
   
- L'application est mise à jours à chaque fois que l'utilisateur retourne dessus.

- Il n'y a pas de gestion de l'erreur (manque de temps également) mais pas de crash non plus.

- La météo est présenté sur un tableViewController, une ligne = un créneau horraire, une section = une journée. Ici CoreData aurait été plus pratique car aurait permis plus facilement de mettre à jours seulement les lignes modifiés avec un NSFetchedResultController.

