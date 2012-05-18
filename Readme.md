# RiotVan
## new RiotVan website - http://riotvan.net

transitioning from WordPress to FiveTastic + FiveStorage based blog


### links:

old: http://old.riotvan.net


### todo

- fivetastic 2

- paginazione coll/sections
- anteprime http://img.youtube.com/vi/cHKP7lpnNS4/0.jpg

- link dall'immagine nella coll/section all'articolo
- refactoring event.haml
- rinominare collections in sections (asd)
- articoli simili

### for editors:

Come si inserisce un'articolo in RiotVan.net usando FiveAPI:

- apri Chrome o Firefox (su Safari per ora non funziona.... lo so...)
- accedi a http://riotvan.net
- clicca su "Login" (in alto a dx) e inserisci la pass
- clicca su "Add new"
- inserisci il titolo 
- inserisci la data di pubblicazione (formato: ANNO-MM-GG es: 2012-02-28)
- inserisci il nome dell'autore
- premi "Save" per salvare
- clicca sul tuo articolo, dovrebbe essere il primo della lista, se non hai inserito data sara' in fondo
 

per caricare immagini:

- clicca su "Uploads" (ricordati di salvare prima!)
- clicca sul tasto "Upload file" e scegli l'immagine dall'hd
- copiati/ricordati il codice delle immagini (es: [file_123]) da inserire nel testo dell'articolo

prima del testo dell'articolo ci deve essere il codice dell'immagine che deve apparire nelle anteprime, gallery etc. (es: nel campo testo ci sara': "[image_1] Testo dell'articolo...." e non "Testo dell'articolo... [image_1] ..." ) 



### Markdown:

Markdown e' un linguaggio di markup per scrivere documenti usando delle comode convenzioni che permettono di formattare il testo scrivendo testo! Niente editor del ca**o, si, bellini ma quando ci copiaincolli il testo ti ritrovi il sito spaginato e la madonn... ehm scusate, deformazione professionale, tornando a noi...
sto testo, come si formatta??

cosi':

**grassetto**

    **grassetto**

_corsivo_

    _corsivo_

immagine:

    ![](http://example.com/image.png)

immagine con titolo (per essere indicizzata sui motori di ricerca):

    ![Titolo immagine](http://example.com/image.png)

lista:

    - questa
    - e' una
    - lista!   

link:

<http://new.riotvan.net>  

    <http://new.riotvan.net>    


guida completa:
http://daringfireball.net/projects/markdown/syntax


### Immagini:

importante: questo e' veramente importante, se scrivi un bell'articolo poi non trascurare le immagini!

prima di caricare le immagini assicurati che l'immagine che stai caricando:

- abbia formato jpg o png
- sia massimo 1100x700 pixel (a 72dpi), se e' piu grande riducila fino a queste dimesioni
- il nome dell'immagine sia esplicativo (molto importante per i motori di ricerca e per le fotogallery)
- il nome sia tutto in minuscolo e senza spazi (quindi "Foto della Manifestazione.PNG" diventa "foto_della_manifestazione.png")


nota: il testo dell'articolo tra la prima e la seconda immagine sara' quello che viene visualizzato per le anteprime (es. home page) quindi scrivi sempre almeno 300 caratteri tra la prima e la seconda immagine!


tool per ridimensionare le immagini:

osx: http://www.apple.com/downloads/dashboard/developer/imageshackle.html
online: http://pixlr.com/editor/

enjoy!


### avviare il server sul portatile

    cds riotvan; rackup1

    cds fiveapi; rackup
