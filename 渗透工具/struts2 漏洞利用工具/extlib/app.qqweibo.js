/****************************
//[[Description:QQ微博开放接口]]
//[[Author: gainover]]
****************************/
/*
2011-7-12
appname:		应用程序名称
appkey:			应用key (由微博官方提供)
appsecret:		应用secret (由微博官方提供)
mainFunc:		登录完毕后，所指向的回调函数
url:			自动授权后，所跳转的地址 (不推荐使用)
auth_div_id:	显示授权输入框的div (默认为空,不推荐自己填写)
*/
$Q("App");
//require
$D("coder.base64",true);
$D("coder.sha1",true);

$D("app.qqweibo");

App.qqWeibo=App.qqweibo=App.QQweibo=_QQweibo;

_QQweibo.REQ_COUNT=0;

function _QQweibo(appname,appkey,appsecret,mainFunc,url,auth_div_id){
	var that=this;
	this.hostname="qqweibo";
	this.appname=appname||"新的微博应用";
	this.appkey=appkey||"";
	this.appsecret=appsecret||"";
	this.token="";
	this.tokensecret="";
	this.verifier="";
	/*----------------------------------------------------*/
	this.debug=false;			//是否启用调试模式
	this.url=url||location.href;
	this.callback="http://open.t.qq.com/images/resource/p9.gif"; //callback地址
	this.callback_ok=false;		//记录callback状态
	this.name="";
	this.safe=true;				//是否启用登录安全模式,若为true，则需要手工输入授权码
	this.loadingShowed=false;
	this.userflag="";			//用于多用户应用,做为用户的标识符
	this.main=function(){
		if(mainFunc&&$Y(mainFunc)=="function"){
			mainFunc.apply(this);
		}
	};
	this.auth_param={
		"id":auth_div_id||"toolmao_auth_div"
	};
	this.logo={
		"big":"",
		"bgcolor":"#128ABC",
		"small":"",
		"ok":"",
		"okover":"",
		"verifier":"",
		"help":"",
		"code":"",
		"codeover":""
	};
	this.login_Status=function(){
		//安全模式
		var __record=that.read_Token();
		if(__record){
			//说明已经存储过
			that.token=__record["token"];
			that.tokensecret=__record["tokensecret"];
			that.name=__record["name"];
			//alert("登录完毕");
			if(that.main){
				that.main();
			}
			return true;
		}else{
			return false;
		}
	};
	this.write_Token=function(obj){
		var dir=Win.path()+"token";
		if(!Dir.exists(dir)){
			Dir.add(dir);
			Dir.add(dir+"\\"+this.hostname);
		}else{
			if(!Dir.exists(dir+"\\"+this.hostname)){
				Dir.add(dir+"\\"+this.hostname);
			}
		}
		var f=File.open(Win.path()+"token\\"+this.hostname+"\\tokens"+(this.userflag||""));
		File.write(f,obj2str(obj),true);
		File.close(f);
	}
	this.read_Token=function(){
		var url=Win.path()+"token\\"+this.hostname+"\\tokens"+(this.userflag||"");
		if(File.exists(url)){
			var f=File.open(url);
			var cont=File.read(f);
			try{
				var obj=str2obj(cont);
				return obj;
			}catch(e){
				return false;
			}
		}else{
			return false;
		}
	}
	this.encode=function(str){
		/*This script fragment from
			作者: VILIC VANE
			邮箱: i@vilic.info
			网站: www.vilic.info
		*/
		return encodeURIComponent(str).replace(/[!\*\(\)']/gi, function (c) {
			var code = c.charCodeAt(0).toString(16).toUpperCase();
			if (code.length == 1) code = "0" + code;
			return "%" + code;
		});
	}
	this.get_Request_Basestring=function(method,url,data){
		var arr=[];
		for(var i in data){
			arr.push(i+"="+data[i]);
		}
		//alert(method.uc()+"&"+encodeURIComponent(url)+"&"+encodeURIComponent(arr.sort().join("&")));
		return method.uc()+"&"+this.encode(url)+"&"+this.encode(arr.sort().join("&"));
	};
	this.get_Request_Basestring2=function(method,url,data){
		var arr=[];
		for(var i in data){
			arr.push(i+"="+this.encode(data[i]));
		}
		//alert(method.uc()+"&"+encodeURIComponent(url)+"&"+encodeURIComponent(arr.sort().join("&")));
		return method.uc()+"&"+this.encode(url)+"&"+this.encode(arr.sort().join("&"));
	};
	this.get_Signature=function(basestring,token){
		var key=encodeURIComponent(that.appsecret)+"&"+(token?encodeURIComponent(token):"");
		return Coder.base64.encode(Coder.sha1.encode(basestring,"str_hmac",key));
	};
	this.get_Query_String=function(data){
		var datastr=[];
		for(var i in data){
			datastr.push(encodeURIComponent(i)+"="+encodeURIComponent(data[i]));
		}
		datastr=datastr.join("&");
		return datastr;
	};
	this.get_Auth_String=function(data){
		var datastr=[];
		for(var i in data){
			datastr.push(encodeURIComponent(i)+"=\""+encodeURIComponent(data[i])+"\"");
		}
		datastr=datastr.join(",");
		return datastr;
	}
	this.parse_Result=function(str){
		var obj={};
		str=str.split("&");
		for(var i=0;i<str.length;i++){
			var tmp=str[i].split("=");
			obj[$T(tmp[0])]=$T(tmp[1]);
		}
		return obj;
	};
	this.build_Data=function(token,verifier,nocallback,add,pic){
		var timestamp=Dom.Random.time("short");
		var rc=_QQweibo.REQ_COUNT++;
		var data={
			"oauth_consumer_key":that.appkey,
			"oauth_signature_method":"HMAC-SHA1",
			"oauth_callback":that.safe?"null":that.callback,
			"oauth_version":"1.0",
			"oauth_nonce":$R(32,"sn"),
			"oauth_timestamp":timestamp
		};
		if(token){
			data["oauth_token"]=token;
		}
		if(verifier){
			data["oauth_verifier"]=verifier;
		}
		if(nocallback){
			delete data["oauth_callback"];
		}
		if(add){
			for(var i in add){
				data[i]=add[i];
			}
		}
		if(data["content"]&&!pic){
			data["content"]=encodeURIComponent(data["content"]);
		}
		return data;
	};
	this.send_Request=function(method,url,data,callback,token,type,pic){
		data=data||{};
		method=(method||"GET").uc();
		var oauth_signature=this.get_Request_Basestring(method,url,data);
		if(pic){
			oauth_signature=this.get_Request_Basestring2(method,url,data);
		}
		data["oauth_signature"]=this.get_Signature(oauth_signature,(token?that.tokensecret:""));//.replace(/\+/g,"%2B").replace(/\//g,"%2F");
			//$("xxx").innerHTML+=(data["oauth_signature"])+"<br/>";
		if(method=="GET"){
			var datastr=this.get_Query_String(data);
			Net.get(url+"?"+datastr,function(rs){
				if(callback){callback(rs);}
			},type,"","","",function(code,r){
				//request failed then show error description
				if(that.debug){
					alert(method+":"+url+":"+r.responseText);
				}else{
					_QQweibo_showError(r.responseText);
				}
			});
		}else if(method=="POST"){
			if(!pic){
				data["oauth_signature"]=this.encode(data["oauth_signature"]);
				Net.post(url,data,function(rs){
					if(callback){callback(rs);}
				},type,"","","",function(code,r){
					//request failed then show error description
					if(that.debug){
						alert(method+":"+url+":"+r.responseText);
					}else{
						_QQweibo_showError(r.responseText);
					}
				});
			}else{
				//var datastr=this.get_Auth_String(data);
				var filedata={};
				//var ext=(File.ext(pic)||"").lc();
				//if(ext=="jpg"){ext="jpeg";}
				filedata["file"]={
					"pic":{
						"path":pic
					}
				};
				filedata["data"]=data;
				filedata["boundary"]=true;
				Net.upload(url,filedata,function(rs){
					if(callback){callback(rs);}
				},type,"","",{
					//"WWW-Authenticate":"OAuth realm=\"www.toolmao.com\","+datastr
				},function(code,r){
					//request failed then show error description
					if(that.debug){
						alert(method+":"+url+":"+r.responseText);
					}else{
						_QQweibo_showError(r.responseText);
					}
				});
			}
		}
	};
	/*认证界面显示*/
	this.showLoading=function(){
		if(!Dom.Cookie.read("toolmao_name")){
			this.loadingShowed=true;
			var d=null;
			if($(this.auth_param["id"])){
				//如果用户定义的id已经存在，则显示在该id中
				d=$(this.auth_param["id"]);
			}else{
				d=Dom.Html.add(this.auth_param["id"],"div");
				if(document.body){
					document.body.style.margin="0px";
				}
				d.style.top="0px";
				d.style.left="0px";
			}
			d.style.position="absolute";
			d.style.width="100%";
			d.style.height="100%";
			d.style.background="#f1f1f1";
			d.style.textAlign="center";
			d.style.fontSize="12px";
			d.innerHTML="<div style='background:"+that.logo.bgcolor+";text-align:center;height:92px;line-height:92px;font-size:36px;'>"+(that.logo.big?("<img src='"+that.logo.big+"' width='252' height='92' />"):that.appname)+"</div><br/><br/><div style='text-align:center;'><img src='"+that.logo.small+"'  onerror='this.style.display=\"none\"'/><br/><br/>正在加载腾讯微博请求码...<br/><br/></div><div style='background:url(#);position:absolute;top:0px;left:0px;width:100%;height:100px;z-index:520;cursor:pointer' id='dragarea'></div>";
			//设置窗口拖动区域
			Win.Drag.set("dragarea");
		}
	}
	this.showAuthorize=function(){
		var initText="双击获取授权码";
		var initTextColor="#ccc";
		var url="https://open.t.qq.com/cgi-bin/authorize?oauth_token="+that.token;
		var htmlc="<div style='background:"+that.logo.bgcolor+";text-align:center;height:92px;line-height:92px;font-size:36px;'>"+(that.logo.big?("<img src='"+that.logo.big+"' width='252' height='92' />"):that.appname)+"</div><br/><div style='text-align:center;'><img src='"+that.logo.small+"' onerror='this.style.display=\"none\"'/><br/><br/>请输入腾讯微博授权码<br/><br/><input type='text' id='toolmao_code_text' style='border:"+(that.logo.code?"none":"1px solid #000")+";background:url("+that.logo.code+") no-repeat;width:105px;height:23px;padding-left:6px;padding-top:4px;color:"+initTextColor+"' value='"+initText+"'/><br/><br/> <input type='button' id='toolmao_ok_button' style='background:url("+that.logo.ok+") no-repeat;width:78px;height:24px;border:"+(that.logo.ok?"none":"1px solid #ccc")+";' value='"+(that.logo.ok?"":"登录")+"'/><br/></div><div style='position:absolute;bottom:0px;left:0px;text-align:center;'><ul style='text-align:left;width:100%;margin:0px;margin-left:10px;margin-bottom:30px;line-height:2.5;'><li><a href='"+url+"' target='_blank' style='text-decoration:none;height:16px;background:url("+that.logo.verifier+") left center no-repeat;padding-left:20px;'>点此获取微博授权码</a></li><li><a href='"+url+"' target='_blank' style='text-decoration:none;height:16px;background:url("+that.logo.help+") left center no-repeat;padding-left:20px;'>什么是微博授权码 ?</a></li></div><div style='background:url(#);position:absolute;top:0px;left:0px;width:100%;height:100px;z-index:520;cursor:pointer' id='dragarea'></div>";
		var d=null;
		if($(this.auth_param["id"])){
			//如果用户定义的id已经存在，则显示在该id中
			d=$(this.auth_param["id"]);
		}else{
			d=Dom.Html.add(this.auth_param["id"],"div");
			if(document.body){
				document.body.style.margin="0px";
			}
			d.style.top="0px";
			d.style.left="0px";
		}
		d.style.position="absolute";
		d.style.width="100%";
		d.style.height="100%";
		d.style.background="#f1f1f1";
		d.style.textAlign="center";
		d.style.fontSize="12px";
		d.innerHTML=htmlc;
		d.style.display="";
		//设置窗口拖动区域
		Win.Drag.set("dragarea");
		if($("toolmao_ok_button")){
			$("toolmao_ok_button").onclick=function(){
				if($('toolmao_code_text').value!=""&&$('toolmao_code_text').value!=initText){
					that.verifier=$T($('toolmao_code_text').value);
					that.get_Access_Token();
				}else{
					alert("请输入授权码");
				}
			};
			$("toolmao_ok_button").onmouseover=function(){
				this.style.background="url("+that.logo.okover+") no-repeat";
			};
			$("toolmao_ok_button").onmouseout=function(){
				this.style.background="url("+that.logo.ok+") no-repeat";
			};
		}
		if($("toolmao_code_text")){
			$("toolmao_code_text").onblur=function(){
				if(this.value==""){
					this.value=initText;
					this.style.color=initTextColor;
					this.style.background="url("+that.logo.code+") no-repeat";
				}
			};
			$("toolmao_code_text").onfocus=function(){
				if(this.value==initText){
					this.value="";
					this.style.color="#000";
					this.style.background="url("+that.logo.codeover+") no-repeat";
				}
			};
			$("toolmao_code_text").ondblclick=function(){
				window.open(url);
			};
		}
	}
	/*认证部分函数*/
	this.get_Request_Token=function(callback){
		this.send_Request("GET","https://open.t.qq.com/cgi-bin/request_token",that.build_Data(),function(rs){
			if(rs){
				var data=that.parse_Result(rs);
				//回调
				if(callback){callback(data);}
				//oauth_token
				//oauth_token_secret
				//oauth_callback_confirmed
				that.token=data["oauth_token"];
				that.tokensecret=data["oauth_token_secret"];
				that.showAuthorize();
				//Dom.Cookie.write("tokensecret",that.tokensecret);
				//that.callback_ok=(data["oauth_callback_confirmed"]=="true"?true:false);
				//获取参数之后，进行用户认证
				//if(!Dom.Cookie.read("toolmao_name")){

				/*}else{
					that.token=Dom.Cookie.read("oauth_token");
					that.tokensecret=Dom.Cookie.read("oauth_token_secret");
					that.name=Dom.Cookie.read("name");
					if(that.main){
						that.main();
					}
				}*/
			}else{
				_QQweibo_showError(1);
			}
		});
	}
	this.get_Access_Token=function(){
		$("toolmao_ok_button").value="登录中..";
		$("toolmao_code_text").value="0秒"
		var tmpt=Dom.Timer.start(function(){
			$("toolmao_code_text").value=($P($("toolmao_code_text").value)+1)+"秒";
		},1000);
		this.send_Request("GET","https://open.t.qq.com/cgi-bin/access_token",that.build_Data(that.token,that.verifier,true),function(rs){
			if(rs){
				Dom.Timer.stop(tmpt);
				var data=that.parse_Result(rs);
				that.token=data["oauth_token"];
				that.tokensecret=data["oauth_token_secret"];
				that.name=data["name"];
				that.write_Token({
					"token":that.token,
					"tokensecret":that.tokensecret,
					"name":that.name
				});
				if(that.safe){
					//隐藏登录界面
					$(that.auth_param["id"]).style.display="none";
					if(that.main){
						that.main();
					}
				}else{

				}
			}
		},true);
	}
	this.login=function(func){
		this.showLoading();
		this.start(func);
	}
	this.request=function(url,method,data,callback,format,pic){
		format=format||"json";
		that.send_Request(method,url,that.build_Data(that.token,that.verifier,true,data),function(rs){
			if(callback){
				callback(rs);
			}
		},true,format,pic);
	}
	this.get=function(url,data,callback,format,pic){
		this.request(url,"get",data,callback,format,pic);
	}
	this.post=function(url,data,callback,format,pic){
		this.request(url,"post",data,callback,format,pic);
	}
	/*QQ微博特有的函数*/
	this.Timeline={
		//我的主页
		_home:function(callback,format,pageflag,pagetime,reqnum){
			reqnum=reqnum||20; //获取的最大条数
			pageflag=pageflag||0; //
			pagetime=pagetime||0;
			format=format||"json";
			var url="http://open.t.qq.com/api/statuses/home_timeline";
			that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,{
				format:format,
				pageflag:pageflag,
				reqnum:reqnum,
				pagetime:pagetime
			}),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		//微博大厅
		_public:function(callback,format,pos,reqnum){
			format=format||"json";
			pos=pos||0;
			reqnum=reqnum||20;
			var url="http://open.t.qq.com/api/statuses/public_timeline";
			that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,{
				format:format,
				pos:pos,
				reqnum:reqnum
			}),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		//用户
		_user:function(callback,format,pageflag,pagetime,reqnum,name){
			reqnum=reqnum||20; //获取的最大条数
			pageflag=pageflag||0; //
			pagetime=pagetime||0;
			format=format||"json";
			var sobj={
				format:format,
				pageflag:pageflag,
				reqnum:reqnum,
				pagetime:pagetime
			};
			if(name){
				sobj.name=name;
			}
			var url="http://open.t.qq.com/api/statuses/user_timeline";
			that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		//提到我的
		_mention:function(callback,format,pageflag,pagetime,reqnum,lastid){
			reqnum=reqnum||20; //获取的最大条数
			pageflag=pageflag||0; //
			pagetime=pagetime||0;
			format=format||"json";
			var sobj={
				format:format,
				pageflag:pageflag,
				reqnum:reqnum,
				pagetime:pagetime
			};
			if(lastid){
				sobj.lastid=lastid;
			}
			var url="http://open.t.qq.com/api/statuses/mentions_timeline";
			that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		//话题
		_topic:function(callback,format,httext,pageflag,pageinfo,reqnum){
			reqnum=reqnum||20; //获取的最大条数
			pageflag=pageflag||0; //
			pageinfo=pageinfo||"";
			format=format||"json";
			var sobj={
				format:format,
				pageflag:pageflag,
				reqnum:reqnum,
				pagetime:pagetime
			};
			if(httext){
				sobj.httext=httext;
			}
			var url="http://open.t.qq.com/api/statuses/ht_timeline";
			that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		//我的广播
		_broadcast:function(callback,format,pageflag,pagetime,reqnum,name){
			reqnum=reqnum||20; //获取的最大条数
			pageflag=pageflag||0; //
			pagetime=pagetime||0;
			format=format||"json";
			var sobj={
				format:format,
				pageflag:pageflag,
				reqnum:reqnum,
				pagetime:pagetime
			};
			if(name){
				sobj.name=name;
			}
			var url="http://open.t.qq.com/api/statuses/broadcast_timeline";
			that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		_me:this._broadcast
	}
	this.Weibo={
		//获取一条微博的数据
		show:function(callback,format,id){
			id=id||"";
			format=format||"json";
			var sobj={
				format:format,
				id:id
			};
			if(id){
				var url="http://open.t.qq.com/api/t/show";
				that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format);
			}else{
				_QQweibo_showError(3);
			}
		},
		//发表一条微博
		add:function(callback,format,content,clientip,jing,wei){
			format=format||"json";
			clientip=clientip||"127.0.0.1";
			jing=jing||"";
			wei=wei||"";
			var sobj={
				format:format,
				clientip:clientip,
				jing:jing,
				wei:wei,
				content:content
			};
			if(content){
				var url="http://open.t.qq.com/api/t/add";
				that.send_Request("POST",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format);
			}else{
				_QQweibo_showError(4);
			}
		},
		//删除一条微博
		del:function(callback,format,id){
			format=format||"json";
			id=id||"";
			var sobj={
				format:format,
				id:id
			};
			if(id){
				var url="http://open.t.qq.com/api/t/del";
				that.send_Request("POST",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format);
			}else{
				_QQweibo_showError(5);
			}
		},
		//转发一条微博
		tui:function(callback,format,content,clientip,jing,wei,reid){
			format=format||"json";
			clientip=clientip||"127.0.0.1";
			jing=jing||"";
			wei=wei||"";
			if(!reid){
				_QQweibo_showError(6);
				return false;
			}
			var sobj={
				format:format,
				clientip:clientip,
				jing:jing,
				wei:wei,
				content:content,
				reid:reid
			};
			//转发可以内容为空
			var url="http://open.t.qq.com/api/t/re_add";
			that.send_Request("POST",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
				if(callback){
					callback(rs);
				}
			},true,format);
		},
		//回复一条微博
		reply:function(callback,format,content,clientip,jing,wei,reid){
			format=format||"json";
			clientip=clientip||"127.0.0.1";
			jing=jing||"";
			wei=wei||"";
			if(!reid){
				_QQweibo_showError(8);
				return false;
			}
			var sobj={
				format:format,
				clientip:clientip,
				jing:jing,
				wei:wei,
				content:content,
				reid:reid
			};
			if(content){
				var url="http://open.t.qq.com/api/t/reply";
				that.send_Request("POST",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format);
			}else{
				_QQweibo_showError(7);
			}
		},
		//发布带图片的微博
		pic:function(callback,format,content,clientip,jing,wei,pic){
			format=format||"json";
			clientip=clientip||"127.0.0.1";
			jing=jing||"";
			wei=wei||"";
			var sobj={
				format:format,
				clientip:clientip,
				content:content,
				jing:jing,
				wei:wei
			};
			if(pic){
				var url="http://open.t.qq.com/api/t/add_pic";
				that.send_Request("POST",url,that.build_Data(that.token,that.verifier,true,sobj,true),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format,pic);
			}else{
				_QQweibo_showError(9);
			}
		},
		//获取微博转播次数
		count:function(callback,format,ids){
			format=format||"json";
			if($Y(ids)=="array"){
				ids=ids.join(",");
			}
			var sobj={
				format:"json",
				ids:ids
			};
			if(ids){
				var url="http://open.t.qq.com/api/t/re_count";
				that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format);
			}else{
				_QQweibo_showError(10);
			}
		},
		//获取单条微博的转播/点评列表
		list:function(callback,format,rootid,pageflag,pagetime){
			format=format||"json";
			pageflag=pageflag||0;
			pagetime=pagetime||0;
			var sobj={
				format:format,
				pageflag:pageflag,
				pagetime:pagetime,
				rootid:rootid
			};
			if(rootid){
				var url="http://open.t.qq.com/api/t/re_list";
				that.send_Request("GET",url,that.build_Data(that.token,that.verifier,true,sobj),function(rs){
					if(callback){
						callback(rs);
					}
				},true,format);
			}else{
				_QQweibo_showError(11);
			}
		},
		error:function(n){
			return _QQweibo_msg(n);
		}
	}
	this.ok=this.login_Status;
	this.start=this.get_Request_Token;
	this.load=function(){
		if(!this.ok()){
			this.showLoading();
			this.start();
		}
	};
}

function _QQweibo_showError(n){
	n=$T(n||"noinfo");
	var WeiboError={
		"1":"所连接服务器无法返回Request Token数据",
		"2":"未获取token之前无法进行认证",
		"3":"Weibo.show函数缺少必要的参数id",
		"4":"Weibo.add函数缺少必要的参数content",
		"5":"Weibo.del函数缺少必要的参数id",
		"6":"Weibo.tui函数缺乏必要的参数reid",
		"7":"Weibo.reply函数缺少必要的参数content",
		"8":"Weibo.reply函数缺乏必要的参数reid",
		"9":"Weibo.pic函数缺乏必要的参数pic",
		"10":"Weibo.count函数缺乏必要的参数ids",
		"11":"Weibo.list函数缺少必要的参数rootid",
		"Invalid / expired Token":"你所输入的授权码无效",
		"access rate limit":"每分钟访问次数超过上限",
		"noinfo":"未知错误"
	}
	alert(WeiboError[n]||n);
}
function _QQweibo_msg(n){
	return (["成功","文件大小错误","","","有过多脏话","禁止访问:如城市，uin黑名单限制等","删除时：该记录不存在。发表时：父节点已不存在","","内容超过最大长度：420字节","包含垃圾信息：广告，恶意链接、黑名单号码等","发表太快，被频率限制","源消息已删除，如转播或回复时","源消息审核中","重复发表"][$P(n)])||"";
}
/**
//Sample

	var myw=new App.QQweibo("微博标点","4a2ee50d1f8c4f6xx97cc1f8c8fc7d1bf","eaed027xxxxd42ec9f31dc5958ad6cba","");
	//创建一个新的QQ微博对象，名字为  myw,
	//其中，参数依次表示， 应用名称， Appkey, Appsecret , 回调地址 ...

	myw.main=function(){
		//在这里编写的代码，是当用户登录成功后，会执行的代码
		myw.get("http://open.t.qq.com/api/user/info",{
			"format":"json"
		},function(rs){
			if(rs&&rs.data){
			 alert("读取个人信息成功");
			}
		});
		//上面是 微博对象的 get 用法。 参数依次是， 请求地址，返回数据格式，返回内容
	};

	// 定义好上面的操作之后，就可以开始让用户登录微博了。

	if(!myw.ok()){ // myw.ok() 用来判断用户是否已登录，如果已登录，则返回true, 否则返回 false
		//如果用户没登录，则执行以下操作
		//显示加载条
		myw.showLoading();
		//开始加载
		myw.start();
	}
	//alternative method "load()" in one line
	//myw.load()
*/
