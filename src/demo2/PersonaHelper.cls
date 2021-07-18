/// Clase de ayuda para los ejemplos
Class demo2.PersonaHelper
{

/// Poblar la tabla Persona
ClassMethod Poblar()
{
    // Eliminar todos los registros de una vez
    do ##class(demo2.Persona).%DeleteExtent()

    // Crear los registros
    #dim p as demo2.Persona
    set p = ##class(demo2.Persona).%New()
    set p.Nombre = "Rosa"
    set p.Apellido = "Melano"
    set p.Direccion.Calle = "Calle Jon, 24"
    set p.Direccion.Localidad = "Cantones"
    set p.Direccion.Provincia = "Toledo"
    set p.Direccion.CodigoPostal = "9090"
    do p.%Save()

    set p = ##class(demo2.Persona).%New()
    set p.Nombre = "Elber"
    set p.Apellido = "Galarga"
    set p.Direccion.Calle = "Avenida de los Gañanes"
    set p.Direccion.Localidad = "Pirulines"
    set p.Direccion.Provincia = "Sevilla"
    set p.Direccion.CodigoPostal = "8080"    
    do p.%Save()

    set p = ##class(demo2.Persona).%New()
    set p.Nombre = "Lucho"
    set p.Apellido = "Portuano"
    set p.Direccion.Calle = "Travesia de los lamentos"
    set p.Direccion.Localidad = "Meloneras"
    set p.Direccion.Provincia = "Murcia"
    set p.Direccion.CodigoPostal = "4040"    
    do p.%Save()
}

/// Crear un empleado
ClassMethod Contratar()
{
    // Eliminar todos los registros de una vez
    do ##class(demo2.Empleado).%DeleteExtent()
    do ##class(demo2.Departamento).%DeleteExtent()

    #dim dpto as demo2.Departamento
    set dpto = ##class(demo2.Departamento).%New()
    set dpto.Nombre = "Tecnología de la Información"
    do dpto.%Save()

    #dim e as demo2.Empleado
    set e = ##class(demo2.Empleado).%New()
    set e.Nombre = "Elvis"
    set e.Apellido = "Cocho"
    set e.Direccion.Calle = "Camino de la Marmota"
    set e.Direccion.Localidad = "Zilotes"
    set e.Direccion.Provincia = "Vigo"
    set e.Direccion.CodigoPostal = "7070"
    set e.Cargo = "Director"
    set e.Responsable = ##class(demo2.Persona).%OpenId(1)
    set e.Departamento = dpto

    do e.%Save()
}

}
