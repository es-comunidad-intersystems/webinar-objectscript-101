Class demo.FuncionesString
{

ClassMethod EjemploString()
{
    set cadena  = " Como Mola la graMola    "
    write "UPPERCASE:",$ZCONVERT(cadena,"U"),!
    write "LOWERCASE:",$ZCONVERT(cadena,"L"),!
    write "REEMPLAZAR:",$TRANSLATE(cadena,"o","0"),!
    write "QUITAR ESPACIOS:",$TRANSLATE(cadena," "),!
    write "HACER TRIM:",$ZSTRIP(cadena,"<>W"),!
    write "EXTRAER DEL 5 al 15:",$EXTRACT(cadena,5,15),!
    write "SEPARANDO POR ' ':",$PIECE(cadena," ",2),!
}

}
