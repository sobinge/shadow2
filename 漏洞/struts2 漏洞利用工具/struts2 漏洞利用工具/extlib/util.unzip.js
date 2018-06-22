/****************************
//[[Description:Zip½âÑ¹º¯Êý¿â]]
//[[Author: gainover]]
****************************/
$Q("Util");

$D("util.unzip");

Util.unzip=function(zipfile,callback){
	var callbackName="";
	if(callback){
		callbackName="unzip_"+$R(16);
		window[callbackName]=function(path){
			callback(path);
			window[callbackName]=null;
		};
	}
	if(zipfile){
		external.unzip(zipfile,callbackName);
	}
}
