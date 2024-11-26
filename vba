**************************************filter mail
Sub SplitWorksheetIntoNewWorkbooks()
    Dim ws As Worksheet
    Dim columnName As String
    Dim colIndex As Long
    Dim uniqueValues As Collection
    Dim cell As Range
    Dim filteredRange As Range
    Dim newWorkbook As Workbook
    Dim uniqueVal As Variant
    Dim i As Long
    Dim lastRow As Long
    
    ' Set the worksheet to the currently active sheet
    Set ws = ActiveSheet
    
    ' Prompt the user for the column name
    columnName = InputBox("Enter the column name to filter:")
    If columnName = "" Then Exit Sub
    
    ' Find the column index based on the column name
    On Error Resume Next
    colIndex = ws.Rows(1).Find(What:=columnName, LookIn:=xlValues, LookAt:=xlWhole).Column
    On Error GoTo 0
    
    If colIndex = 0 Then
        MsgBox "Column not found. Please check the column name.", vbExclamation
        Exit Sub
    End If
    
    ' Get the last row with data in the selected column
    lastRow = ws.Cells(ws.Rows.Count, colIndex).End(xlUp).Row
    
    ' Get unique values from the column
    Set uniqueValues = New Collection
    On Error Resume Next
    For i = 2 To lastRow
        uniqueValues.Add ws.Cells(i, colIndex).Value, CStr(ws.Cells(i, colIndex).Value)
    Next i
    On Error GoTo 0
    
    ' Loop through each unique value and split data into new workbooks
    For Each uniqueVal In uniqueValues
        ' Filter the data based on the unique value
        ws.UsedRange.AutoFilter Field:=colIndex, Criteria1:=uniqueVal
        
        ' Copy visible cells to a new workbook
        Set filteredRange = ws.UsedRange.SpecialCells(xlCellTypeVisible)
        Set newWorkbook = Workbooks.Add
        
        ' Paste the data as values and formats
        filteredRange.Copy
        With newWorkbook.Sheets(1).Cells(1, 1)
            .PasteSpecial Paste:=xlPasteValues
            .PasteSpecial Paste:=xlPasteFormats
        End With
        Application.CutCopyMode = False ' Clear the clipboard
        
        ' Rename the sheet to the unique value (shortened if needed)
        Dim sheetName As String
        sheetName = Left(CStr(uniqueVal), 31) ' Ensure sheet name does not exceed 31 characters
        
        ' Replace any invalid characters for sheet names
        sheetName = Replace(sheetName, "/", "_")
        sheetName = Replace(sheetName, "\", "_")
        sheetName = Replace(sheetName, ":", "_")
        sheetName = Replace(sheetName, "?", "_")
        sheetName = Replace(sheetName, "*", "_")
        sheetName = Replace(sheetName, "[", "_")
        sheetName = Replace(sheetName, "]", "_")
        
        On Error Resume Next ' Handle potential name conflicts
        newWorkbook.Sheets(1).Name = sheetName
        On Error GoTo 0
        
        ' Save the new workbook (file name includes column name but sheet name does not)
        newWorkbook.SaveAs Filename:=ThisWorkbook.Path & "\" & sheetName & ".xlsx"
        newWorkbook.Close SaveChanges:=True
    Next uniqueVal
    
    ' Remove filter from the original worksheet
    ws.AutoFilterMode = False
    
    MsgBox "Worksheets have been split successfully!"
End Sub

****************************************Send mail
Sub sendEmailsToMultiplePersonsWithMultipleAttachments()

Dim OutApp As Object
Dim OutMail As Object
Dim sh As Worksheet
Dim cell As Range
Dim FileCell As Range
Dim rng As Range

With Application
    .EnableEvents = False
    .ScreenUpdating = False
End With

Set sh = Sheets("Sheet1")

Set OutApp = CreateObject("Outlook.Application")

For Each cell In sh.Columns("A").Cells.SpecialCells(xlCellTypeConstants)

    'path/file names are entered in the columns D:M in each row
    Set rng = sh.Cells(cell.Row, 1).Range("D1:M1")
    
    If cell.Value Like "?*@?*.?*" And _
    Application.WorksheetFunction.CountA(rng) > 0 Then
        Set OutMail = OutApp.CreateItem(0)
        
        With OutMail
            .TO = sh.Cells(cell.Row, 1).Value
            .CC = sh.Cells(cell.Row, 8).Value
            .Subject = sh.Cells(cell.Row, 2).Value
            .Body = sh.Cells(cell.Row, 3).Value
            .Attachments.Add (sh.Cells(cell.Row, 4).Value)
            
            'For Each FileCell In rng.SpecialCells(xlCellTypeConstants)
                
               ' If Trim(FileCell.Value) <> "" Then
                    'If Dir(FileCell.Value) <> "" Then
                        '.Attachments.Add FileCell.Value
                  '  End If
                'End If
           ' Next FileCell
            
            
            .Send
            '.display
        End With
        
        Set OutMail = Nothing
    End If
Next cell

Set OutApp = Nothing

With Application
    .EnableEvents = True
    .ScreenUpdating = True
End With


End Sub



