/****************************
//[[Description:Ä£Äâ°´¼ü¿â]]
//[[Author: gainover]]
****************************/
$Q("Util");

$D("util.sendkey");

Util.sendKey=new _SENDKEY();
Util.SendKey=Util.sendKey;
Util.sendkey=Util.sendKey;

function _SENDKEY(){
	var obj=Win.obj(Win.com.WSH);
	this.activate=function(title){
		return obj.AppActivate(title);
	}
	this.sendkey=function(key,times){
		var t=times?(" "+times):"";
		switch(key.toUpperCase()){
			case "{":
			case "}":
			case "+":
			case "^":
			case "%":
			case "~":
			case "(":
			case ")":
			case "[":
			case "]":
				key="{"+key+t+"}";
				break;
			case "SHIFT":
				key="+";
				break;
			case "CTRL":
				key="^";
				break;
			case "ALT":
				key="%";
				break;
			case "»Ø³µ":
				key="{ENTER"+t+"}";
				break;
			case "Õ³Ìù":
				key="^v";
				break;
			default:
				if(t){
					key=key.replace(/(\{|\})/g,"");
					key="{"+key+t+"}";
				}
		}
		obj.SendKeys(key);
	}
	this.copy=function(text){
		Win.Clipboard.copy(text);
	}
	this.paste=function(){
		this.sendkey("Õ³Ìù");
	}
}