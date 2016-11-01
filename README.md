# dice-roller-TeamSpeak
Script LUA de lancé de dés pour Teamspeak

Merci d'avoir téléchargé ce script.

support : http://www.virtuajdr.net ou https://github.com/dryasredrock/dice-roller-TeamSpeak

*************************************************
Installation
*************************************************

décompressez l'archive dans le sous-répertoire lua-plugin du votre répertoire plugins de teamspeak
	C:\Program Files\TeamSpeak 3 Client\plugins\lua_plugin\Virtuajdr_dice
acitvez le script :
	menu settings / plugins
	dans la fenêtre qui s'ouvre vous devez décocher test plugin et sélectionner lua-plugins 
appuyez sur le bouton 'settings' en dessous , cochez viruajdr_dice
(un appui sur reload all peut être nécessaire). 
Enjoy !!!


*************************************************
Release notes
*************************************************

version 1.5
ajout des modificateurs
(2d10)+5
(2d10+2)+10
ajout des modificateurs negatifs

version du script 1.4
ajout des modificateurs 
(2d10+4)
(2d10-4)

version du script 1.3
pensez a consultez le site www.virtuajdr.net pour savoir si une nouvelle version de ce script est accessible.
Si vous améliorez ou modifiez ce script, merci de nous en informez afin de pérenniser vos modifications.


*************************************************
Mode d'emploi
*************************************************

le script limite le nombre de dés utilisés par dés a 25.

(25d10) lance 25 dés à 10 faces 
et affichera le jet, la somme et le nombre de réussite ( jet faisant le max ici 10)
réussite en vert et fumble en rouge

(25d10)r5 modifie le seuil de réussite 5 au lieu de 10

(25d10)k2 ne garde que les 2 meilleures résultats

(25d10)r5k2 modifie le seuil de réussite a 5 et garde les 2 meilleures résultats. (toujours mettre l'option r avant k)

Tout résultat faisant un 1 est considéré comme fumble et est affiché en rouge.

*************************************************
Notice
*************************************************

limit number of rolling dices : 25

(25d10) roll 25 dices with 10 faces et show the rolling result of each dices, the sum, the number of max faces (success threshold) in green and the number of 1 (fumble) in red

(25d10)r5 set the success threshold at 5

(25d10)k2 only keep the 2 best results

(25d10)r5k2 a mix of the 2 previous functions

every 1 is considered as a fumble and shown in red