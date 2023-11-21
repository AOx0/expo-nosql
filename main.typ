#import "slides.typ": *
#import "tablex.typ": *
#import "themes/bristol.typ": *

#show: slides.with(
    authors: ("Alejandro Osornio"), short-authors: "Alejandro Osornio",
    title: "NoSQL", short-title: "NoSQL", subtitle: "Bases de Datos Avanzadas",
    date: datetime.today().display(),
    theme: bristol-theme(),
)

#slide(theme-variant: "title slide")

#new-section("Introducción")

/*
  A data model determines how data is structured and accessed.

  Some key points about data models:
  - They determine the logical structure of a database independent of physical storage considerations
  - Different data models structure and organize data in different ways which impacts how it can be accessed and manipulated
  - Common data models include the hierarchical, network, relational, object-oriented, and dimensional models
  - The optimal data model depends on factors like the nature of the data, requirements for speed, reliability, maintainability and more
*/

#slide(title: "Escalabilidad", colwidths: (1.5fr, 1fr))[
  - La capacidad de un sistema para manejar una carga cada vez mayor de datos y trabajo.
  - Ejemplo: Tienes un servidor, cuyo servicio ocupa el 80% ocupado del disco duro y 85% de RAM.
][
  #image("assets/Resource.svg")
]

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  ¿Cómo harían para tener más recursos para atender a los usuarios?
]


#slide(title: "Horizontal vs Vertical", colwidths: (1fr, 1fr))[
  #align(center)[
    #image("assets/Resource3.svg")
  ]
][
  #align(center)[
    #image("assets/Resource2.svg")
  ]
]

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  10 millones de usuarios, ¿escalar horizontal o vertical?
]

#slide(title: "Modelo de datos")[
  - Describe cómo se estructuran los datos y cómo se accede a ellos.
  - El modelo de datos tiene implicaciones sobre las operaciones y representación de los datos
  - Un modelo implica formas distintas:
    - De relaciones
    - De entidades
    - De atributos
]

#slide(title: "Modelo relacional", colwidths: (1.5fr, 1fr))[
  - Propuesto por Edgar F. "Ted" Codd en 1970, de la IBM
  - Basado en tablas, formadas por columnas (atributos) y filas (entidades)
  - Se identifica las tuplas con llaves, y a la vez se usan para formar relaciones
  - Noten que el modelo esta orientado a entidades, las relaciones son secundarias
  - Las tablas deben ser pre definidas
][
  #image("assets/Relational.svg")
]

#slide(title: "\"SQL\"")[
  - Desarrollado por Donald D. Chamberlin y Raymond F. Boyce, de la IBM
  - Structured Query Language, antes Structured English Query Language (Sequel)
  - Lenguaje utilizado para el manejo de información en RDBMS.
  - Emplea algebra relacional y cálculo relacional de tuplas, muy innovador y sencillo
  - Utilizado con datos estructurados
]

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  ¿Qué es una función hash?
]

#slide(title: "RDBMS", colwidths: (1.5fr, 1fr))[
  #align(horizon)[
  - Sistema gestor de bases de datos relacionales
  - Usa SQL como lenguaje para manejar la información
  - Utiliza el modelo relacional
  - Fuerte enfoque en ACID (Accesibilidad, Consistencia, _Isolation_, Durabilidad), que verifica para cada transacción.
  ]
][
  #image("assets/main_databases.jpg")
]

#slide(title: "Sharding")[
  #align(center)[
    #image("assets/Shard.svg", height: 60%)
  ]
]

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  10 millones de usuarios, ¿cómo escalamos la base de datos?
]

#slide(title: "Sharding")[
  #align(center)[
    #image("assets/Res1.svg", height: 65%)
  ]
]

#slide(title: "CAP")[
  Los sistemas pueden cubrir solo 2 características de entre:
  - Consistency: cómo se comporta el estado del sistema cuando se realiza una operación
  - Availability: Se puede continuar el servicio aunque existan fallas en hardware u otros nodos
  - Partition Tolerance: Cómo se desenvuelve el sistema cuando hay *islas* que no pueden conectarse entre si. Por ej, cuando agregamos/quitamos nodos
]

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  ¿Qué es lo que sacrifican los RDBMS de CAP?
]

#slide(title: "NoSQL")[
  - En general, todo lo que no es _SQL_. Es decir, que no sigue el modelo de datos relacional.
  - Implica que no se use el mismo ANSI/ISO SQL
  - Si damos menor prioridad a las retricciones que pone ACID se puede lograr escalabilidad y rendimiento. 
  - Menos consistencia e isolación para lograr disponibilidad y rendimiento.
]

#slide(title: "NoSQL")[
  Permite:
  - Manejo de datos estructurados y no estructurados
  - Facilita el desarrollo iterativo
  - Mejora la experiencia del desarrollador
  - Proporciona más herramientas para poder escalar mejor
  - Uso inteligente de índices, hashes, y cache
]

#new-section("Modelos de Datos")

#slide(title: "Key-Value")[
  - La información se representa de la forma $(K,V)$
  - Si queremos un valor, simplemente lo buscamos usando su llave
  - La llave $K$ es un nombre de archivo, texto plano, hash, URI, etc.
  - El valor $V$ es un _blob_ binario, puede almacenar lo que sea
  - El soporte de operaciones basado en el valor es limitado (p. ej buscar los usuarios que se llamen Daniel)
  - Multiples tipos: en memoria, en disco, híbrido
  - `Get(key)`
]

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  ¿Cómo será que se particiona una base de datos _Key-Value_?
]

#slide(title: "Wide-Column Stores")[
  - Familia de columnas
  - Similar a _Key-Value_, se ve de la forma $(K, (C, C, C, C, ...))$
  - Donde cada columna se ve de la forma $(K, V)$, es decir que se ve $(K, ((K_1, V_1), (K_2, V_2), ...))$
  - Suelen dar soporte para almacenar versiones de columna con una tercera llave de tiempo `Get(key, col, time)`
  - Algunos (p. ej Cassandra) permiten tener _agregados_ (columnas anidadas en columnas)
  - Partición eficiente en vertical y horizontal
  - `Get(key, col)`
]

#slide(title: "Document")[
  - Similar a _Key-Value_ de la forma $(K, V)$ donde $V$ es JSON, XML, o BSON.
  - Permite cambios en la estructura de la información
  - Se puede agregar soporte para más tipos de valores.
  - Algunos (p. ej. MongoDB) permiten tener colecciones de documentos
  - Se puede obtener atributos especificos del documento sin cargarlo todo 
  - Toda la información está contenida en el mismo documento
  - Se puede relacionar otros documentos usando su id
]

#slide[
  #text(size: 14pt)[
  ```json
  {
    "_id": "123456789",
    "title": "Introduction to NoSQL Databases",
    "author": {
      "name": "John Doe",
      "email": "john.doe@example.com"
    },
    "content": "NoSQL databases provide a flexible and scalable approach to data storage, allowing developers to...",
    "tags": ["NoSQL"],
    "date_published": "2023-01-15T08:00:00Z",
    "comments": [
      {
        "user": "Alice",
        "comment_text": "Great article! I learned a lot."
      },
      {
        "user": "Bob",
        "comment_text": "Could you elaborate on the sharding techniques mentioned?"
      }
    ]
  }
  ```
  ]
]


#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Quiz!!]

  ¿En dónde usarían una base de datos con este modelo?
]


#slide[
  #align(center)[
    #image(height: 75%, "assets/VS.svg")
  ]
]

#slide(title: "Graph")[
  - Utilizan teoría de grafos para almacenar los datos y representar relaciones.
  - Consiste en vértices que representan entidades y aristas que representan relaciones entre ellas
  - Brindan lenguajes de _consulta_ que facilitan el recorrido del grafo
  - Permiten hacer consultas complejas sin necesidad de joins
  - Por debajo usa los demás modelos para representar el grafo
]

/*
#slide(title: text(size: 0pt, "Representación"))[
  #image("assets/Internal.png", height: 80%)
]
*/

#slide(theme-variant: "wake up")[
  #text(size: 0.8 * 1em, weight: "light")[Ejemplo!!]

  Vamos a crear un _engine_ de recomendaciones, basado en las etiquetas de las publicaciones que hemos visto nosotros y lo usuarios que seguimos 
]

#slide[
  #align(center + horizon)[
    #image("assets/Problem.png", width: 75%)
  ]
]


#slide[
   #text(size: 18pt)[
   ```sql
  BEGIN;
      LET $seen = SELECT VALUE id 
        FROM (SELECT out.id as id 
            FROM ($auth.id)->view GROUP BY id LIMIT 100 );
      LET $seen_by_others = SELECT VALUE id 
        FROM (SELECT out.id as id 
            FROM ($auth.id)->follow->user->view GROUP BY id LIMIT 100);
      LET $seeng = array::union($seen, $seen_by_others);
      LET $a = SELECT * FROM $seeng->tagged->tag WHERE array::len(id) > 0;
      LET $tags = RETURN array::distinct(array::flatten($a));

      RETURN SELECT *, fn::is_sus(id) 
        FROM array::distinct(array::flatten((SELECT VALUE in.* FROM $tags<-tagged)));
  COMMIT;
  ```
   ]
]

#slide(title: "Publicaciones vistas")[
  #align(horizon)[
  #block[
   ```sql
  LET $seen = SELECT VALUE id FROM (
    SELECT out.id as id FROM ($auth.id)->view 
    GROUP BY id LIMIT 100 
  );

  LET $seen_by_others = SELECT VALUE id FROM (
    SELECT out.id as id FROM ($auth.id)->follow->user->view 
    GROUP BY id LIMIT 100
  );

  LET $seeng = array::union($seen, $seen_by_others);
  ```
  ]
  ]
]

#slide(title: "Etiquetas de pub")[
  #align(horizon)[
  #block[
   ```sql
  LET $tags_por_pub = SELECT * FROM $seeng->tagged->tag WHERE array::len(id) > 0;
  
  LET $tags = RETURN array::distinct(array::flatten($tags_por_pub));

  RETURN SELECT *, fn::is_sus(id) 
    FROM array::distinct(array::flatten((
            SELECT VALUE in.* FROM $tags<-tagged
    )));
  ```
  ]
  ]
]

#new-section("Cierre")

#slide(title: "Ventajas")[
  - Pueden ofrecer mejor experiencia al desarrollar
  - El modelo de datos es más simple de entender
  - Flexibilidad con la información que se almacena
  - Facilidad para realizar análisis sobre información profundamente relacionada
  - Facilidad para escalar de forma horizontal
]

#slide(title: "Desventajas")[
  - Son menos confiables por ser menos estrictos con ACID en cada transacción
  - No hay un lenguaje de manipulación de datos estándard
  - Hay que aprender nuevos lenguajes conceptos y herramientas para utilizarlas
  - Pocas herramientas para trabajar con ellas, como plataformas para _hostear_
]

#slide(theme-variant: "wake up")[
  Gracias!

  #set text(size: 12pt)

  #set enum(numbering: "[1]")

  + A. Davoudian, L. Chen, and M. Liu, "A Survey on NoSQL Stores," ACM Computing Surveys, vol. 51, no. 2. Association for Computing Machinery (ACM), pp. 1-43, Apr. 17, 2018. doi: 10.1145/3158661.
  + M. Besta et al., "Demystifying Graph Databases: Analysis and Taxonomy of Data Organization, System Designs, and Graph Queries." arXiv, 2019. doi: 10.48550/ARXIV.1910.09017.
  + Jing Han, Haihong E, Guan Le, and Jian Du, "Survey on NoSQL database," 2011 6th International Conference on Pervasive Computing and Applications. IEEE, Oct. 2011. doi: 10.1109/icpca.2011.6106531.
  + R. Angles and C. Gutierrez, “Survey of graph database models,” ACM Computing Surveys, vol. 40, no. 1. Association for Computing Machinery (ACM), pp. 1-39, Feb. 2008. doi: 10.1145/1322432.1322433.
  + ComputerWorld. "The Story So Far". Consultado en Nov 2023 Disponible en https://www.computerworld.com/article/2588199/the-story-so-far.html
  + Santhosh Kumar Gajendran. 2012. "A Survey on NoSQL Databases". (2012).
]
