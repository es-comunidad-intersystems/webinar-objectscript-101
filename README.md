# Webinar de ObjectScript desde cero

## Preparar una instancia de IRIS

Para poder comenzar con el webinar debemos tener una instancia de IRIS a la que conectarnos. Hay varias opciones, pero la más sencilla es disponer de Docker y lanzar un contenedor. Para ello obtendremos la imagen de IRIS Community, en este caso la última versión es la 2021

```bash
docker pull store/intersystems/iris-community:2021.1.0.205.0
```
La versión con el tiempo irá cambiando por lo que antes de ejecutar el comando anterior es mejor visitar Docker Hub

- [Imagen de IRIS Communitiy Edition](https://hub.docker.com/r/intersystems/iris-community) 
- [Imagen de IRIS For Healt Community Edition](https://hub.docker.com/r/intersystems/irishealth-community)

luego tan solo debemos iniciar el contenedor. Una forma es utilizar docker-compose definiendo un fichero `yml` y especificando la imagen que queremos usar. No debemos olvidarnos de abrir el puerto `52773` al host para poder interactuar con la instancia.

```yml
version: "3.6"
services:
  iris:
    container_name: iris_basico
    image: store/intersystems/iris-community:2021.1.0.205.0
    restart: always
    ports:
      - 52773:52773
```

levantar el contenedor con

```bash
docker compose up
```

Una vez tengamos la instancia levantada acceder al portal para cambiar la password del superusuario accediendo a
[http://localhost:52773/csp/sys/UtilHome.csp](http://localhost:52773/csp/sys/UtilHome.csp)

Vamos a usar VSCode y para ello tendremos que instalar este pack de extensiones:
[InterSystems ObjectScript Extension Pack](https://marketplace.visualstudio.com/items?itemName=intersystems-community.objectscript-pack)

Por último debemos configurar el fichero `.vscode/settings.json` para indicar a la extensión de VSCode Objectscript como conectarse a la instancia

```json
{
    "intersystems.servers": {
        "iris-basico": {
            "webServer": {
                "scheme": "http",
                "host": "localhost",
                "port": 52773
            },
            "description": "instancia IRIS para webinar",
            "username": "superuser"
        }
    },
    "objectscript.conn": {
        "server": "iris-basico",
        "ns": "USER",
        "active": true
    }
}
```

Para interactuar con la instancia en los ejemplos podemos usar el terminal integrado en IRIS. En este webinar usaremos el terminal web que se puede obtener desde [Intersystems Web Terminal](https://intersystems-community.github.io/webterminal/)

La instalación es muy sencilla tan solo es necesario importar el XML que se descarga.

## Comandos y Variables

Comenzamos con objectscript, los primeros comandos a entender son los siguientes:

- `SET`, set, s
- `WRITE`, write, w
- `KILL`, kill, k

Mediante `set` asignamos un valor a una variable pero tambien la hacemos existir. Una variable existe desde que se le asigna un valor y deja de exitir cuando se hace un `kill` sobre ella. El comando `write` nos devuelve el valor de una variable por pantalla. Si la variable no existe devolverá `<UNDEFINED>`

## Variables especiales

En ObjectScript existen variables especiales que son accesibles desde cualquier contexto. Estas variables comienzan con el carácter `$`, por ejemplo `$username` o `$namespace`.

## Clases

Podemos declarar una clase mediante `Class`. Las clases tienen paquete y nombre, los paquetes pueden anidarse creando una estructura, por ejemplo `demo.webinar.ClaseA`.

### Advertencia

No se permite comenzar una sentencia al inicio de la línea, debe haber al menos un espacio en blanco

### Comentarios

Dentro de una clase podemos usar `//` para comentarios y `///` para documentar la clase o el método.

### Métodos de clase

En una clase sin SuperClase podemos declarar métodos de clase. Los métodos de clase se declaran mediante `ClassMethod` y se invocan mediante `##class(paquete.Clase)`, por ejemplo:

```objectscript
do ##class(paquete.Clase).Metodo()
```

Si el método devuelve un valor la declaración se realiza de la siguiente manera:

```objectscript
ClassMethod Sumar(a As %Integer, b As %Integer) As %Integer
{
    return a+b
}
```

En ocasiones se usa el comando `quit` para devolver el valor de retorno. El comando `return` simpre devuelve el resultado, mientras que el comando `quit` sirve tambien para detener la ejecución de un bloque de código como en otros lenguajes el `break`.

El comando `do` sirve para ejecutar un método, pero si ese método devuelve un valor para obtenerlo usaremos `set`, por ejemplo:

```objectscript
set variable = ##class(paquete.Clase).Metodo()
```

## Macros  

Se definen en un fichero que se debe guardar con extensión `inc`. Se declaran mediante `#define`. Ejemplo:

```objectscript
ROUTINE MiMacro [Type=INC]

#define ROJO "red"
#define VERDE "green"
#define AZUL "blue"
```

Para utilizarla en una clase se debe asociar el fichero con `Include` y referenciar la macro mediante `$$$` ejemplo:

```objectscript
Include MiMacro

Class demo.UsoDeMacro
{

  ClassMethod probar()
  {
    write $$$ROJO
  }

}
```

## Tipos de Datos

Las variables se consideran siempre como un string hasta que se demuestre lo contrario. No se declaran sin embargo se puede informar sobre su tipo mediante la directiva `#dim`.

Una varible puede contener un valor de tipo básico como `%String`, `%Integer`, `%Double`.

```objectscript
set a = "hola" // a es un string
set a = 23     // a es un valor entero
set a = 1.54   // a es un valor decimal
```

No existe true o false, se utiliza 1 y 0

## Fechas

Otro tipo de datos es el `%Date` y el `%DateTime`, el formato interno de las fechas en ObjectScript es `dias,segundos`. La fecha y hora del sistema se puede obtener mediante la variable especial `$horolog`. Si se necesita más precisión se puede utilizar la variable especial `$ZTIMESTAMP` (devuelve la fecha UTC como `dias,seguundos.milisegundos`)

Para convertir desde el formato interno a un formato legible se utiliza `$ZDATE()` y `$ZDATETIME()`. Para convertir de un formato cadena al formato interno se utiliza `$ZDATEH()` y `$ZDATETMEH()`.

## Procesando cadenas de texto

Hay muchas funciones para tratar cadenas de texto, ejemplo:

```objectscript
    write "UPPERCASE:",$ZCONVERT(cadena,"U"),!
    write "LOWERCASE:",$ZCONVERT(cadena,"L"),!
    write "REEMPLAZAR CARÁCTERES:",$TRANSLATE(cadena,"o","0"),!
    write "REEMPLAZAR CADENA":,$REPLACE(cadena,"que","un")
    write "QUITAR ESPACIOS:",$TRANSLATE(cadena," "),!
    write "HACER TRIM:",$ZSTRIP(cadena,"<>W"),!
    write "EXTRAER DEL 5 al 15:",$EXTRACT(cadena,5,15),!
    write "SEPARANDO POR ' ':",$PIECE(cadena," ",2),!
```

## Operadores

No hay precedencia de operadores *implicita*, es estricta de izquierda a derecha, hay que usar parentesis para obligar a evaluar en operaciones arimeticas y lógicas

Algunos operadores fuera de lo normal

- División entera `\`
- Módulo o resto `#`
- Exponencial `**`
- Negación `'`
- Concatenación `_`
- Comparación `=`

## Comandos de control y Funciones de decisión

Tenemos el comando `if condicion {}` con `elseif{}` y `else{}`.

No tenemos `switch` pero se disponen de las funciones `$SELECT` y `$CASE`

```objectscript
set name=$CASE(number,1:"one",2:"two",3:"three",:"other")
set name=$SELECT(number=1:"one",number=2:"two",number=3:"three",1:"other")
```

Para iterar tenemos el `for iterador=desde:paso:hasta {}` y el `while condicion {}` aunque podemos usar la postcondición `do {} while condicion`

## Objetos

Si queremos instanciar objetos de una clase entonces debemos hereder directa o indirectamente de `%RegisteredObject`. Esta clase nos facilita el método de clase `%New()` mediante el cual podemos instanciar un objeto.

Una clase puede tener propiedades que se declaran mediante `Property` así como métodos de instancia que se declaran con `Method`.

Cuando instanciamos un objeto lo asociamos a una variable. En ese momento la variable contiene un `OREF` (referencia a un objeto). Podemos acceder a los métodos y propiedades de un objeto mediante el mecanismo `objeto.propiedad`

Ejemplo:

```objectscript
set persona = ##class(Sample.Person).%New()
set persona.Name = "Pepito Grillo"
do persona.PrintPerson()
```

Dentro de un método de instancia de una clase podemos referenciar propiedades y métodos del propio objeto mediante `..`

Ejemplo:

```objectscript
Class demo.ClaseInstanciable
{

Property color as %String;

Method setColor (color as %String) {
    set ..color = color
}

}
```

### Parámetros

Las clases pueden disponer de constantes para la clase mediante `Parameter`. La referencia a un `Parameter` dentro de una clase se realiza mediante `..#`.

### Propiedades

Las propiedades tienen un tipo y se declaran como `Property prop as %String`. Además las propiedades pueden tener modificadores como `(MAXLEN)` y `(VALUELIST)` o `[Required]` y `[InitialExpression]`.

### Paso de argumento a Métodos

Los argumentos que se pasan a un método puede ser por valor o por referencia. Por defecto se pasa por valor. Para pasar un argumento por referencia se debe anteponer un `.` a la variable que se pasa como argumento.

Ejemplo:

```objectscript
// Paso por valor
d ##class(demo.Calculadora).DameUnNumeroAleatorio(numero)
// Paso por referencia
d ##class(demo.Calculadora).DameUnNumeroAleatorio(.numero)
```

Se suele utilizar las palabras clave `ByVal` y `ByRef` para informar si un parámetro se debe pasar por valor o por referencia, pero es meramente informativo.

# Webinar de Persistencia

## Esas cosas mágicas llamadas Globals

Los Globals son **Estructuras de datos persistentes**.

En ObjectScript realmente existen dos tipos de variables:

- Variables locales transitorias en memoria
- Variables “globales” que son persistentes

Los globals son estructuras multi-dimensionales (una estructura en árbol con tantas dimensiones como se necesiten, sin límite y sin definición previa).

Los globals siempre comienzan con el carácter `^`

- `^nombre`
- `^lugares`

Los Globals se usan como cualquier variable

- SET: `set ^nombre = "Elber"`
- WRITE: `write ^nombre`
- KILL: `kill ^nombre`

Es posible utilizar varias dimensiones definiendo el sub-índice del array entre parentesis y separados por comas

- `set ^nombres(1)="Rosa"`
- `set ^nombres(2)="Elber"`

Los Globals se persisten **automáticamente** al establecer su valor mediante el comando SET

Los globals no necesitan pre-definir las dimensiones, se hace automáticamente

Podemos utilizar números y cadenas como sub-índices

- `set ^persona(1,”nombre”)="Benito"`
- `set ^persona(1,”apellido”)="Camelas"`

Se almacenan como Sparse-Arrays no hay “huecos” libres entre nodos del árbol

Algunas funciones de utilidad

- ZWRITE (ZW): Escribe el nodo actual y sus nodos derivados
- ZKILL (ZK): Elimina solo el nodo individual
- $DATA: Indica la existencia de valor en el Global
- $GET: Obtiene el valor almacenado en un Global
- $ORDER: Obtiene el siguiente índice de un Global

## Bienvenidos a los objetos persistentes

Una clase contiene propiedades y métodos. Una propiedad es una definición de un elemento de datos. Un objeto es una estructura construida desde la definición de clase que contiene las propiedades de la clase. Un objeto persistente puede ser almacenado en disco. Al ser guardado se le asigna un identificador único.

### Métodos de Clases Persistentes

| **Método**    | **Propósito**                                     | **Éxito**  | **Fallo**     |
| ------------- | ------------------------------------------------- | ---------- | ------------- |
| `%New()`        | Crea  un nuevo objeto en memoria                  | object     | ""            |
| `%Save()`       | Guarda  un objeto                                 | 1          | error  status |
| `%Id()`        | Devuelve  el Id de un objeto guardado             | object  ID | ""            |
| `%OpenId(id)` | Recupera  un objeto de disco y lo pone en memoria | object     | ""            |
| `%DeleteId(id)` | Borra un objeto guardado                | 1             | error status |
| `%DeleteExtent()` | Borra todos los objetos  guardados      | 1             | error status |
| `%KillExtent()`   | Borra todos los objetos  guardados      | 1             | ""           |

Cuando un objeto se persiste se puede obtener mediante la ejecución de una sentencia SQL. El objeto se verá como un registro en una tabla relacional. Esta es la asociación entre los diferentes elementos de cada paradigma:

| **Orientación a Objetos**   | **SQL**                             |
| --------------------------- | ----------------------------------- |
| Paquete                     | Esquema                             |
| Clase                       | Tabla                               |
| Objeto                      | Fila                                |
| Propiedad                   | Columna                             |
| Método                      | Procedimiento  Almacenado           |
| Relación  entre dos objetos | Clave  foránea, otras restricciones |

Por ejemplo al crear una clase `Persona` con propiedades `Nombre` y `Apellido`, `Ciudad` y crear varios objetos y guardarlos, virtualmente estaremos creando registros en una tabla.

Probemos a crear una clase persistente:

```Objectscript
Class demo2.Persona Extends %Persistent
{
    Property Nombre As %String;
    Property Apellido As %String;
}
```

Añadir algunos objetos y luego hacer una select sobre la tabla. Esto se puede hacer desde el Portal de Gestión o también se puede hacer usando el Shell de SQL disponible desde un terminal ejecutando `do $system.SQL.Shell()`

De esta forma si ejecutamos:

```Sql
select ID, Nombre, Apellido from demo2.Persona
```

obtendremos

| **ID** | **Nombre** | **Apellido**
| ------ | ---------- | -------------
| 1      | Rosa       | Melano
| 2      | Elber      | Galarga
| 3      | Lucho      | Portuano

Cuando se compila una clase Persistente se crea un bloque XML dentro del fichero que tiene esta pinta:

```Xml
Storage Default
{
<Data name="PersonaDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Nombre</Value>
</Value>
<Value name="3">
<Value>Apellido</Value>
</Value>
<Value name="4">
<Value>Ciudad</Value>
</Value>
</Data>
<DataLocation>^demo2.PersonaD</DataLocation>
<DefaultData>PersonaDefaultData</DefaultData>
<IdLocation>^demo2.PersonaD</IdLocation>
<IndexLocation>^demo2.PersonaI</IndexLocation>
<StreamLocation>^demo2.PersonaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}
```

Es lo que se denomina el `Storage` de la clase. En el `Storage` de una clase Persistente se define en que Global se guardan los datos de esta clase y en que formato. En el ejemplo anterior los datos (objetos) se van a guardar en el Global `^demo.PersonaD` como viene indicado en `DataLocation`.

Probad a ejecutar:

```Objectscript
zwrite ^demo2.PersonaD
```

Lo divertido del asunto es que tambien podemos ejecutar sentencias `INSERT`, `UPDATE` y `DELETE` sobre la tabla.

El `Storage` mola pero mucho ojito con él. Si le cambias el nombre a una propiedad de la clase al compilar se modifica pero lo más problable es que erroneamente (conservando la propiedad antigua). Lo bueno es que si se borra del fichero se generará de nuevo.

## Clases Serial

Una clase serial es un tipo especial de persistencia, incluye métodos y propiedades al igual que una clase persistente. Pero un objeto serial se guarda al disco (persiste) solo cuando está embebido dentro de un objeto persistente.

Las clases serial son aquellas que heredan de la clase `%SerialObject`

Cuando se compila una clase Serial se crea un `Storage`, pero sin embargo en el mismo no se define un global donde almacenar los objetos.

```Xml
Storage Default
{
<Data name="DireccionState">
<Value name="1">
<Value>Calle</Value>
</Value>
<Value name="2">
<Value>CodigoPostal</Value>
</Value>
<Value name="3">
<Value>Localidad</Value>
</Value>
<Value name="4">
<Value>Provincia</Value>
</Value>
</Data>
<State>DireccionState</State>
<StreamLocation>^demo2.DireccionS</StreamLocation>
<Type>%Storage.Serial</Type>
}
```

Esto es así porque los objetos Serial se guardan "serializados" dentro de un campo del objeto persistente que lo utilize. Sin embargo y de manera transparente podemos hacer referencia a las propiedades de un objeto Serial embebido dentro de un objeto Persistente.

```Objectscript
set persona = ##class(demo2.Persona).%OpenId(123)
write persona.Direccion.Provincia
```

Y en SQL podemos hacerlo así:

```Sql
select ID, Nombre, Apellido, Direccion_Calle from demo2.Persona
```

## ¿Qué pasa con la herencia en las clases persistentes?

Muy buena pregunta, se nota que estás atento. Veamos un ejemplo:

```ObjectScript
Class demo2.Empleado Extends demo2.Persona
{

Property cargo As %String;

Storage Default
{
<Data name="EmpleadoDefaultData">
<Subscript>"Empleado"</Subscript>
<Value name="1">
<Value>cargo</Value>
</Value>
</Data>
<DefaultData>EmpleadoDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
```

Curioso, ya no tenemos `DataLocation`. Esto es porque utilizará el mismo `DataLocation` que el indicado en el `Storage` de la clase padre.

Crea un empleado con cargo y visualiza el Global `^demo2.PersonaD`

Sin embargo tenemos una tabla para empleados, prueba `select * from demo2.Empleado`. Pero ojo, con los identificadores. El identificador del "registro" empleado es el mismo que el de la persona.

## Relacionar objetos persistentes

¿Cómo podremos relacionar objetos persistentes? bien, que tipos de relaciones podemos tener. En principio veamos relaciones uno-a-uno y relaciones uno-a-muchos.

En una relación uno a uno es fácil crear una propiedad que sea del tipo del objeto destino. Por ejemplo:

```Objectscript
Property Responsable As demo2.Persona;
```

En este caso podremos acceder de manera sencilla a propiedades del objeto destino, por ejemplo:

```Objectscript
set e=##class(demo2.Empleado).%OpenId(123)
write e.Responsable.Nombre;
```

Una relación uno a muchos puede realizarse creando una propiedad de tipo Lista (`%ListOfObjects`). Sin embargo con este tipo de propiedades no podremos controlar la integridad referencial. Es decir, evitar que un objeto relacionado se elimine dejando la relación en un estado incongruente.

Para disponer de relaciones uno a muchos con integridad referencial podemos usar `Relationship`.

Ejemplo, clase Departamento:

```Objectscript
Class demo2.Departamento Extends %Persistent
{
  Property Nombre As %String;
  Relationship Empleados As demo2.Empleado [ Cardinality = many, Inverse = Departamento ];
}
```

Y clase Empleado

```Objectscript
Class demo2.Empleado Extends demo2.Persona
{

Property Cargo As %String;
Property Responsable As demo2.Persona;
Relationship Departamento As demo2.Departamento [ Cardinality = one, Inverse = Empleados ];
}
```

Podemos buscar todos los empleados por departamento en una SQL

```Sql
select d.Nombre, e.Apellido 
from demo2.Departamento d join demo2.Empleado e on e.Departamento = d.ID
```

Desde el punto de vista del empleado el departamento es como un objeto relacionado y desde el punto de vista del departamento los empleados son una colección de tipo lista que podemos manejar con métodos:

| Método                         | Proposito                   | Éxito       | Fallo       |
| ------------------------------ | --------------------------- | ------------- | ------------- |
| Insert()  InsertObjectId(*id*) | Añade un objeto a la relación | 1             | error  status |
| GetAt(*item*)                  | Recuperar objeto *item*     | objeto        | ""            |
| RemoveAt(*item*)               | Quitar objeto *item*       | id  de *item* | ""            |
| Count()                        | Contar elementos               | integer       |               |
| Clear()                        | Vaciar relación        | 1             | error  status |
