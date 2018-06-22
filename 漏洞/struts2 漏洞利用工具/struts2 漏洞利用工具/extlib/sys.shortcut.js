/****************************
//[[Description:快捷方式操作]]
//[[Author: gainover]]
****************************/
$Q("Sys");

Sys.ShortCut={
	link:function(savepath,srcpath,arg,iconpath,desc,workdir,hotkey){
		var wsh=Win.obj(Win.com.WSH);
		var link=wsh.CreateShortcut(savepath);
		link.TargetPath=srcpath;
		link.WindowStyle=1;
		link.Hotkey=hotkey||"";
		link.Description=desc||"快捷方式";
		arg&&(link.Arguments=arg);
		workdir&&(link.WorkingDirectory=workdir);
		iconpath&&(link.IconLocation=iconpath);
		link.Save();
		link=null;
		wsh=null;
	},
	url:function(savepath,url){
		if(url){
			var wsh=Win.obj(Win.com.WSH);
			var link=wsh.CreateShortcut(savepath);
			link.TargetPath=url;
			link.Save();
			link=null;
			wsh=null;
		}
	},
	get:function(savepath,attr){
		if(!attr){attr="path";}
		var data={"path":"TargetPath","icon":"IconLocation","wd":"WorkingDirectory","workingdir":"WorkingDirectory","workdir":"WorkingDirectory",
		"Workingdirectory":"WorkingDirectory","desc":"Description","description":"Description","hotkey":"Hotkey","ws":"WindowStyle","windowstyle":"WindowStyle"}[attr]||"TargetPath";
		var wsh=Win.obj(Win.com.WSH);
		var link=wsh.CreateShortcut(savepath);
		var obj="";
		try{
			obj=link[data];
		}catch(e){}
		link=null;
		wsh=null;
		return obj;
	}
};

/*
//使用实例
//给应用程序创建一个快捷方式
Sys.ShortCut.link(Win.path()+"test.lnk",Win.exe());
//给网址创建一个快捷方式
Sys.ShortCut.url(Win.path()+"test.url","http://www.baidu.com");
//获得一个快捷方式的源目标
alert(Sys.ShortCut.get(Win.path()+"test.lnk","icon"));
*/
