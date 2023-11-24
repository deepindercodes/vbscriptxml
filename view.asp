<!--#include virtual="/includes/xmlinclude.asp"-->
<%
    Dim articletitle
    articletitle = ""

    Dim articleauthor
    articleauthor = "Administrator"

    Dim articlebody
    articlebody = ""

    Dim articleimage
    articleimage = ""

    Dim createdonUTC
    createdonUTC = ""

    Dim id
    id=Int(Request("id")&"")

    set objXML = server.CreateObject("Microsoft.XMLDOM")
    blnFileExists = objXML.Load(dbxmlpath)
    if blnFileExists = true then
        set objarticle = objXML.selectSinglenode("//article[@id="& id &"]")
        articletitle = objarticle.selectSinglenode("articletitle").text
        articleauthor = objarticle.selectSinglenode("articleauthor").text
        articlebody = objarticle.selectSinglenode("articlebody").text
        articleimage = objarticle.selectSinglenode("articleimage").text
        createdonUTC = objarticle.selectSinglenode("createdonutc").text
    end if
    set objXML=nothing
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title><%=articletitle %></title>
    <!--#include virtual="/includes/boostrap_include.asp"-->
</head>
<body>

    <div class="container">

        <div class="row">
            <div class="col-sm-1">
                &nbsp;
            </div>
            <div class="col-sm-10">
                <ul class='list-group'>
                    <li class='list-group-item fs-5 p-3 bg-primary text-white'><%=articletitle %></li>
                    <li class='list-group-item p-2'>
                        <p>
                            <%
                                if articleimage<>"" then
                                    Response.Write("<img class='img-fluid rounded' style='max-width:200px;margin:15px;float:left' src='"& articleimage &"' />")
                                end if
                            %>
                            <b>Author:</b>&nbsp;<%=articleauthor %><br />
                            <b>Date (UTC):</b>&nbsp;<%=createdonUTC %><br /><br />
                            <%=articlebody %>
                        </p>
                    </li>
                </ul>
            </div>
            <div class="col-sm-1">
                &nbsp;
            </div>
        </div>
    </div>


</body>
</html>