Descripción objetos:
--------------------
- csvOutput.rb: compone los csv desde arrays o hash
- csvProcess.rb: para recorrer csv componiendo hashes o nuevos csv con valores filtrados
- retriever.rb: clase principal que se encarga de recorrer links y parsear html en busca de los elementos necesarios
- url.rb: clase sencilla para guardar y manejar URLs (quitar dominio, comprobar, añadir parámetros, ...)


Descripción uso:
----------------
1. Componer clase de parseado de la web deseada extendiendo Retriever (ejemplo: osculati.rb).
   getElementData() realiza la mayoría del trabajo.

2. En la mayoría de los casos habrá que añadir métodos para lidiar con la estructura html de cada web, 
   además de override algunos de los base que son en su mayoría muy genéricos

3. Definir un init.rb. Require: 'url.rb', 'osculati.rb', 'csvOutput.rb'.
    Instanciar url, retriever y csvOutput y pasarles los parámetros necesarios:
      para retriever llamaremos addLanguage para añadir los idiomas que queremos recojer,
      y addElements() para añadir elementos html a recojer,
      y linksToFollow() para añadir clases o ids de links a seguir 
      y previousUrlLog() con path a archivo que guardará las url ya parseadas para no repetirlas

4. csvOutput contendrá path del archivo csv donde se guardarán resultados (lo crea si no existe).