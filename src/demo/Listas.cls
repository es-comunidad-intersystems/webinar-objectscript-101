/// Description
Class demo.Listas
{

/// Description
ClassMethod EjemploLista()
{

    #dim lista as %ListOfDataTypes
    set lista = ##class(%ListOfDataTypes).%New()
    do lista.Insert("Hola")
    do lista.Insert("Adios")
    write "Numero de elementos", lista.Count(),!
    for iterador = 1:1:lista.Count() {
        write "Elemento "_iterador_": ",lista.GetAt(iterador),!
    }
}

}
