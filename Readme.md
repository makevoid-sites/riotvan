# RiotVan
## new RiotVan website - http://riotvan.net

transitioning from WordPress to FiveTastic + FiveStorage based blog

### links:

current: http://riotvan.net
new: http://new.riotvan.net
old: http://old.riotvan.net


### todo

- photogallery
- paginazione coll/sections
- link dall'immagine nella coll/section all'articolo
- refactoring event.haml
- rinominare collections in sections (asd)
- articoli simili

### for editors:

Come si inserisce un'articolo in RiotVan.net usando FiveAPI:

- apri Chrome o Safari (su Firefox per ora non funziona l'edit)
- accedi a http://new.riotvan.net
- clicca su "Login" (in alto a dx) e inserisci la pass
- clicca su "Add new"
- inserisci il titolo
- premi "Save" per salvare
- clicca su images (ricordati di salvare prima!)
- carica le immagini (importante: leggi sotto per maggiori info)
- copiati/ricordati il codice per le immagini (es: [image_1])
- inserisci il testo dell'articolo (l'editor usa la sintassi Markdown, leggi sotto per maggiori info)
- prima del testo dell'articolo ci deve essere il codice dell'immagine che deve apparire nelle anteprime, gallery etc. (es: nel campo testo ci sara': "[image_1] Testo dell'articolo...." e non "Testo dell'articolo... [image_1] ..." ) 
- inserisci la data di pubblicazione (formato: ANNO-MM-GG es: 2012-02-28)
- inserisci il nome dell'autore
- salva
- ricarica la pagina e... hai inserito il tuo primo articolo! ^^


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
