// Web jumps
// ----------

// Shortcuts
webjumps.g = webjumps.google;

// Print friendly 
// www.printfriendly.com/‎
define_webjump("pdf","javascript:(function(){if(window['priFri']){window.print()}else{var pfurl='';pfstyle='nbk';pfBkVersion='1';if(window.location.href.match(/https/)){pfurl='https://pf-cdn.printfriendly.com/ssl/main.js'}else{pfurl='http://cdn.printfriendly.com/printfriendly.js'}_pnicer_script=document.createElement('SCRIPT');_pnicer_script.type='text/javascript';_pnicer_script.src=pfurl + '?x='+(Math.random());document.getElementsByTagName('head')[0].appendChild(_pnicer_script);}})();")

define_webjump("imdb", "http://www.imdb.com/find?s=all&q=%s");

define_webjump("you", "http://www.youtube.com/results?search_query=%s&page={startPage?}&utm_source=opensearch");

define_webjump("amz", "http://www.amazon.com/s/ref=nb_sb_ss_i_4_13?url=search-alias%3Daps&field-keywords=%s&sprefix=comfort+curve%2Caps%2C264");

define_webjump("img", "http://www.google.com/images?q=%s", $alternative = "http://www.google.com/imghp");

define_webjump("alt", "http://alternativeto.net/SearchResult.aspx?profile=all&search=%s");

define_webjump("wine", "http://appdb.winehq.org/objectManager.php?sClass=application&bIsQueue=false&bIsRejected=false&sTitle=Browse%20Applications&iItemsPerPage=25&iPage=1&iappFamily-appNameOp0=2&sappFamily-appNameData0=%s");

define_webjump("wolf", "http://www.wolframalpha.com/input/?i=%s");

// Reference
// ----------

define_webjump("wiki", "http://en.wikipedia.org/w/index.php?title=Special:Search&search=%s");

define_webjump("wikis", "http://es.wikipedia.org/w/index.php?title=Especial:Buscar&search=%s");


// Dictionaries and translations
// ------------------------------
define_webjump("traen", "http://translate.google.com/translate_t#auto|en|%s");

define_webjump("traes", "http://translate.google.com/translate_t#auto|es|%s");

define_webjump("drae", "http://lema.rae.es/drae/srv/search?type=3&val=%s&origen=RAE");

// Routledge Diccionario Técnico Inglés-Español
define_webjump("rstd", "http://books.google.com.mx/books?ei=1uaaUYOmIZC20QHrtIGADA&id=Gj8KhNvce8oC&dq=routledge+diccionario+tecnico&q=%s");


// Journals and citations
// -----------------------
define_webjump("ads", "http://adsabs.harvard.edu/cgi-bin/basic_connect?qsearch=%s&version=1");

define_webjump("sch", "http://scholar.google.com/scholar?hl=en&q=%s&btnG=&as_sdt=1%2C5&as_sdtp=");


// Books
// -------

define_webjump("book", "http://www.google.com/search?q=%s&btnG=Search+Books&tbm=bks&tbo=1");

define_webjump("oreilly", "http://search.oreilly.com/?q=%s&x=-743&y=-531");

define_webjump("apress", "http://www.apress.com/catalogsearch/result/?q=%s&submit=Go");

define_webjump("packt", "http://www.packtpub.com/search?keys=%s&search_switch=books");

// Mexico
// -------

define_webjump("sotano", "http://www.elsotano.com.mx/busqueda.php?q=%s&cfi=1");

define_webjump("steren", "http://www.steren.com.mx/catalogo/search.asp?s=%s&sugerencia=0&tipoSugerencia=0&search_type=prod&search=Buscar");

//LIBRUNAM
define_webjump("liba", "http://132.248.67.3:8991/F/UEUSVSXHYD837B4HJPED7S62PMADIX3772T4R9PKIV9MHTM6BQ-01301?func=scan&scan_start=%s&submit=+&local_base=MX001&scan_code=AUT");

define_webjump("libt", "http://132.248.67.3:8991/F/UEUSVSXHYD837B4HJPED7S62PMADIX3772T4R9PKIV9MHTM6BQ-01302?func=scan&scan_start=%s&submit=+&local_base=MX001&scan_code=TITG");

// MM Wiki
define_webjump("moin", "http://localhost:8080/FrontPage?action=fullsearch&context=180&value=%s&titlesearch=Titles");
