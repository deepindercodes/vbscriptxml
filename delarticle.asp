<!--#include virtual="/includes/xmlinclude.asp"-->
<%
    Dim id
    id=Int(Request("id")&"")

    set objXML = server.CreateObject("Microsoft.XMLDOM")
    blnFileExists = objXML.Load(dbxmlpath)
    if blnFileExists = true then
        set objarticle = objXML.selectSinglenode("//article[@id="& id &"]")
        objarticle.parentNode.removeChild(objarticle)
    end if
    objXML.save dbxmlpath
    set objXML=nothing

    Response.Redirect("/")
%>