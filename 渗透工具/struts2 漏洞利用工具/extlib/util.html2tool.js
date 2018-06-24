/****************************
//[[Description:HTML转应用]]
//[[Author: gainover]]
****************************/
$Q("Util");

$D("util.html2tool");

Util.html2tool=__util_useHTML;

function __util_useHTML(url){
	url=url.replace(/\.(htm|html)$/,"");
	var path=Win.path()+url+".htm";
	if(!File.exists(path)){
		alert("你所调用的网页"+url+".htm不存在，请确认路径是否正确");
		return;
	}
	var fh=File.open(path);
	var ct=File.read(fh);
	File.close(fh);
	var title=ct.getMatch(/<title>([\s\S]*?)<\/title>/i);
	if(title&&external.caption=="工具猫魔盒"){
		Win.caption(title);
	}
	if(ct.indexOf("<!--_TOOLMAO_BOX_-->")==-1){
		//如果HTML没有被转换，则进行转换
		var scr='<style type="text/css">body{border:none;}</style><!--_TOOLMAO_BOX_-->';
		switch(true){
			case ct.toLowerCase().indexOf("<head>")>-1:
				ct=ct.replace(/<head>/i,"<head>"+scr);
				break;
			case ct.toLowerCase().indexOf("<html")>-1:
				ct=ct.replace(/<html([^>]+?)>/i,"<html$1><head>"+scr+"</head>");
				break;
			case ct.toLowerCase().indexOf("<body")>-1:
				ct=ct.replace(/<body>/i,"<head>"+scr+"</head><body");
				break;
		}
		//写入内容到文件
		var fh=File.open(path);
			File.write(fh,ct,true);
			File.close(fh);
	}
	//将页面跳转至HTML页面
	location.href=path;
}