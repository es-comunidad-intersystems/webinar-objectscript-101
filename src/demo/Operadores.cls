Class demo.Operadores
{

ClassMethod EjemploQuit() As %String
{
    set a = "Hola"
    // quit a
    return a
}

ClassMethod EjemploLogica()
{
    set verdadero = 1
    set falso = 0
    write "verdadero && falso => ", verdadero && falso, !
    write "verdadero || falso => ", verdadero || falso, !
    write "NOT verdadero => ", ' verdadero, !
    write "verdadero & falso => ", verdadero & falso, !
    write "verdadero ! falso => ", verdadero ! falso, !
    write "verdadero || (543/falso) => ", verdadero || (543/falso), !
}

ClassMethod EjemploPrecedenciaLogica()
{
    set verdadero = 1
    set falso = 0
    if verdadero || (falso = 0) {
        write "TRUE"
    } else {
        write "FALSE"
    }
}

ClassMethod EjemploPrecedencia()
{
    write 3 + (2 * 5)
}

ClassMethod EjemploAritmetica()
{
    set dos = "2,Caracol2"
    set tres = dos + "1"
    set cinco = dos + tres
    write "2+3 = ", dos + tres, !
    write "2-3 = ", dos - tres, !
    write "2*3 = ", dos * tres, !
    write "2**3 = ", dos ** tres, !
    write "2/3 = ", dos / tres, !
    write "5\3 = ", cinco \ tres, !
    write "5#3 = ", cinco # tres, !
}

}
