/****************************
//[[Description:°´Å¥Æ¤·ô¿â]]
//[[Author: gainover]]
****************************/
$Q("Skin");

$D("skin.button");

Skin.Button={
	"set":function(name,skin,level,hideFocus){
		var sdir=Win.path(level)+"skin\\"+skin;
		if(Dir.exists(sdir)){
			if(document.styleSheets.length<=0){
				var x=Dom.Html.add($R(8),"style");
				x.type="text/css";
			}
			var fh=File.open(sdir+"\\config.js");
			var ct=File.read(fh);
			if(ct){
				ct=str2obj(ct);
			}
			var classTag=$R(8);
			var bgurl=ct["url"];
			for(var i in ct){
				if(i!="url"){
					ct[i]=ct[i].replace(/\{path\}/g,(sdir+"\\"+bgurl));
					document.styleSheets[0].addRule("."+classTag+"_"+i,ct[i]);
				}
			}
			var bts=document.getElementsByName(name);
			for(var i=0;i<bts.length;i++){
				(function(i){
					Dom.Html.attr(bts[i],"hideFocus",true);
					Dom.Html.attr(bts[i],"class",classTag+"_normal");
					Dom.Event.add(bts[i],"mouseover",function(){
						Dom.Html.attr(bts[i],"class",classTag+"_over");
					});
					Dom.Event.add(bts[i],"mouseout",function(){
						Dom.Html.attr(bts[i],"class",classTag+"_normal");
					});
					Dom.Event.add(bts[i],"mousedown",function(){
						Dom.Html.attr(bts[i],"class",classTag+"_click");
					});
					Dom.Event.add(bts[i],"mouseup",function(){
						Dom.Html.attr(bts[i],"class",classTag+"_normal");
					});
				})(i);
			}
		}
	}
};
