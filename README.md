# LeOvo ISU&ASM skladiště
Různé programy, které jsem vyplodil při studiu předmětu ISU. Časem to tady třeba nějak okomentuju a doplním.

## Stream
V adresáři `stream` jsou hotové příklady, které jsem dělal na [streamu před testem 3](https://www.youtube.com/watch?v=WOegtgYE7X8). \
Pěkný přehled FPU instrukcí: [http://linasm.sourceforge.net/docs/instructions/fpu.php](http://linasm.sourceforge.net/docs/instructions/fpu.php).

V příkladu `fpu-vyraz` bylo v zadání uvedeno, že má funkce vrátit +-Inf, pokud je jmenovatel zlomku (kde je proměnná) roven nula. Na streamu jsem říkal, že stačí to dělení provést a ono to správné nekonečno vyplivne, pokud se tam octne nula, což je pravda, ale 🌫️ovi se to nelíbí. Pravdou je, že to je chybový stav a nastavuje to příslušné flagy. Řešením je před tím dělením otestovat, jestli se B nerovná nule, což je možné udělat pomocí `ftst`, `fstsw ax`, `sahf` a porovnání pomocí `je`. Pokud se to rovná nule, je třeba ještě otestovat znaménko čitatele a podle něho do FPU nahrát buď +inf nebo -inf (konstanty `0x7F800000` a `0xFF800000`). V souboru v tomhle repu je to opravené (respektive, mělo by být, ještě jsem to neotestoval :rtzW:).

#### [ISU be like](https://www.youtube.com/watch?v=MUpknhU0mgM)
