<!--#include virtual="/includes/adovbs.inc"-->
<!--#include virtual="/includes/helperfunctions.asp"-->
<!--#include virtual="/includes/xmlinclude.asp"-->
<%
    Dim var_error
    var_error= ""

    Dim articleExists
    articleExists = false

    Dim articleAdded
    articleAdded = false

    Dim articletitle
    articletitle = ""

    Dim articleauthor
    articleauthor = "Administrator"

    Dim articlebody
    articlebody = ""

    Dim articleimage
    articleimage = ""

    if Request("btnAdd")="Add" then
        
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
            if blnFileExists = false then
                set objPI = objXML.createProcessingInstruction("xml", "version='1.0'")
                objXML.insertBefore objPI, objXML.childNodes(0)

                set objRoot = objXML.createElement("articles")

                '//adding the primary key tracking attribute
                set objpk = objXML.createAttribute("pk")
                objpk.Text = "0"
                objRoot.setAttributeNode objpk

                objXML.appendChild(objRoot)
                
            end if

            set objParent = objXML.documentElement

            '//adding the article node
            set objnewArticle = objXML.createElement("article")
                
            '//setting id
            set objid = objXML.createAttribute("id")
            objid.Text = (Int(objParent.getAttribute("pk"))+1)&""
            objnewArticle.setAttributeNode objid
            objParent.setAttribute("pk") = objid.Text

            '//setting article title
            set objarticletitle = objXML.createElement("articletitle")
            set objarticletitletext = objXML.createCDATASection(articletitle)
            objarticletitle.appendChild(objarticletitletext)
            objnewArticle.appendChild(objarticletitle)

            '//setting article author
            set objarticleauthor = objXML.createElement("articleauthor")
            set objarticleauthortext = objXML.createCDATASection(articleauthor)
            objarticleauthor.appendChild(objarticleauthortext)
            objnewArticle.appendChild(objarticleauthor)

            '//setting article body
            set objarticlebody = objXML.createElement("articlebody")
            set objarticlebodytext = objXML.createCDATASection(articlebody)
            objarticlebody.appendChild(objarticlebodytext)
            objnewArticle.appendChild(objarticlebody)

            '//setting article image
            set objarticleimage = objXML.createElement("articleimage")
            set objarticleimagetext = objXML.createCDATASection(articleimage)
            objarticleimage.appendChild(objarticleimagetext)
            objnewArticle.appendChild(objarticleimage)

            '//setting createdonutc
            set objcreatedonutc = objXML.createElement("createdonutc")
            set objcreatedonutctext = objXML.createCDATASection(currentUTCDateTime.GetVarDate (false))
            objcreatedonutc.appendChild(objcreatedonutctext)
            objnewArticle.appendChild(objcreatedonutc)

            '//setting modifiedonutc
            set objmodifiedonutc = objXML.createElement("modifiedonutc")
            set objmodifiedonutctext = objXML.createCDATASection("")
            objmodifiedonutc.appendChild(objmodifiedonutctext)
            objnewArticle.appendChild(objmodifiedonutc)

            '//setting status
            set objstatus = objXML.createElement("status")
            set objstatustext = objXML.createCDATASection("E")
            objstatus.appendChild(objstatustext)
            objnewArticle.appendChild(objstatus)
    
            objParent.appendChild(objnewArticle)


            objXML.save dbxmlpath
            set objXML=nothing

            articleAdded = true

        end if


        if articleAdded = true then
            Response.Write("<script type='text/javascript'>parent.newArticleAdded();</script>")
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
                <img id="imagArticlePreview" src="" class="img-fluid" style="max-width:200px;margin-top:5px" />
                <input type="hidden" id="hdnarticleimage" name="hdnarticleimage" value="" />
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
                <input type="submit" id="btnAdd" name="btnAdd" value="Add" class="btn btn-danger" />
            </div>

        </div>


        <div class="row">

            <div class="col-sm-12">
                &nbsp;
            </div>

        </div>

    </div>

</form>