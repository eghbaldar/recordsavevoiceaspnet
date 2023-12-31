﻿Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.ComponentModel
Imports System.IO

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<System.Web.Services.WebService(Namespace:="http://tempuri.org/")> _
<System.Web.Services.WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)>
<ToolboxItem(False)>
Public Class WebService1
    Inherits System.Web.Services.WebService

    <WebMethod()>
    Public Sub RecordVoice()

        Dim sbOutput As StringBuilder = New StringBuilder()
        Dim theContext As HttpContext = HttpContext.Current
        Dim Files As HttpFileCollection = theContext.Request.Files
        Dim fs As Stream = Files(0).InputStream
        Dim br As New BinaryReader(fs)
        Dim bytes As Byte() = br.ReadBytes(Convert.ToInt32(fs.Length))

        Dim filename As String = Guid.NewGuid().ToString
        File.WriteAllBytes(HttpContext.Current.Server.MapPath("~/voices/" & filename & ".mp3"), bytes)

    End Sub

End Class