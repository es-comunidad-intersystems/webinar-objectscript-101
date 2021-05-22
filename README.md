# webinar-objectscript-101

Webinar de ObjectScript desde cero

## Obtener IRIS

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
    },
    "workbench.colorTheme": "InterSystems Default Dark"
}
```
