/****************************
//[[Description:Url«Î«Û±‡¬Î]]
//[[Author: Gainover]]
****************************/
//–Ë«∞÷√Coder
$Q("Coder");

$D("coder.url");

Coder.url=Coder.Url={
	encode:function(obj,notencode){
		var str=[];
		for(var i in obj){
			if(notencode===false){
				str.push(i+"="+obj[i]);
			}else{
				str.push(i+"="+encodeURIComponent(obj[i]));
			}
		}
		return str.join("&");
	},
	decode:function(str,notencode){
		var arr=[];
		var obj={};
		arr=str.split("&");
		for(var i=0,l=arr.length;i<l;i++){
			var tmp=arr[i].split("=");
			if(notencode===false){
				obj[tmp[0]]=tmp[1];
			}else{
				obj[tmp[0]]=decodeURIComponent(tmp[1]);
			}
		}
		return obj;
	}
};
