/// Description
Class demo.Calculadora
{

/// Description
ClassMethod Sumar(a As %Double, b As %Double) As %Double
{
    return a+b
}

/// Ejemplo de paso de argumento por referencia
ClassMethod DameUnNumeroAleatorio(ByRef numero As %Integer)
{
    write "1.numero = "_numero,!
    set numero = $RANDOM(100)
    write "2.numero = "_numero,!
}

}
