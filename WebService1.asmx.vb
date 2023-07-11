Imports System.Web.Services
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
    Public Function HelloWorld() As String

        Dim theReturn = ""
        Dim sbOutput As StringBuilder = New StringBuilder()

        ' the constructor for the http context
        Dim theContext As HttpContext = HttpContext.Current
        ' file collection of uploaded files in the http context
        Dim Files As HttpFileCollection = theContext.Request.Files
        ' if something there then read the posted upload

        '''''''''''''''''''''''''''
        'Dim Data As String
        'Dim path As String = HttpContext.Current.Server.MapPath("~/file.txt")
        'If Not File.Exists(path) Then
        '    Dim createText As String() = {Files.Count}
        '    File.WriteAllLines(path, createText)
        'End If
        ''''''''''''''''''''''''''''
        Dim fs As Stream = Files(0).InputStream
        Dim br As New BinaryReader(fs)
        Dim bytes As Byte() = br.ReadBytes(Convert.ToInt32(fs.Length))

        'If Files.Count > 0 Then
        '    If 1 = Files.Count And 1 < Files(0).ContentLength Then
        '        theReturn += Files(0).ContentLength.ToString
        '        theReturn += Files(0).ContentType.ToString

        '        Using srFiledata As StreamReader = New StreamReader(Files(0).InputStream)
        '            sbOutput.Append(srFiledata.ReadToEnd())
        '        End Using
        '        ' double check to make sure this is valid upload
        '        ' to do code
        '        theReturn += sbOutput.ToString()
        '        ' now pick up the additional form fields

        '        theReturn += theContext.Request.Form("data1")
        '        'theReturn += theContext.Request.Form[2];
        '    End If
        '    ' here send back something to indicate that nothing was uploaded or it
        'End If

        ''''''''''''''''''data:audio/mpeg;base64

        'Dim byteAry() As Byte = bytes
        'Dim stream As MemoryStream = New MemoryStream(byteAry)
        'Dim wr As WaveReader = New WaveReader(stream)
        'Dim format As IntPtr = wr.ReadFormat()
        'Dim data() As Byte = wr.ReadData()
        'Dim ww As WaveWriter = New WaveWriter(File.Create(fileName + ".wav"), AudioCompressionManager.FormatBytes(format))
        'ww.WriteData(data)
        'ww.Close()

        'Dim bytes() As Byte = System.Convert.FromBase64String(theReturn)
        File.WriteAllBytes(HttpContext.Current.Server.MapPath("~/myFile.mp3"), bytes)

        'Dim Data As String
        'Dim path As String = HttpContext.Current.Server.MapPath("~/file.txt")
        'If Not File.Exists(path) Then
        '    Dim createText As String() = {theReturn.GetType().ToString}
        '    File.WriteAllLines(path, createText)
        'End If


        'Return "Hello World" & Data
    End Function

End Class