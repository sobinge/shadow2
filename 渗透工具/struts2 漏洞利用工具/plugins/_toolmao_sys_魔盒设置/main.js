var currBg="";
var IMGLIST={};
var IDLIST={};
function loadDesktopConfig(){
	var dc=external.path+"lib\\sysconfig\\desktop.config";
	var fh=File.open(dc);
	var data=File.read(fh);
	if(fh){
		var tmp={};
		try{
			tmp=str2obj(data);
			$("sysbg").innerHTML=(tmp["backgroundImage"]||"./img/systembg.jpg");
			currBg=(tmp["backgroundImage"]||"./img/systembg.jpg");
			addToList(currBg);
		}catch(e){}
	}
	File.close(fh);
}
function addToList(url){
	if(IMGLIST[url]){
		if($(IMGLIST[url])){
			Dom.Html.del(IMGLIST[url]);
			if(IDLIST[IMGLIST[url]]){
				delete IDLIST[IMGLIST[url]];
			}
			delete IMGLIST[url];
		}
	}
	if(url.substring(0,1)=="."||url.substring(0,1)=="/"||url.substring(0,1)=="\\"){
		url=external.path+"lib\\"+url;
	}
	var id=$R(8);
	var im=Dom.Html.add(id,"div","imglist","","afterBegin");
	Dom.Html.attr(im,"class","imgitem");
	Dom.Html.value(im,"<img src='"+url+"' class='imgitemex' onerror='this.src=\"../../img/systembg.jpg\"'></img>");
	Dom.Event.add(im,"mouseover",function(){
		var sid=Dom.Html.attr(document.body,"selectedBg");
		if(sid!=id){
			$$(im).style.background="#33ffcc";
		}
	});
	Dom.Event.add(im,"mouseout",function(){
		var sid=Dom.Html.attr(document.body,"selectedBg");
		if(sid!=id){
			$$(im).style.background="#000";
		}
	});
	Dom.Event.add(im,"click",function(){
		var sid=Dom.Html.attr(document.body,"selectedBg");
		if(sid){
			$$(sid).style.background="#000";
			Dom.Html.attr(document.body,"selectedBg","");
		}
		parent.loadDesktopConfig(url);
		$$(im).style.background="#ff9933";
		Dom.Html.attr(document.body,"selectedBg",id);
	});
	IDLIST[id]=url;
	IMGLIST[url]=id;
	var sid=Dom.Html.attr(document.body,"selectedBg");
	if(sid){
		$$(sid).style.background="#000";
		Dom.Html.attr(document.body,"selectedBg","");
	}
	Dom.Html.attr(document.body,"selectedBg",id);
	$$(id).style.background="#ff9933";
}
function selectNewBg(){
	var x=Win.Dialog.open("请选择一个新的背景图片","图片文件(jpg,gif,png,bmp)|*.jpg;*.gif;*.png;*.bmp");
	if(x){
		parent.loadDesktopConfig(x);
		$("sysbg").innerHTML=x;
		addToList(x);
	}
}
function replaceSlash(url){
	return url.replace(/\\/g,"\\\\");
}
function saveNewBg(){
	var sid=Dom.Html.attr(document.body,"selectedBg");
	if(sid){
		if(IDLIST[sid]){
			var dc=external.path+"lib\\sysconfig\\desktop.config";
			var fh=File.open(dc);
			File.write(fh,obj2str({
				"backgroundImage":replaceSlash(IDLIST[sid]),
				"backgroundRepeat":"repeat"
			}),true);
			File.close(fh);
			alert("保存设置成功");
		}else{
			alert("读取图片地址错误");
		}
	}else{
		alert("请先选择一个图片作为背景");
	}
}
Dom.Event.add(window,"load",function(){
	$("appData").style.height=($P(parent.document.getElementById("desktop").style.height)-150)+"px";
	loadDesktopConfig();
});