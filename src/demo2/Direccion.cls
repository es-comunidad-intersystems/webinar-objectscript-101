/// Description
Class demo2.Direccion Extends %SerialObject
{

Property Calle As %String;

Property CodigoPostal As %String;

Property Localidad As %String;

Property Provincia As %String;

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

}
