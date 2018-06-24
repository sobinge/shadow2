/****************************
//[[Description:百度APP调用]]
//[[Author: gainover]]
****************************/
$Q("Util");

$D("util.baloader"); //ba= baidu app

Util.baloader=Util.BALoader={
	"load":function(appurl,appname,appauthor,appwidth,appheight,appleft,apptop){
		external.silent=true;
		Dom.Html.css(document.body,"border:none;overflow:hidden;margin:0px;font-size:12px;color:#ccc;margin-top:9px");
		appwidth=parseInt(appwidth||570);
		appheight=parseInt(appheight||381);
		appleft=appleft===0?0:parseInt(appleft||-120);
		apptop=apptop===0?0:parseInt(apptop||-200);
		Win.show();
		Win.resizeTo(appwidth+20,appheight);
		Win.caption(appname+ " by "+appauthor);
		if(appurl){

			var str='<div id="loading" style="margin:auto;width:'+appwidth+'px;height:200px;text-align:center;line-height:200px;">程序加载中...</div>';
				str+='<div style="margin:auto;width:'+appwidth+'px;height:'+appheight+'px;overflow:hidden">';
				str+='<iframe id="appframe" src="'+appurl+'" onload="" frameborder="no" scrolling="no" style="display:none;width:1000px;height:1200px;position:relative;left:'+appleft+'px;top:'+apptop+'px;"></iframe>';
				str+='</div>';
				document.body.innerHTML=str;
			setTimeout(function(){
				Dom.Html.hid('loading');Dom.Html.show('appframe');
			},1500);
		}else{
			alert("插件应用加载出错");
		}
	}
};
