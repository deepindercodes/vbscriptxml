<!--#include virtual="/includes/adovbs.inc"-->
<!--#include virtual="/includes/helperfunctions.asp"-->
<!--#include virtual="/includes/xmlinclude.asp"-->
<%
    Dim var_error
    var_error= ""

    Dim articleExists
    articleExists = false

    Dim categoryEdited
    categoryEdited = false

    Dim articletitle
    articletitle = ""

    Dim articleauthor
    articleauthor = "Administrator"

    Dim articlebody
    articlebody = ""

    Dim articleimage
    articleimage = ""

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
    end if
    set objXML = nothing

    if Request("btnEdit")="Edit" then

        
        articletitle = Trim(Request("txtarticletitle"))

        articleauthor = Trim(Request("txtarticleauthor"))

        articlebody = Trim(Request("txtarticlebody"))

        articleimage = Trim(Request("hdnarticleimage"))

        if articletitle="" then
            var_error = "Missing Article Title <br />"
        end if

        if articleauthor="" then
            var_error = var_error & "Missing Article Author <br />"
        end if

        if articlebody="" then
            var_error = var_error & "Missing Article Body <br />"
        end if

        if var_error<>"" then
            '//show error message
        else

            set objXML = server.CreateObject("Microsoft.XMLDOM")
            blnFileExists = objXML.Load(dbxmlpath)
            if blnFileExists = true then
                set objarticle = objXML.selectSinglenode("//article[@id="& id &"]")
                objarticle.selectSinglenode("articletitle").text = articletitle
                objarticle.selectSinglenode("articleauthor").text = articleauthor
                objarticle.selectSinglenode("articlebody").text = articlebody
                objarticle.selectSinglenode("articleimage").text = articleimage
                objarticle.selectSinglenode("modifiedonutc").text = currentUTCDateTime.GetVarDate (false)
            end if
            objXML.save dbxmlpath
            set objXML=nothing
            categoryEdited = true

        end if

        if categoryEdited = true then
            Response.Write("<script type='text/javascript'>parent.ArticleEdited();</script>")
            Response.End()
        end if

    end if

    

%>

<!--#include virtual="/includes/boostrap_include.asp"-->
<form method="post">

    <div class="container-fluid">

        <%
            if var_error<>"" then
                Response.Write("<div class='row p-2'>")

                Response.Write("<div class='col-sm-12'>")
                                
                Response.Write("<div class='alert alert-danger'>")
                Response.Write("<strong>"& var_error &"</strong>")
                Response.Write("</div>")

                Response.Write("</div>")
                                
                Response.Write("</div>")
            end if
        %>

        <div class="row">

            <div class="col-sm-4">
                Title
            </div>
            <div class="col-sm-8">
                <input type="text" name="txtarticletitle" id="txtarticletitle" value="<%=articletitle %>" class="form-control" style="width:99%" required="required" />
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-4">
                Author
            </div>
            <div class="col-sm-8">
                <input type="text" name="txtarticleauthor" id="txtarticleauthor" value="<%=articleauthor %>" class="form-control" style="width:99%" required="required" />
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-4">
                Body
            </div>
            <div class="col-sm-8">
                <textarea id="txtarticlebody" name="txtarticlebody" class="form-control" style="width:99%" rows="10"><%=articlebody %></textarea>
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-4">
                Article Image
            </div>
            <div class="col-sm-8">
                <input type="file" id="fileArticleImage" class="form-control" style="width:99%" />
                <img id="imagArticlePreview" src="<%=articleimage %>" class="img-fluid" style="max-width:200px;margin-top:5px" />
                <input type="hidden" id="hdnarticleimage" name="hdnarticleimage" value="<%=articleimage %>" />
                <script type="text/javascript">
                    function readFile() {

                        document.querySelector("#imagArticlePreview").src = "";

                        if (!this.files || !this.files[0]) return;

                        const FR = new FileReader();

                        FR.addEventListener("load", function (evt) {
                            document.querySelector("#hdnarticleimage").value = evt.target.result;
                            document.querySelector("#imagArticlePreview").src = evt.target.result;
                            //document.querySelector("#b64").textContent = evt.target.result;
                        });

                        FR.readAsDataURL(this.files[0]);

                    }

                    document.querySelector("#fileArticleImage").addEventListener("change", readFile);
                </script>
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

        <div class="row">

            <div class="col-sm-12 text-center">
                <input type="submit" id="btnAdd" name="btnEdit" value="Edit" class="btn btn-danger" />
            </div>

        </div>


        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

    </div>

</form>