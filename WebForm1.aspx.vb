Imports System.IO
Imports System.Web.Services

Public Class WebForm1
    Inherits System.Web.UI.Page

    Private Sub BindDynaicGrd()

        If Not Me.IsPostBack Then
            Dim dt As New DataTable()
            dt.Columns.AddRange(New DataColumn() {
                                    New DataColumn("Name", GetType(String)),
                                    New DataColumn("Play", GetType(String)),
                                    New DataColumn("Wave", GetType(String))
                                }
                                               )
            Dim files() As String = IO.Directory.GetFiles(MapPath("~/voices"))

            For Each eFile As String In files
                Dim iFile As New FileInfo(eFile)
                Dim NetFile As String = iFile.Name.Substring(0, iFile.Name.Length - 4)
                dt.Rows.Add(NetFile, "Alimohammad Eghbaldar", "")
            Next
            GridViewVocies.DataSource = dt
            GridViewVocies.DataBind()
        End If

    End Sub

    Private Sub WebForm1_Load(sender As Object, e As EventArgs) Handles Me.Load
        BindDynaicGrd()
    End Sub
End Class