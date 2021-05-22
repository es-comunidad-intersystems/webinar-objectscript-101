/// Mi clase persona
Class demo.Persona Extends %RegisteredObject
{

Parameter departamento = "Contabilidad creativa";

Property nombre As %String;

Property "primer_apellido" As %String;

ClassMethod Crear(nombre As %String, apellido As %String) As demo.Persona
{
    #dim persona as demo.Persona
    set persona = ##class(demo.Persona).%New()
    set persona.nombre = nombre
    set persona."primer_apellido" = apellido
    do persona.hola()
    return persona
}

Method DecirHola()
{
    do ..hola()
}

/// Método de instancia 
Method hola()
{
    write "hola " _ ..nombre _ " " _ .."primer_apellido" _ "!!", !
    write "bienvenido a " _ ..#departamento _ "!!"
}

ClassMethod CambiarNombre(p As demo.Persona, nombre As %String)
{
    set p.nombre = nombre
}

/// Ejemplo de paso de argumento por referencia
ClassMethod DameUnNumeroAleatorio(ByRef numero As %Integer)
{
    write "1.numero = "_numero
    set numero = $RANDOM(100)
    write "2.numero = "_numero
}

}
