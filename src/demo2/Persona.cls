/// Clase Persona
/// Es una clase Persistente
Class demo2.Persona Extends %Persistent
{

Property Nombre As %String;

Property Apellido As %String;

Property Direccion As demo2.Direccion;

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
<Value>Direccion</Value>
</Value>
</Data>
<DataLocation>^demo2.PersonaD</DataLocation>
<DefaultData>PersonaDefaultData</DefaultData>
<IdLocation>^demo2.PersonaD</IdLocation>
<IndexLocation>^demo2.PersonaI</IndexLocation>
<StreamLocation>^demo2.PersonaS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
