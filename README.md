# Webinar de ObjectScript desde cero

## Preparar una instancia de IRIS

Para poder comenzar con el webinar debemos tener una instancia de IRIS a la que conectarnos. Hay varias opciones pero la más sencilla es disponer de Docker y lanzar un contenedor. Para ello obtendremos la imagen de IRIS Community, en este caso la última versión es la 2021

```bash
docker pull store/intersystems/iris-community:2021.1.0.205.0
```

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

## Tipos de Datos

Las variables se consideran siempre como un string hasta que se demuestre lo contrario. No se declaran sin embargo se puede informar sobre su tipo mediante la directiva `#dim`.

Una varible puede contener un valor de tipo básico como `%String`, `%Integer`, `%Double`.

```objectscript
set a = "hola" // a es un string
set a = 23     // a es un valor entero
set a = 1.54   // a es un valor decimal
```

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

### Parametros

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
