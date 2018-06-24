/****************************
//[[Description:Socket 操作]]
//[[Author: gainover]]
****************************/
//requires
$D("coder.gbk",true);
$D("coder.url",true);

/*Define socket Library*/
$D("socket");
/**
 * Socket 操作
 * @namespace Socket操作
 */
var Socket={
	/*
	p1: onConnect,
	p2: onRead,
	p3: onError,
	p4: onClose,
	p5: onConnecting,
	p6: onWrite
	*/
	_httpconfig:null,
	open:function(host,ip,p1,p2,p3,p4,p5,p6){
		var funcs=[p1,p2,p3,p4,p5,p6];
		var funcstr=["","","","","",""];
		var funchead=["connect","read","error","close","coning","write"];
		for(var i=0;i<funcs.length;i++){
			if($Y(funcs[i])=="function"){
				funcstr[i]=funchead[i]+"_"+$R(8);
				window[funcstr[i]]=funcs[i];
			}else if($Y(funcs[i])=="string"){
				funcstr[i]=funcs[i]
			}
		}
		return external.socketOpen(host,ip+"",funcstr[0],funcstr[1],funcstr[2],funcstr[3],funcstr[4],funcstr[5]);
	},
	send:function(sid,data){
		if(data){
			data="0x"+data.replace(/\s+/g," 0x");
			external.socketSend(sid,data);
		}
	},
	close:function(sid){
		external.socketClose(sid);
	},
	listen:function(port,p1,p2,p3,p4,p5,p6){
		/*
			p1:onListen
			p2:onAccept,
			p3:onRead,
			p4:onError
			p5:onDisconnect,
			p6:onWrite
		*/
		var funcs=[p1,p2,p3,p4,p5,p6];
		var funcstr=["","","","","",""];
		var funchead=["slisten","saccept","sread","serror","sdiscon","swrite"];
		for(var i=0;i<funcs.length;i++){
			(function(i){
				if($Y(funcs[i])=="function"){
					funcstr[i]=funchead[i]+"_"+$R(8);
					window[funcstr[i]]=function(p1,p2){
						if(funchead[i]=="slisten"){
							p1=str2obj(p1);
						}else if(funchead[i]=="saccept"){
							p2=str2obj(p2);
						}
						funcs[i](p1,p2);
					}
				}else if($Y(funcs[i])=="string"){
					funcstr[i]=funcs[i];
				}
			})(i);
		}
		return external.serverOpen("",port+"",funcstr[0],funcstr[1],"",funcstr[2],funcstr[3],funcstr[4],funcstr[5]);
	},
	reply:function (id,data,closed){
		//Socket Encode bug 忘记编码发送数据了
		if(id&&data||id==0){
			external.serverReply(id,data,!!closed);
		}
	},
	getIp:function  (domain){
		if(domain){
			var ip=external.getIpByName(domain);
			return ip;
		}
		return "";
	},
	closeClient:function(id){
		if(id||id==0){
			external.serverCloseClient(id);
		}
	},
	stopListen:function(id){
		if(id||id==0){
			external.serverClose(id);
		}
	},
	httpSetting:function(config){
		this._httpconfig=config||null;
	},
	httpParse:function(head){
		var obj={};
		var arr=head.split(/[\r\n]+/);
		var req=arr.shift();
		var reqData=req.split(/\s+/);
		for(var i=0,l=arr.length;i<l;i++){
			var tmp=arr[i].getMatch(/([^:]+):\s([\s\S]+)/,true);
			if(tmp[1]){
				obj[tmp[1]]=tmp[2];
			}
		}
		var rpath=reqData[1];
		var qs={};/*querystring*/
		if(rpath.indexOf("?")!=-1){
			path=rpath.getMatch(/([^?]+)?([\S\s]+)/,true);
			var qstr=path[2].replace(/^\?/,"");
			try{
				qs=Coder.Url.decode(qstr);
			}catch(e){}
		}else{
			path=["",rpath,""];
		}
		var host=obj.Host;
		var port=host[1]||80;
		host=host.split(":");
		if(reqData[0]=="CONNECT"){
			var tmp=obj["__path"].split(":");
			port=tmp[1]||80;
		}
		obj["__host"]=host[0];
		obj["__port"]=port;
		obj["__method"]=reqData[0];
		obj["__path"]=path[1];
		obj["__querystring"]=qs;
		obj["__rawpath"]=rpath;
		obj["__version"]=reqData[2];
		return obj;
	},
	httpResponse:function(id,param,charset,closed){
		var data={
			head:{
				"Content-Type":" text/html;charset=gb2312"
			},
			body:""
		};
		if(this._httpconfig){
			data.head=_httpconfig;
		}
		if($Y(param)=="string"){
			data.body=param;
		}else{
			param=param||data;
			if(this._httpconfig){
				for(var i in param.head){
					data.head[i]=param.head[i];
				}
			}else{
				data.head=param.head;
			}
			data.body=param.body;
		}
		var bodyData=new this.data();
			bodyData.writeString(data.body,charset);
		var len=bodyData.array().length;
		var respHead="HTTP/1.1 200 OK\nDate: "+new Date().toUTCString()+"\n";
		for(var i in data.head){
			respHead+=i+": "+data.head[i]+"\n";
		}
		respHead+="ToolmaoBox: "+$VERSION$+"\n";
		respHead+="Content-Length: "+len+"\n\n"+data.body;
		this.reply(id,Socket.encode(respHead,charset),closed);
	},
	httpRequest:function  (){

	},
	encode:function(str,charset){
		if(charset&&charset.lc()=="utf8"){
			return this.encodeUTF8(str);
		}else{
			var str=str.split("");
			var rs=[];
			for(var i=0;i<str.length;i++){
				if(str[i].charCodeAt(0)>127){
					rs.push($T(Coder.gbk.encode(str[i]).uc().replace(/%/g," ")));
				}else{
					var tmp=str[i].charCodeAt(0).toString(16);
					if(tmp.length==1){
						//for 0-F
						tmp="0"+tmp;
					}
					rs.push(tmp.toUpperCase());
				}
			}
			return rs.join(" ");
		}
	},
	encodeUTF8:function(str){
		var str=str.split("");
		var rs=[];
		for(var i=0;i<str.length;i++){
			if(str[i].charCodeAt(0)>255){
				var tmp=encodeURIComponent(str[i]);
				tmp=tmp.split("%");
				tmp.shift();
				for(var j=0;j<tmp.length;j++){
					rs.push(tmp[j].toString(16).toUpperCase());
				}
			}else{
				rs.push(str[i].charCodeAt(0).toString(16).toUpperCase());
			}
		}
		return rs.join(" ");
	},
	decode:function(str,header,end,charset){
		if(charset&&charset.lc()=="utf8"){
			return this.decodeUTF8(str,header,end);
		}else{
			header=header||0;
			end=end||0;
			str=(""+str).substring(header*3,str.length-end*3);
			str=$T(str);
			return Coder.gbk.decode(str);
		}
	},
	decodeUTF8:function(str,header,end){
		header=header||0;
		end=end||0;
		var chars="%"+str.replace(/^\s+|\s+$/g,"").replace(/\s+/g,"%");
		chars=chars.substring(header*3,chars.length-end*3);
		return decodeURIComponent(chars);
	},
	data:function(){
		var _data=[];
		var _pointer=0;
		var that=this;
		/*write operation*/
		this.write=function(d){
			_data.push(d);
		};
		this.writeByte=function(b){
			_data.push(b.toString(16).fill(2,"0"));
			return this;
		};
		this.writeInt=function(i){
			_data.push(i.toString(16).fill(4,"0").format(2," "));
			return  this;
		};
		this.writeShort=this.writeInt;
		this.writeUnsignedInt=function(u){
			_data.push(u.toString(16).fill(8,"0").format(2," "));
			return this;
		};
		this.writeUInt=this.writeUnsignedInt;
		this.writeString=function(s,charset){
			if(s){
				_data.push(Socket.encode(s,charset));
			}
			return this;
		};
		this.writeUTFBytes=this.writeString;
		this.array=function(){
			return _data.join(" ").split(" ");
		};
		/*read operation*/
		var readN=function(s,l){
			var tmp=that.array();
			var str=[];
			for(var i=s;i<s+l;i++){
				str.push(tmp[i]);
			}
			return str;
		};
		this.read=function(){
			return _data.join(" ");
		};
		this.readInt=function(){
			_pointer+=2;
			if(!this.atEnd()){
				var tmp=readN(_pointer-2,2);
					tmp="0x"+tmp.join("");
				return parseInt(tmp,16);
			}else{
				return null;
			}
		};
		this.readShort=this.readInt;
		this.readUInt=function(){
			_pointer+=4;
			if(!this.atEnd()){
				var tmp=readN(_pointer-4,4);
					tmp="0x"+tmp.join("");
				return parseInt(tmp,16);
			}else{
				return null;
			}
		};
		this.readUnsignedInt=this.readUInt;
		this.readString=function(l,charset){
			_pointer+=l;
			if(!this.atEnd()){
				var tmp=readN(_pointer-l,l);
					tmp=tmp.join(" ");
				return Socket.decode(tmp,0,0,charset);
			}else{
				return null;
			}
		};
		this.readUTFBytes=this.readString;
		/*pointer operation*/
		this.atEnd=function(){
			if(_pointer>this.array().length){
				return true;
			}
			return false;
		};
		this.atBegin=function(){
			if(_pointer==0){
				return true;
			}
			return false;
		};
		this.setEnd=function(){
			_pointer=this.array().length-1;
		};
		this.setBegin=function(){
			_pointer=0;
		};
		this.setPos=function(pos){
			if(pos>=this.array().length){
				pos=this.array().length-1;
			}
			if(pos<0){
				pos=0;
			}
			_pointer=pos;
		};
		this.getPos=function(){
			return _pointer;
		};
	}
};
