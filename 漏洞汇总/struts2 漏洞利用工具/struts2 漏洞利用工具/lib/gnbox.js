/**
 * @author gainover
 * @version 1.8
 * @see http://www.toolmao.com/
 */
/**
 * 魔盒函数库版本号
 * @public
 * @field
 */
var $VERSION$="1.831";
/**
 * 存储当前已加载的函数库名称
 * @public
 * @field
 */
var $LIB_DATA$={};
/**
 * 魔盒函数库远程调用服务器设定
 * @public
 * @field
 */
var $LIB_SERVER$=["http://www.toolmao.com/box/ext/","http://xssreport.sinaapp.com/box/ext/","http://zongzi.sinaapp.com/box/ext/"];
/**
 * 扫描过程中所使用的服务器地址
 * @field
 */
var $THREAD_URL$="http://127.0.0.1:3200/";
/**
 * 变量类型中文解释
 * @field
 */
var $YCN={
		"object":"对象",
		"function":"函数",
		"array":"数组",
		"string":"字符串",
		"number":"数字",
		"boolean":"布尔值",
		"undefined":"未定义",
		"null":"空对象",
		"date":"日期",
		"htmlobject":"网页元素",
		"htmlmethod":"网页元素内置方法"
};
/**
 * 旧版函数库向新版函数库的映射转换
 * @field
 */
var $OLD2NEW$={
		"qqlogin":"login.qq",
		"sosologin":"login.soso",
		"md5":"coder.md5",
		"base64":"coder.base64",
		"sha1":"coder.sha1",
		"sha1_m":"coder.sha1",
		"baidulogin":"login.baidu",
		"qqweibo":"app.qqweibo",
		"buttonskin":"skin.button",
		"shortcut":"sys.shortcut",
		"gcolortable":"util.colortable",
		"sendkey":"util.sendkey",
		"html2tool":"util.html2tool"
};
/**
 * 获取网页中指定id的对象
 * @param {String} id 网页元素ID 网页中某一标记的id属性
 * @returns {TYPEDEF_HTMLOBJECT} 网页中的元素
 */
function $(id){return document.getElementById(id);}
/**
 * 获取网页中某一元素，不论参数是id还是HTMLObject
 * @param {String|HTMLObject} obj 元素id或元素本身
 * @returns {TYPEDEF_HTMLOBJECT} 网页元素
 */
function $$(a){return (typeof a).toLowerCase()=="object"?a:$(a);}
/**
 * 保留几位小数
 * @param {Number} number 数字
 * @param {Number} digit 小数点后保留位数
 * @returns {Number} 处理后的数字
 */
function $F(fl,digit){return Math.floor(fl*Math.pow(10,digit))/Math.floor(Math.pow(10,digit));}
/**
 * 将字符串或小数转换为整数
 * @param {Number|String} data 待转换的数字或字符串
 * @returns {Number} 转换后的整数
 */
function $P(i){return parseInt(i);}
/**
 * 去掉字符串两端的空白字符
 * @param {String} string 待处理的字符串
 * @returns {String} 去掉两端空白后的字符串
 */
function $T(s){return s.replace(/^\s+|\s+$/,"");}
/**
 * 向网页中输出内容
 * @see document.write
 * @param {String} data 被写入网页中的内容
 */
function $W(str){document.write(str);}
/**
 * 得到一个0~N之间的随机整数,不包括N
 * @param {Number} N 随机范围上限
 * @returns {Number} 随机数
 * @example
 * var x=$R2(10); //将得到一个0~10之间的整数,不包括10
 */
function $R2(_n){return Math.floor(Math.random()*_n);}
/**
 * 返回变量的类型字符串,小写形式
 * @param {TYPEDEF_ANY} variable 任意变量
 * @returns {String} 字符串类型(小写)
 */
function $Y(obj){
	var ot=(typeof obj).toLowerCase();
	if(ot=="object"){
		if(obj){
			try{
			if(Object.prototype.toString.call(obj).toLowerCase().indexOf("array")!=-1){
				ot="array";
			}else if(obj.attachEvent&&(obj.attachEvent+"").replace(/\s+/g,"")=="functionattachEvent(){[nativecode]}"){
				ot="htmlobject";
			}else if(/^function\w+\(\)\{\[nativecode\]\}$/.test(((obj+"")||"").replace(/\s+/g,""))){
				ot="htmlmethod";
			}
			}catch(e){alert(e.description)}
		}else{
			ot="null";
		}
	}
	return ot;
}
/**
 * 返回指定长度，指定内容的随机字符串
 * @param {String} length 字符串长度
 * @param {String} type 字符串类型,字母nsbc组合
 * @returns {String} 随机字符串
 */
function $R(_n,type){
	var c={n:"0123456789",s:"abcdefghijklmnopqrstuvwxyz",b:"ABCDEFGHIJKLMNOPQRSTUVWXYZ",c:"!@#$%^&*()_+\\][}{:;'\",./?><~`"};
    var r="",a="";
    if(type){
		type=type.split("");
		for(var i=0;i<type.length;i++){
			a+=c[type[i]];
		}
    }else{a=c.n+c.s+c.b;}
	for(var i=0;i<_n;i++){r+=a.charAt($R2(a.length));}
    return r;
}
/**
 * 检查某个全局库是否存在
 * @param {String} length 字符串长度
 * @param {String} type 字符串类型,字母nsbc组合
 * @returns {Boolean} 是否存在
 */
function $L(parent,sub){
	if(sub in parent && $Y(parent[sub])=="object"){
		return true;
	}
	return false;
}
/**
 * 在函数库中，用于定义该包所在的namespace
 * @param {String} sub Namespace名称
 */
function $Q(sub){
	if(!$L(window,sub)){
		window[sub]={};
	}
}
/**
 * 在函数库中，用于判断或者调用其它函数库
 * @param {String} name 函数库名称
 * @param {Boolean} load 是否加载该函数库,缺省时该函数仅作判断函数
 * @returns {Boolean} 是否已经加载改函数库
 */
function $D(name,load){
	if(!$LIB_DATA$[name]){
		if(load){
			use(name);
		}
		var lid=$R(16);
		$LIB_DATA$[name]=lid;
		return false;
	}
	return true;
}
/**
 * 数组序列化为字符串
 * @param {Array} arr 待序列化的数组
 * @param {Number} [n=0] 缩进层次
 * @param {Boolean} [is_array=false] 是否是字符串
 * @returns {String} 数组转化后的字符串
 */

function arr2str(arr,n,is_array){
	if(is_array!==false){is_array=true;}
	if(!n){n=0;}
	var str="[\r\n";
	var tmp=[];
	for(var i=0;i<arr.length;i++){
		var ot=$Y(arr[i]);
		var rt="\t".repeat(n);
		var suffix="\""+i+"\":";
		if(is_array){
			suffix="";
		}
		switch(ot){
			case "htmlmethod":
				tmp.push(rt+suffix+"[dom-element-method]");
				break;
			case "htmlobject":
				tmp.push(rt+suffix+"[dom-element]");
				break;
			case "object":
				tmp.push(rt+suffix+obj2str(arr[i],n+1));
				break;
			case "null":
				tmp.push(rt+suffix+"null");
				break;
			case "array":
				tmp.push(rt+suffix+arr2str(arr[i],n+1,true));
				break;
			case "function":
			case "number":
				tmp.push(rt+suffix+arr[i].toString());
				break;
			case "undefined":
				tmp.push(rt+suffix+"undefined");
				break;
			case "boolean":
				tmp.push(rt+suffix+obj[i].toString());
				break;
			default:
				tmp.push(rt+suffix+"\""+arr[i].toString().replace(/\\/g,"\\\\").replace(/"/g,"\\\"").replace(/\r/g,"\\r").replace(/\n/g,"\\n")+"\"");
		}
	}
	str+=tmp.join(",\r\n");
	return str+"\r\n"+"\t".repeat(n-1)+"]";
}
/**
 * 对象转换为字符串
 * @param {TYPEDEF_JSONOBJECT} obj 任意JS对象
 * @param {Number} [n=0] 缩进层次
 * @param {Boolean} [is_array=false] 是否是数组
 * @returns {String} 对象转换后的字符串
 */
function obj2str(obj,n,is_array){
	if(!n){n=0;}
	var str="{\r\n";
	var tmp=[];
	for(var i in obj){
		var ot=$Y(obj[i]);
		var rt="\t".repeat(n);
		var suffix="\""+i+"\":";
		if(is_array){
			suffix="";
		}
		switch(ot){
			case "htmlmethod":
				tmp.push(rt+suffix+"[dom-element-method]");
				break;
			case "htmlobject":
				tmp.push(rt+suffix+"[dom-element]");
				break;
			case "object":
				tmp.push(rt+suffix+obj2str(obj[i],n+1));
				break;
			case "null":
				tmp.push(rt+suffix+"null");
				break;
			case "array":
				tmp.push(rt+suffix+arr2str(obj[i],n+1,true));
				break;
			case "function":
			case "number":
				tmp.push(rt+suffix+obj[i].toString());
				break;
			case "undefined":
				tmp.push(rt+suffix+"undefined");
				break;
			case "boolean":
				tmp.push(rt+suffix+obj[i].toString());
				break;
			default:
				tmp.push(rt+suffix+"\""+obj[i].toString().replace(/\\/g,"\\\\").replace(/"/g,"\\\"").replace(/\r/g,"\\r").replace(/\n/g,"\\n")+"\"");
		}
	}
	str+=tmp.join(",\r\n");
	return str+"\r\n"+"\t".repeat(n-1)+"}";
}
/**
 * 字符串转换为JS对象(JSON)
 * @param {String} str 待转换的字符串 {...} 或者 [...]
 * @returns {TYPEDEF_JSONOBJECT} 一个JS对象
 */
function str2obj(str){
	return eval("("+str+")");
}
/**
 * 字符串转换为数组
 * @param {String} str 待转换的字符串 {...} 或者 [...]
 * @returns {TYPEDEF_JSONOBJECT} 一个JS对象
 */
function str2arr(str){
	return eval("("+str+")");
}
/**
 * 扩展函数库调用工具
 * @param {String} lib 函数库名称,注意：函数库需放于魔盒extlib目录中, 函数库名称即为文件名(不包含文件后缀)
 */
function use(lib){
	lib=lib.lc();
	if($OLD2NEW$[lib]){
		lib=$OLD2NEW$[lib];
	}
	if(!$D(lib)){
		var jpath=external.path+"extlib\\"+lib+".js";
		if(/^https?:\/\//.test(lib)){
			jpath=lib;
		}else{
			if(!File.exists(external.path+"extlib\\"+lib+".js")){
				//alert("需要调用"+lib+".js文件,但extlib目录不存在该文件");
				jpath=$LIB_SERVER$[$R2($LIB_SERVER$.length)]+lib+".js";
			}
		}
		document.write("<scrip"+"t type='text/javascrip"+"t' src='"+jpath+"'></scr"+"ipt>");
	}
}
/**
 * 扩展函数库调用工具
 * @param {String} lib 函数库名称,注意：函数库需放于魔盒extlib目录中, 函数库名称即为文件名(不包含文件后缀)
 */
function require(lib){
	lib=lib.lc();
	if($OLD2NEW$[lib]){
		lib=$OLD2NEW$[lib];
	}
	if(!$D(lib)){
		var jpath=external.path+"extlib\\"+lib+".js";
		if(/^https?:\/\//.test(lib)){
			jpath=lib;
		}else{
			if(!File.exists(external.path+"extlib\\"+lib+".js")){
				jpath=$LIB_SERVER$[$R2($LIB_SERVER$.length)]+lib+".js";
			}
		}
		var s=document.createElement("script");
		s.type="text/javascript";
		s.src=jpath;
		document.body.appendChild(s);
	}
}

/**
 * 控制魔盒主窗口的外观，大小，位置等。
 * @namespace 窗口操作
 */
var Win={
	/**
	 * @ignore
	 * @returns
	 */
	param:function(){
		var params=[];
		var pcount=external.paramCount;
		for(var i=0;i<pcount;i++){
			params.push(external.param(i+1));
		}
		return params;
	},
	/**
	 * 内存回收函数，程序运行一段时间后内存会增加，通过调用此函数，可对内存进行释放，注意，程序中只需调用一次即可
	 * @param {Number} n 时间（单位：秒）
	 * @returns
	 */
	gc:function(n){
		n=n|0;
		n=(n||30)*1000;
		if(window["__gc_timer"]){
			try{
				Dom.Timer.stop(window["__gc_timer"]);
			}catch(e){}
		}
		window["__gc_timer"]=Dom.Timer.start(function(){
			external.memoryClear();
		},n);
	},
	/**
	 * @ignore
	 * @param param
	 * @param value
	 * @returns
	 */
	params:function(param,value){
		if(value||value===0){
			external[param]=value;
		}else{
			return external[param];
		}
	},
	/**
	 * 设置窗体到屏幕顶部的距离
	 * @param {Number|String} [value=""] 距离值（单位：像素）
	 * @returns {Number} 窗体到屏幕顶部的距离
	 */
	top:function(value){
		return this.params("top",value);
	},
	/**
	 * 设置窗体到屏幕左边的距离
	 * @param {Number|String} [value=""] 距离值 （单位：像素）
	 * @returns {Number} 窗体到屏幕左边的距离
	 */
	left:function(value){
		return this.params("left",value);
	},
	/**
	 * 设置窗体的宽度
	 * @param {Number|String} [value=""] 宽度值 （单位：像素）
	 * @returns {Number} 窗体宽度
	 */
	width:function(value){
		return this.params("width",value);
	},
	/**
	 * 设置窗体的高度
	 * @param {Number|String} [value=""] 高度值 （单位：像素）
	 * @returns {Number} 窗体高度
	 */
	height:function(value){
		return this.params("height",value);
	},
	/**
	 * 设置窗体的标题栏
	 * @param {String} [value=""] 窗口标题栏文字
	 * @returns {String} 窗口标题栏文字
	 */
	caption:function(value){
		return this.params("caption",value);
	},
	/**
	 * 改变窗体的透明度
	 * @param {Number|String} [value=""] 透明度0~255或者不填写
	 * @returns {Number} 窗体的透明度值
	 */
	alpha:function(value){
		return this.params("alpha",value);
	},
	/**
	 * 改变窗体右键菜单的作者信息
	 * @param {String} author 作者名称，即右键菜单中所显示的文字
	 * @param {String} moreInfo 链接的网址或者更详细的作者信息
	 * @param {Number} method 表示修改方式，0为网址型，1为信息型
	 * @returns
	 */
	author:function(a,b,c){
		external.author(a,b,c);
	},
	/**
	 * 返回当前应用所在根路径，在魔盒1.7及以上版本中，独立运行应用可直接调用Win.path(),而内置应用需根据页面所在路径对参数进行设置
	 * @param {Number} [subdir=0] 表示主HTML文件相对于该应用根目录的路径距离, 如 ./plugins/我的应用/main.htm中,subdir=0,而./plugins/我的应用/test/abc.htm中,subdir则等于1
	 * @returns {Number} 应用根路径，类型为绝对路径
	 */
	path:function(n){
		var url=Win.param()[1];
		if(url&&url=="-html"){
			return File.parentpath(url)+"\\";
		}else{
			url=location.href;
			n=$P(n||0);
			n+=1;
			for(var i=0;i<n;i++){
				url=File.parentpath(url);
			}
			url=url.replace(/^file:\/\/\//,"").replace(/\//g,"\\").replace(/%20/g," ");
			return url+"\\";
		}
	},
	/**
	 * 一般与登录跳转页面合用，获取被跳转页面的cookies值
	 * @returns
	 */
	cookie:function(){
		return external.cookie;
	},
	/**
	 * 获得IE浏览器版本号，目前最大为IE7
	 * @returns {Number} 浏览器版本
	 */
	version:function(){
		return navigator.appVersion.getMatch(/MSIE\s(\d\.\d)/);
	},
	/**
	 * 返回系统版本号
	 * @returns {Number} 系统版本号
	 */
	sysversion:function(){
		var map={"6.1":"7","6.0":"vista","5.2":"server 2003","5.1":"xp","5.0":"2000"};
		var vn=navigator.userAgent.getMatch(/windows\sNT\s(\d\.\d)/i);
		return "windows "+(map[vn]||"unknown");
	},
	/**
	 * 获取一个ActiveXObject控件
	 * @param ActiveXObject控件名称
	 * @returns {TYPEDEF_COMOBJECT}
	 */
	obj:function(s){
		return external.ActiveXObject(s);
	},
	/**
	 * 常用com组件常量
	 * @namespace
	 */
	com:{
		/**
		 * 文件读写
		 */
		FSO:"Scripting.FileSystemObject",
		/**
		 * 宿主脚本
		 */
		WSH:"WScript.Shell",
		/**
		 * 数据库连接
		 */
		CON:"Adodb.Connection",
		/**
		 * 数据集
		 */
		RDS:"Adodb.Recordset",
		/**
		 * 桌面应用
		 */
		SHA:"Shell.Application",
		/**
		 * 流数据操作
		 */
		STM:"Adodb.Stream",
		/**
		 * 基于WEB的企业管理
		 */
		WSS:"WbemScripting.SWbemLocator"
	},
	/**
	 * 返回应用程序exe所在的路径及程序名称
	 * @returns {String} 绝对路径
	 */
	exe:function(){
		return external.exeName;
	},
	/**
	 * 在页面中执行一个外部脚本
	 * @param {String} url JS或VBS地址，绝对路径
	 * @param {String} type 执行的脚本类型，javascript或vbscript
	 * @param {Boolean} encrypt 脚本是否为加密脚本
	 * @returns
	 */
	exeScript:function(p1,p2,p3){
		external.exeScript(p1,p2,!!p3);
	},
	/**
	 * 将程序窗口改变为激活状态
	 * @returns
	 */
	activate:function(){
		external.activate();
	},
	/**
	 * 窗口全屏操作
	 * @returns
	 */
	fullscreen:function(){
		external.fullscreen();
	},
	/**
	 * 窗口居中操作
	 * @returns
	 */
	center:function(){
		var w=external.width;
		var h=external.height;
		var cl=$P((Win.Screen.width-w)/2);
		var ct=$P((Win.Screen.height-h)/2);
		external.moveTo(cl,ct);
	},
	/**
	 * 窗口关闭操作
	 * @returns
	 */
	close:function(){
		external.close();
	},
	/**
	 * 显示程序，该函数存在于魔盒1.7版本及以上，开发者需调用该函数，才能显示出程序界面
	 * @returns
	 */
	show:function(){
		external.alpha=255;
	},
	/**
	 * 窗口移动
	 * @param {Number} xdis 窗口移动的水平距离（单位：像素）
	 * @param {Number} ydis 窗口移动的垂直距离（单位：像素）
	 * @returns
	 */
	move:function(xdis,ydis){
		external.move($P(xdis),$P(ydis));
	},
	/**
	 * 将窗口移动到指定坐标
	 * @param {Number} x 横坐标
	 * @param {Number} y 纵坐标
	 * @returns
	 */
	moveTo:function(x,y){
		external.moveTo($P(x),$P(y));
	},
	/**
	 * 将窗口从当前位置动态移至屏幕中央
	 * @param {Number} step 设置移动次数，数值越小，移动距离越大
	 * @param {Number} interval 每一步移动的间隔时间,单位：毫秒 (1000毫秒=1秒)
	 * @returns
	 */
	moveToCenter:function(step,interval){
		var ct=$P(step);
		var w=external.width;
		var h=external.height;
		var l=external.left;
		var t=external.top;
		var avx=((Win.Screen.width-w)/2-l)/ct;
		var avy=((Win.Screen.height-h)/2-t)/ct;
		var x=Dom.Timer.start(function(){
			ct--;
			l=external.left;
			t=external.top;
			if(ct<0){
				Dom.Timer.stop(x);
			}else{
				external.moveTo($P(l+avx),$P(t+avy));
			}
		},interval);
	},
	/**
	 * @ignore
	 * @param url
	 * @param sizeParam
	 * @param marginParam
	 * @param resizable
	 * @param scaleCenter
	 * @returns
	 */
	customBorder:function(url,sizeParam,marginParam,resizable,scaleCenter){
		sizeParam=sizeParam||{"width":500,"height":482};
		marginParam=marginParam||{"top":6,"bottom":9,"left":6,"right":9};
		scaleCenter=scaleCenter||false;
		//先要去掉透明度，否则不支持透明边框显示
		external.skinBorderNoAlpha();
		external.skinBorder(url,marginParam.top,marginParam.bottom,marginParam.left,marginParam.right);
		external.skinResize=!!resizable;
		//bug 2011/7/26/ external.skinResize cannot read
		if(!!resizable&&scaleCenter){
			//external.skinScale(scaleCenter.top,scaleCenter.left,scaleCenter.width,scaleCenter.height);
		}else{

		}
		external.resizeTo(sizeParam.width,sizeParam.height);
		external.skinBorderShow();
	},
	/**
	 * 改变窗口大小
	 * @param {Number} w 窗口宽度
	 * @param {Number} h 窗口高度
	 * @returns
	 */
	resizeTo:function(w,h){
		external.resizeTo($P(w),$P(h));
	},
	/**
	 * 设置应用程序边框
	 * @param {Number} borderStyle 边框样式,介绍如上
	 * @param {Number} borderWidth 边框宽度
	 * @param {Boolean} border3D 边框是否显示3D立体效果, - -不是什么好效果，别以为是3D动画那样的
	 * @returns {Boolean} 窗口边框是否发生改变
	 * @example
	 * borderstyle的介绍
	 * 0 表示 无边框
	 * 1 表示 单边框
	 * 2 表示 边框可改变大小
	 * 3 表示 对话框类型
	 * 4 表示 工具框，不可改变大小
	 * 5 表示 工具框，可改变大小
	 */
	border:function(p1,p2,p3){
		return external.setBorder(p1,p2,!!p3);
	},
	/**
	 * 设置窗体圆角
	 * @param {Number} cornerWidth 圆角高度
	 * @param {Number} cornerHeight 圆角高度
	 * @returns
	 */
	corner:function(p1,p2){
		external.setCorner($P(p1),$P(p2));
	},
	/**
	 * 设置程序显示状态
	 * @param {String} status 窗体状态类型,见介绍
	 * @returns
	 * @example
	 * status 的值
	 * min		表示窗口最小化
	 * max		表示窗口最大化
	 * normal	表示将窗口恢复正常状态
	 * hide		表示窗口隐藏
	 * show		表示窗口显示
	 */
	status:function(p1){
		external.setStatus(p1);
	},
	/**
	 * 切换窗体高度
	 * @param {Number} height 窗口高度 （单位：像素）
	 * @returns
	 */
	toggle:function(height){
		(external.fold(parseInt(height))||external.fold());
	},
	/**
	 * 页面重定向
	 * @param {String} fromURL 被调整的页面地址
	 * @param {String} toURL	跳转后的页面地址
	 * @param {String} cookiebool 是否存存储被跳转页面的Cookies
	 * @returns
	 */
	redirect:function(from,to,cookiebool){
		external.setRedirect(from,to,!!cookiebool);
	},
	/**
	 * 窗口渐变显示
	 * @ignore
	 * @param param
	 * @returns
	 */
	gradient:function(param){
		if(!param){param={};}
		if(param["from"]||param["from"]===0){param["from"]=param["from"]/100*255;}
		if(param["to"]||param["to"]===0){param["to"]=param["to"]/100*255;}
		var from=param["from"]===0?0:(param["from"]||external.alpha||255);
		var step=param["step"]||10;
		var to=param["to"]===0?0:(param["to"]||0);
		var interval=param["interval"]===0?0:(param["interval"]||100);
		var sign=from>to?-1:1;
		external.alpha=from;
		Dom.Timer.start(function(){
			var tmp=external.alpha+sign*step;
			if(tmp>255){tmp=255;}
			if(tmp<0){tmp=0;}
			external.alpha=tmp;
		},interval,function(){
			var alpha=external.alpha;
			return sign<0?(alpha<=to):(alpha>=to);
		});
	},
	/**
	 * 程序重新启动
	 * @returns
	 */
	restart:function(){
		external.alpha=0;
		this.resizeTo(0,0);
		Sys.CMD.open();
		Sys.CMD.run(this.exe());
		Sys.CMD.close();
		Win.close();
	},
	/**
	 * 魔盒内置HTTP服务,目前仅供扫描服务使用
	 * @namespace 内置HTTP服务
	 * @see Thread
	 */
	Http:{
		/**
		 * HTTP服务启动
		 * @returns
		 */
		start:function(){
			external.httpserver=true;
		},
		/**
		 * HTTP服务停止
		 * @returns
		 */
		stop:function(){
			external.httpserver=false;
		}
	},
	/**
	 * 对话框
	 * @namespace 对话框
	 */
	Dialog:{
		/**
		 * 文件选择框
		 * @param {String} dialogTitle 文件选择框标题
		 * @param {String} extFilter 文件后缀过滤设置
		 * @param {String} defaultDir 默认目录路径
		 * @returns {String} 被选择的文件路径
		 */
		open:function(s1,s2,s3){
			/*title, ext , default directory*/
			return external.openFile(s1,s2,s3);
		},
		/**
		 * 保存文件框
		 * @param {String} dialogTitle 文件选择框标题
		 * @param {String} extFilter 文件后缀过滤设置
		 * @param {String} defaultDir 默认目录路径
		 * @returns {String} 被保存的文件路径
		 */
		save:function(s1,s2,s3){
			return external.saveFile(s1,s2,s3);
		},
		/**
		 * 目录对话框
		 * @param {String} title 目录对话框标题
		 * @returns {String} 被选择的目录地址
		 */
		dir:function(title){
			var o=Win.obj("Shell.Application");
			var fd=o.BrowseForFolder(0,(title||"请选择一个目录"),0x0040);
			if(fd){
				var path=fd.items().item().Path;
				o=null;
				return path;
			}else{
				o=null;
				return false;
			}
		}
	},
	/**
	 * 窗口接收文件拖放
	 * @namespace 拖放文件
	 */
	Accept:{
		/**
		 * 数组:用于存放用户拖放到程序界面上的文件名称
		 * @field
		 */
		files:[],
		/**
		 * 用于设置用户是否可以向程序拖放文件
		 * @param {Boolean} bool
		 * @returns
		 */
		set:function(bool){
			external.fileAccepted(!!bool);
		},
		/**
		 * 用于获得当前用户是否可以向程序拖放文件
		 * @returns {Boolean} 是否可以向程序拖放文件
		 */
		get:function(){
			return external.fileAccepted();
		},
		/**
		 * 拖放回调函数，需用户自行定义操作
		 * @param {Array} list 存储了用户所有拖放进来的文件名
		 * @returns
		 */
		on:function(list){

		},
		/**
		 * @ignore
		 * @param filelist
		 * @returns
		 */
		onFiles:function(filelist){
			this.files=filelist.split(">");
			for(var i=0,l=this.files.length;i<l;i++){
				this.files[i]=this.files[i].replace(/^"|"$/g,"");
			}
			if(this.on && $Y(this.on)=="function"){
				this.on(this.files);
			}
		}
	},
	/**
	 * 窗口拖动设置
	 * @namespace 窗口拖动
	 */
	Drag:{
		/**
		 * 具有拖动功能的网页元素数组
		 * @field
		 */
		item:[],
		/**
		 * 设置网页中某一元素可以用于窗口拖动
		 * @param {String|Array[]|HTMLObject} item 元素ID或元素数组或HTML元素
		 * @returns
		 */
		set:function(item){
			var tp=(typeof item).toLowerCase();
			var items=[];
			if(tp == "string" || tp == "object"){
				items.push(item);
			}else{
				items=item||this.item;
			}
			for(var i=0,l=items.length;i<l;i++){
				var tmp=$$(items[i]);
				if(tmp){
					with(tmp){
						style.cursor="pointer";
						onmousedown=this.mouseDown;
						onmouseup=this.mouseUp;
						onmousemove=this.mouseMove;
					}
				}
			}
		},
		/**
		 * @ignore
		 * @returns
		 */
		mouseDown:function(){
			if(event.button==1){
				external.dragDown();
			}
		},
		/**
		 * @ignore
		 * @returns
		 */
		mouseUp:function(){
			external.dragUp();
		},
		/**
		 * @ignore
		 * @returns
		 */
		mouseMove:function(){
			external.dragMove();
		}
	},
	/**
	 * 设置应用程序的托盘图标
	 * @namespace 托盘图标
	 */
	Tray:{
		/**
		 * 为程序添加一个托盘图标，格式ico，大小16*16
		 * @param {String} path 托盘图标的绝对路径
		 * @returns
		 */
		add:function(path){
			external.addTrayIcon(path);
		},
		/**
		 * 设置程序托盘图标状态
		 * @param {Boolean} showIcon 是否启动托盘图标
		 * @param {Number} showIndex 显示第几个托盘图标
		 * @param {Boolean} showTurn 是否动态轮流显示托盘图标
		 * @param {Number} showInterval 轮流的时间间隔 （单位:秒）
		 * @returns
		 */
		start:function(showIcon,showIndex,showTurn,showInterval){
			external.trayIcon(!!showIcon,showIndex||0,!!showTurn,showInterval);
		}
	},
	/**
	 * 系统剪贴板
	 * @namespace 剪贴板
	 */
	Clipboard:{
		/**
		 * 将内容复制到剪贴板
		 * @param {String} str 需要复制的内容
		 * @returns
		 */
		copy:function(str){
			window.clipboardData.setData("text",str);
		},
		/**
		 * 获取剪贴板中的数据
		 * @returns {String} 剪贴板中的数据
		 */
		data:function(){
			return window.clipboardData.getData("text");
		}
	},
	/**
	 * 系统右键菜单设置
	 * @namespace 右键菜单
	 */
	Menu:{
		/**
		 * 右键菜单设置是否被初始化
		 * @ignore
		 * @field
		 */
		init:false,
		/**
		 * 散列，用于存储用户的菜单设置
		 * @field
		 */
		settings:{},
		/**
		 * 添加一个右键菜单
		 * @param {String} name 菜单名称
		 * @param {String} script 点击菜单时被执行的脚本
		 * @param {String} pos 插入位置, "last" 或 "first"
		 * @returns
		 */
		add:function(name,script,pos){
			if(!this.init){
				this.clear();
				this.init=true;
			}
			pos=pos||"last";
			if(pos!=="last"&&pos!=="first"){
				pos=$P(pos);
				if(isNaN(pos)){
					pos="last";
				}
			}
			external.addMenu(name,script,pos);
		},
		/**
		 * 清除所有已添加的菜单
		 * @returns
		 */
		clear:function(){
			external.addMenu("","","clear");
		},
		/**
		 * 添加一个复制菜单
		 * @param {String} [pos=""] 插入位置
		 * @param {String} [text=""] 菜单文本
		 * @returns
		 */
		copy:function(pos,text){
			this.add(text||"复制","document.execCommand('copy')",pos);
		},
		/**
		 * 添加一个粘贴菜单
		 * @param {String} [pos=""] 插入位置
		 * @param {String} [text=""] 菜单文本
		 * @returns
		 */
		paste:function(pos,text){
			this.add(text||"粘贴","document.execCommand('paste')",pos);
		},
		/**
		 * 添加一个剪切菜单
		 * @param {String} [pos=""] 插入位置
		 * @param {String} [text=""] 菜单文本
		 * @returns
		 */
		cut:function(pos,text){
			this.add(text||"剪切","document.execCommand('cut')",pos);
		},
		/**
		 * 添加一个刷新菜单
		 * @param {String} [pos=""] 插入位置
		 * @param {String} [text=""] 菜单文本
		 * @returns
		 */
		refresh:function(pos,text){
			this.add(text||"刷新","top.location.reload()",pos);
		},
		/**
		 * 添加右键菜单设置
		 * @param {String} oid	被添加的网页元素的ID,或%name,>tagName,.className
		 * @param {String} menuName	菜单定义名称，任意唯一字符串值
		 * @param {Object} param 存储菜单名字及对应响应函数，如 "复制":function(){..}
		 * @param {Boolean} force 是否强制添加右键菜单，针对textarea等可编辑元素使用
		 * @returns
		 */
		addSetting:function(oid,menuName,param,force){
			var id=null;
			if(oid==document){
				id=document.body;
			}else{
				id=oid;
			}
			var objs=[];
			if($Y(id)!="array"){
				if($Y(id)=="string"){
					var h=id.substring(0,1);
					switch(h){
						case "%":
							id=id.replace(/^%/,"");
							var cobjs=document.getElementsByTagName("*");
							for(var i=0,l=cobjs.length;i<l;i++){
								(function  (){
									var cname=cobjs[i].getAttribute("name");
									if(new RegExp("\\b"+id+"\\b").test(cname)){
										objs.push(cobjs[i]);
									}
								})(i);
							}
							break;
						case ">":
							id=id.replace(/^>/,"");
							objs=document.getElementsByTagName(id);
							break;
						case ".":
							id=id.replace(/^\./,"");
							var cobjs=document.getElementsByTagName("*");
							for(var i=0,l=cobjs.length;i<l;i++){
								(function  (){
									var cname=cobjs[i].className;
									if(new RegExp("\\b"+id+"\\b").test(cname)){
										objs.push(cobjs[i]);
									}
								})(i);
							}
							break;
						default:
							objs.push(id);
					}
				}else{
					objs.push(id);
				}
			}
			//alert(objs);
			for(var i=0,l=objs.length;i<l;i++){
				(function  (i){
					Dom.Event.add(objs[i],"contextmenu",function  (){
						var point=Dom.Event.point();
						var eobj=Dom.Event.obj();
						Dom.Html.attr(eobj,"menuItem",menuName);
						var flag=true;
						if(eobj&&eobj.tagName){
							var tag=(eobj.tagName+"").lc();
							if(tag=="textarea"||tag=="input"||eobj.getAttribute("contentEditable")==true){
								flag=false;
							}
							if(force){
								//强制更改右键菜单
								flag=true;
							}
							if(flag){
								var x=point.sx;
								var y=point.sy;
								Win.Menu.change({
									tagName:eobj.tagName||"",
									name:eobj.name||"",
									className:eobj.className||"",
									id:eobj.id||"",
									contentEditable:eobj.getAttribute("contentEditable")||"",
									menuItem:eobj.getAttribute("menuItem")||""
								});
								external.menuPopUp(x,y);
								event.cancelBubble=true;
								return false;
							}
						}
					});
				})(i);
			}
			this.settings[menuName]=param||{};
		},
		/**
		 * @ignore
		 * @param menuName
		 * @returns
		 */
		loadSetting:function(menuName){
			return this.settings[menuName]||null;
		},
		/**
		 * @ignore
		 * @param obj
		 * @returns
		 */
		change:function(obj){
			if(obj.menuItem){
				var setting=this.loadSetting(obj.menuItem);
				if(setting){
					this.clear();
					for(var i in setting){
						var item=setting[i];
						if($Y(item)=="string"){
							switch(item.lc()){
								case "paste":
								case "refresh":
								case "cut":
								case "copy":
									this[item.lc()]();
									break;
								default:
									Win.Menu.add(i,item);
							}
						}else if($Y(item)=="function"){
							var tmpfunc="Menufunc_"+$R(8);
							window[tmpfunc]=item;
							Win.Menu.add(i,tmpfunc+"()");
						}
					}
				}
			}else{
				Win.Menu.clear();
			}
		},
		/**
		 * 恢复菜单的默认设置
		 * @returns
		 */
		defaultMenu:function  (){
			Win.Menu.addSetting(document,"defaultSetting");
		}
	},
	/**
	 * 程序边框设置
	 * @namespace 程序边框
	 */
	Border:{
		/**
		 * 将程序边框设置为无
		 * @returns {Boolean} 窗口边框是否发送改变
		 */
		none:function(){
			return external.setBorder(0,0,0);
		},
		/**
		 * 通过图片自定义程序边框
		 * @param {String} url 边框图片的绝对路径
		 * @param {Object} sizeParam 边框大小的设置
		 * @param {Number} sizeParam.width 边框宽度
		 * @param {Number} sizeParam.height 边框高度
		 * @param {Object} marginParam 边框与网页边框距离设置
		 * @param {Number} marginParam.left 左边距
		 * @param {Number} marginParam.right 右边距
		 * @param {Number} marginParam.top 顶边距
		 * @param {Number} marginParam.bottom 底边距
		 * @param {Boolean} resizable 是否可改变大小
		 * @param {Object} scaleCenter 九宫格缩放中心矩形参数
		 * @param {Number} scaleCenter.top 矩形左上角到顶边框距离
		 * @param {Number} scaleCenter.left 矩形左上角到左边框距离
		 * @param {Number} scaleCenter.width 矩形宽
		 * @param {Number} scaleCenter.height 矩形高
		 * @returns
		 */
		custom:function(url,sizeParam,marginParam,resizable,scaleCenter){
			Win.customBorder(url,sizeParam,marginParam,resizable,scaleCenter);
		}
	},
	/**
	 * 背景脚本设置
	 * @namespace 背景脚本
	 */
	Script:{
		/**
		 * 插入一个新的背景脚本
		 * @param {String} reg 需要被插入的网页地址，可以是正则表达式的字符串形式
		 * @param {String} script 需要插入的脚本的绝对路径
		 * @param {Boolean} replace 是否替换原有地址所具有的规则
		 * @returns
		 */
		insert:function(reg,script,replace){
			replace=!!replace;
			external.addBackgroundScript(reg,script,replace);
		}
	},
	/**
	 * 屏幕对象
	 * @namespace 屏幕
	 * @see window.screen
	 */
	Screen:screen
};

/**
 * 本地文件读写操作
 * @namespace 文件操作
 */
var File={
	/**
	 * @ignore
	 */
	obj:null,
	/**
	 * @ignore
	 */
	filearray:{},
	/**
	 * 列出所有被操作的文件路径信息
	 * @param {String} [listType="handle"] 所列内容类型 "handle" 或 "path"
	 * @returns {Array} 返回所有文件句柄的数组或所有文件路径的数组
	 */
	list:function(param){
		var c=[];
		for(var i in this.filearray){
			(!param||param=="handle")?c.push(i):c.push(this.filearray[i]);
		}
		return c;
	},
	/**
	 * 获取当前被操作的文件数目
	 * @returns
	 */
	count:function(){
		return this.list().length;
	},
	/**
	 * 打开一个文件
	 * @param {String} filepath 被打开的文件绝对路径
	 * @param {Boolean} forLineRead 被打开的文件用于一行一行的读取
	 * @returns {TYPEDEF_FILEHANDLE} 被打开的文件句柄
	 */
	open:function(filename,forLineRead){
		var fileno=$R(16);
		this.filearray[fileno]=filename;
		if(forLineRead){
			if(!File.obj){
				File.obj=Win.obj(Win.com.FSO);
			}
			this.filearray[fileno]=File.obj.OpenTextFile(filename,1);
		}
		return fileno;
	},
	/**
	* 读取一行文件内容
	*/
	line:function(fileno){
		var fh=this.filearray[fileno];
		if(!fh.AtEndOfStream){
			return fh.ReadLine();
		}else{
			File.obj=null;
			return false;
		}
	},
	/**
	 * 读取一个文件的内容
	 * @param {TYPEDEF_FILEHANDLE} fileHandle 被读取的文件的文件句柄,通常由File.open函数返回
	 * @returns {String|Boolean} 文件内容，如果文件不存在或读取错误，返回false
	 */
	read:function(fileno){
		var FSO=Win.obj(Win.com.FSO);
		var filepath=this.filearray[fileno];
		if(FSO.FileExists(filepath)){
			FSO=null;
			return (external.readData(filepath));
		}else{
			FSO=null;
			return false;
		}
	},
	/**
	 * 向文件写入内容
	 * @param {TYPEDEF_FILEHANDLE} fileHandle 被写入的文件的文件句柄,通常由File.open函数返回
	 * @param {String} content 被写入的文件内容
	 * @param {Boolean} create 是否强制覆盖已存在文件
	 * @returns {Boolean} 是否写入成功
	 */
	write:function(fileno,content,create){
		var FSO=Win.obj(Win.com.FSO);
		var filepath=this.filearray[fileno];
		if(create!==false||FSO.FileExists(filepath)){
			FSO=null;
			external.writeData(filepath,content);
			return true;
		}else{
			FSO=null;
			return false;
		}
	},
	/**
	 * 向文件末尾追加内容
	 * @param {TYPEDEF_FILEHANDLE} fileHandle 被写入的文件的文件句柄,通常由File.open函数返回
	 * @param {String} content 被追加写入的文件内容
	 * @returns {Boolean} 是否写入成功
	 */
	append:function(fileno,content){
		var FSO=Win.obj(Win.com.FSO);
		var filepath=this.filearray[fileno];
		if(FSO.FileExists(filepath)){
			var tmp=FSO.openTextFile(filepath,8,true);
			tmp.write(content);
			tmp.close();
			FSO=null;
			return true;
		}else{
			FSO=null;
			return false;
		}
	},
	/**
	 * 关闭已打开的文件句柄
	 * @param {TYPEDEF_FILEHANDLE} fileHandle 被写入的文件的文件句柄,通常由File.open函数返回
	 * @returns
	 */
	close:function(fileno){
		delete this.filearray[fileno];
	},
	/**
	 * 复制文件
	 * @param {String} from 文件原来的绝对路径
	 * @param {String} to 需要复制到哪里？绝对路径
	 * @param {Boolean} overwrite 如果目标位置已经存在该文件，是否强行覆盖
	 * @returns
	 */
	copy:function(from,to,overwrite){
		try{
			var FSO=Win.obj(Win.com.FSO);
			FSO.CopyFile(from,to,overwrite);
			FSO=null;
			return true;
		}catch(e){
			return false;
		}
	},
	/**
	 * 删除文件
	 * @param {String} filepath 被打开的文件绝对路径
	 * @param {Boolean} force 是否强制删除文件
	 * @returns {Boolean} 是否删除成功
	 */
	del:function(file,force){
		try{
			var FSO=Win.obj(Win.com.FSO);
			FSO.DeleteFile(file,force);
			FSO=null;
			return true;
		}catch(e){
			return false;
		}
	},
	/**
	 * 重命名文件
	 * @param {String} oldfile 需要重命名的文件路径（绝对路径）
	 * @param {String} newfile 新的文件路径（绝对路径）
	 * @param {Boolean} overwrite 如果新文件路径已存在同名文件，是否覆盖
	 * @returns {Boolean} 是否重命名成功
	 */
	rename:function(oldfile,newfile,overwrite){
		try{
			this.copy(oldfile,newfile,overwrite);
			this.del(oldfile);
			return true;
		}catch(e){
			return false;
		}
	},
	/**
	 * 判断一个文件是否存在
	 * @param {String} filepath 文件绝对路径
	 * @returns {Boolean} 文件是否存在
	 */
	exists:function(file){
		try{
			var FSO=Win.obj(Win.com.FSO);
			var fe=FSO.FileExists(file);
			FSO=null;
			return fe;
		}catch(e){
			return false;
		}
	},
	/**
	 * 获取一个文件的扩展名, 例如 c:\\1.gif 得到 gif
	 * @param {String} filepath 文件绝对路径
	 * @returns {String} 文件扩展名
	 */
	ext:function(path){
		var fullname=this.filefullname(path);
		if(fullname.lastIndexOf(".")==-1){
			return "";
		}else{
			return fullname.substring(fullname.lastIndexOf(".")+1,fullname.length);
		}
	},
	/**
	 * 获取一个文件的文件名,例如 c:\\abc.gif 得到 abc
	 * @param {String} filepath 文件绝对路径
	 * @returns {String} 文件名称,不包括文件后缀
	 */
	filename:function(path){
		var fullname=this.filefullname(path);
		if(fullname.lastIndexOf(".")==-1){
			return fullname;
		}else{
			return fullname.substring(0,fullname.lastIndexOf("."));
		}
	},
	/**
	 * @deprecated
	 * @see File.parentpath
	 */
	path:function(path){
		return path.substring(0,path.lastIndexOf("\\")+1);
	},
	/**
	 * 获取文件的文件名，包括文件后缀
	 * @param {String} filepath 文件绝对路径
	 * @returns {String} 文件名称，包括文件后缀
	 */
	filefullname:function(path){
		return path.substring(path.lastIndexOf("\\")+1,path.length);
	},
	/**
	 * 获取当前路径的父路径
	 * @param {String} filepath 文件绝对路径
	 * @returns {String} 父目录路径
	 */
	parentpath:function(path){
		try{
			var FSO=Win.obj(Win.com.FSO);
			var dir=FSO.GetParentFolderName(path);
			FSO=null;
			return dir;
		}catch(e){
			return false;
		}
	}
};
/**
 * 目录操作
 * @namespace 目录操作
 */
var Dir={
	/**
	 * 添加一个目录
	 * @param {String} dir 目录路径
	 * @returns {Boolean} 是否添加成功
	 */
	add:function(dir){
		try{
			var FSO=Win.obj(Win.com.FSO);
			FSO.CreateFolder(dir);
			FSO=null;
			return true;
		}catch(e){
			return false;
		}
	},
	/**
	 * 读取目录中的子目录或文件
	 * @param {String} dir 待读取的目录路径
	 * @param {Boolean} sub 读取文件还是目录，默认读取目录中文件，当值为true时，读取子目录
	 * @returns {Boolean|TYPEDEF_ENUM} 读取失败返回false, 否则返回所有子文件或目录的集合
	 */
	read:function(dir,sub){
		try{
			var FSO=Win.obj(Win.com.FSO);
			var f=FSO.GetFolder(dir);
			FSO=null;
			if(!sub){
				return f.Files;
			}else{
				return f.SubFolders;
			}
		}catch(e){
			return false;
		}
	},
	/**
	 * 删除目录
	 * @param {String} dir 目录路径
	 * @param {Boolean} force 是否强制删除
	 * @returns {Boolean} 是否删除成功
	 */
	del:function(dir,force){
		try{
			var FSO=Win.obj(Win.com.FSO);
			FSO.DeleteFolder(dir,force);
			FSO=null;
			return true;
		}catch(e){
			alert(e.description);
			return false;
		}
	},
	/**
	 * 复制一个目录到另外一个目录
	 * @param {String} from 被复制的目录路径,路径以\结尾
	 * @param {String} to 新的目录路径
	 * @param {Boolean} overwrite 如果新目录路径存在，是否强行覆盖
	 * @returns 是否复制成功
	 */
	 /*2011-11-8 此处 var path有bug*/
	copyAll:function(from,to,overwrite){
		try{
			File.copy(from+"*",to,overwrite);
			this.copy(from+"*",to,overwrite);
			/*var FSO=Win.obj(Win.com.FSO);
			var f=FSO.GetFolder(from);;
			var fc=new Enumerator(f.SubFolders);
			for (; !fc.atEnd(); fc.moveNext()){
				  var path=fc.item().Path;
				  if(path.substring(path.length-1,path.length)!="\\"){
					path+="\\";
				  }
				  var dirname=File.filename(File.parentpath(path+"loveyou.txt"));
				  alert(path+":"+to+dirname+"\\");
				  this.copyAll(path,to+dirname+"\\");
			}
			fc=null;
			f=null;
			FSO=null;*/
			return true;
		}catch(e){
			return false;
		}
	},
	/**
	 * 目录复制操作，仅复制目录，不复制目录中的文件
	 * @param {String} from	被复制目录路径
	 * @param {String} to 新的目录路径
	 * @param {Boolean} overwrite 如果新目录路径存在，是否强行覆盖
	 * @returns {Boolean} 是否复制成功
	 */
	copy:function(from,to,overwrite){
		try{
			var FSO=Win.obj(Win.com.FSO);
			FSO.CopyFolder(from,to,overwrite);
			FSO=null;
			return true;
		}catch(e){
			return false;
		}
	},
	/**
	 * 判断一个目录是否存在
	 * @param {String} path 目录路径
	 * @returns {Boolean} 目录是否存在
	 */
	exists:function(file){
		try{
			var FSO=Win.obj(Win.com.FSO);
			var fe=FSO.FolderExists(file);
			FSO=null;
			return fe;
		}catch(e){
			return false;
		}
	},
	/**
	 * 获取系统特殊目录
	 * @param {String} dirname 目录的名称,值可以是 AllUsersDesktop AllUsersStartMenu AllUsersPrograms AllUsersStartup Desktop Favorites Fonts MyDocuments NetHood PrintHood Programs Recent SendTo StartMenu	Startup Templates中的任意一个
	 * @returns
	 */
	get:function(rs){
		var wsh=Win.obj(Win.com.WSH);
		var fold=wsh.SpecialFolders(rs);
		wsh=null;
		return fold;
	}
};
/**
 * 流数据操作
 * @namespace 流数据
 */
var Stream={
	/**
	 * @ignore
	 */
	streamarray:{},
	/**
	 * 打开一个流数据
	 * @param {String} charset 字符集，如gb2312,utf-8,gbk
	 * @param {Number} type 流数据类型 1 或者 2
	 * @returns {TYPEDEF_STREAMHANDLE}流数据句柄
	 */
	open:function(charset,type,mode){
		var obj=Win.obj(Win.com.STM);
		var id=$R(16);
		obj.Mode=mode||3;
		obj.Type=type||2;
		obj.open();
		obj.Charset=charset||"utf-8";
		this.streamarray[id]=obj;
		return id;
	},
	/**
	 * 写入流数据
	 * @param {TYPEDEF_STREAMHANDLE} HANDLE 流数据句柄
	 * @param {TYPEDEF_STREAM|String} content 数据内容,对于普通文本来说，此处为字符串
	 * @param {Number|String} type 流数据类型 1|2|binary|bin|b|text|txt|t
	 * @returns
	 */
	write:function(HANDLE,content,type){
		var obj=this.streamarray[HANDLE];
		var pos=obj.Position;
		if(obj){
			obj.Position=0;
			switch(type){
				case "1":
				case "binary":
				case "bin":
				case "b":
					obj.Type=1;
					obj.Position=pos;
					obj.Write(content);
					break;
				case "2":
				case "text":
				case "txt":
				case "t":
				default:
					obj.Type=2;
					obj.Position=pos;
					obj.WriteText(content);
			}
			return true;
		}
		return false;
	},
	/**
	 * 获取某个句柄对应的COM对象
	 * @param {TYPEDEF_STREAMHANDLE} HANDLE 流数据句柄
	 * @returns {TYPEDEF_COMOBJECT} 返回的COM对象
	 */
	obj:function(HANDLE){
		return this.streamarray[HANDLE];
	},
	/**
	 * 获取流数据的大小
	 * @param {TYPEDEF_STREAMHANDLE} HANDLE 流数据句柄
	 * @returns {Number} 数据大小
	 */
	size:function(HANDLE){
		var obj=this.streamarray[HANDLE];
		if(obj){
			return obj.size;
		}else{
			return 0;
		}
	},
	/**
	 * 保存流数据到文件
	 * @param {TYPEDEF_STREAMHANDLE} HANDLE 流数据句柄
	 * @param {String} filepath 文件路径
	 * @returns {Boolean} 是否保存成功
	 */
	save:function(HANDLE,filepath){
		var obj=this.streamarray[HANDLE];
		if(obj){
			obj.saveToFile(filepath,2);
			return true;
		}else{
			return false;
		}
	},
	/**
	 * 关闭流数据
	 * @param {TYPEDEF_STREAMHANDLE} HANDLE 流数据句柄
	 * @returns
	 */
	close:function(HANDLE){
		var obj=this.streamarray[HANDLE];
		if(obj){
			obj.close();
			obj=null;
			this.streamarray[HANDLE]=null;
		}
	},
	/**
	 * 将流数据写入到文件
	 * @param {String} filepath 文件路径
	 * @param {TYPEDEF_STREAM|String} stream 数据流
	 * @returns
	 */
	saveImage:function(filepath,stream){
		var obj=Win.obj(Win.com.STM);
		obj.Type=1;
		obj.open();
		obj.write(stream);
		obj.saveToFile(filepath,2);
		obj.close();
		obj=null;
	},
	/**
	 * 从文件中读取数据
	 * @param {String} filepath 文件路径
	 * @returns {TYPEDEF_STREAM|String} 文件数据内容
	 */
	load:function(filepath){
		var obj=Win.obj(Win.com.STM);
		obj.Type=1;
		obj.open();
		obj.loadFromFile(filepath);
		var rs=obj.read();
		obj.close();
		obj=null;
		return rs;
	},
	/**
	 * 读取文本数据流并对数据编码进行转换
	 * @param {TYPEDEF_STREAM|String} stream 数据流
	 * @param {String} charset 编码
	 * @returns
	 */
	text:function(stream,charset){
		try{
			charset=(charset||"utf-8").toLowerCase();
			var obj=Win.obj(Win.com.STM);
			obj.Mode=3;obj.Type=2;
			obj.open();
			obj.writeText(stream);
			obj.position=0;
			obj.Charset=charset;
			obj.position=2;
			var rval=obj.readText();
			obj.close();
			obj=null;
			return rval;
		}catch(e){
			return "";
		}
	}
};

/**
 * 系统常规操作
 * @namespace 系统
 */
var Sys={
	/**
	 * 命令行
	 * @namespace 命令行操作
	 */
	CMD:{
		/**
		 * @ignore
		 */
		obj:null,
		/**
		 * 初始化命令行
		 * @returns
		 */
		init:function(){
			try{
				this.obj=Win.obj(Win.com.WSH);
			}catch(e){
				alert("Create WScript.shell Object Error");
			}
		},
		/**
		 * 初始化命令行,同init
		 * @returns
		 */
		open:function(){
			this.init();
		},
		/**
		 * @ignore
		 */
		TMP:{
			cmdtmp:"lib\\cmd.tmp"
		},
		/**
		 * 命令行运行命令
		 * @param path 命令
		 * @param rs	是否返回命令执行的内容
		 * @param wait	是否等待命令返回
		 * @param winstyle 命令行窗口样式,默认为0(隐藏)
		 * @param rawpath 命令中是否通过cmd来执行命令
		 * @returns {String} 当rs为true时，返回命令执行的内容
		 */
		run:function(path,rs,wait,winstyle,rawpath){
			if(this.obj){
				if(rs){
					var cmd=(rawpath?"":"cmd /c ")+path+" > \""+external.path+this.TMP.cmdtmp+"\"";
					this.obj.run(cmd,winstyle||0,true);
					var tmp=File.open(this.TMP.cmdtmp);
					var rs=File.read(tmp);
					File.close(tmp);
					return rs;
				}else{
					this.obj.run((rawpath?"":"cmd /c ")+path,winstyle||0,!!wait);
				}
			}
		},
		/**
		 * 执行命令并返回内容
		 * @param path 命令内容
		 * @returns {String} 命令返回内容
		 */
		exec:function(path){
			if(this.obj){
				var oe=this.obj.exec(path);
				return oe.stdout.ReadAll()||true;
			}
		},
		/**
		 * 注册COM组件
		 * @param path COM组件路径
		 * @returns
		 */
		com:function(path){
			var rs=this.run("regsvr32 /s \""+path+"\"",false,true);
			return path;
		},
		/**
		 * 卸载COM组件
		 * @param path COM组件路径
		 * @returns
		 */
		uncom:function(path){
			var rs=this.run("regsvr32 /s /u \""+path+"\"",false,true);
			return path;
		},
		/**
		 * 关闭命令行
		 * @returns
		 */
		close:function(){
			this.obj=null;
		}
	}
};

/**
 * 网络操作
 * @namespace 网络操作
 */
var Net={
	version:["Msxml2.XMLHTTP.5.0","Msxml2.XMLHTTP.4.0","Msxml2.XMLHTTP"],
	serverVersion:["Msxml2.serverXMLHTTP.5.0","Msxml2.serverXMLHTTP.4.0"],
	curversion:-1,
	netarray:{},
	/**
	 * @ignore
	 * @returns
	 */
	create:function(){
		var myhttp=null;
		if(!this.cookie){
			myhttp=external.xmlhttpRequest();
		}else{
			myhttp=external.xmlhttpRequest(true);
		}
		if(!myhttp){
			/*当使用软件自带的XMLHTTP出错时，调用系统自带的xmlhttp*/
			var objversion=this.version;
			if(this.cookie){objversion=this.serverVersion;}
			if(this.curversion>-1){
				myhttp=Win.obj(objversion[this.curversion]);
			}else{
				for(var i=0;i<objversion.length;i++){
					try{
						 myhttp=Win.obj(objversion[i]);
						 if(myhttp){
							 this.curversion=i;
							 break;
						}
					}catch(e){}
				}
			}
		}
		var hash=$R(16);
		this.netarray[hash]=myhttp;
		return hash;
	},
	/**
	 * @ignore
	 */
	header:function(NETHANDLE,key,value){
		var hash=NETHANDLE;
		var h=this.netarray[hash];
		if(h){
			if(value||value===""||value===0){
				if(!/^Content-Length$/i.test($T(key))){
					h.setRequestHeader(key,value);
				}
			}else{
				return getResponseHeader(key);
			}
		}
	},
	/**
	 * @ignore
	 * @param NETHANDLE
	 * @param url
	 * @param async
	 * @param method
	 * @returns
	 */
	open:function(NETHANDLE,url,async,method){
		var hash=NETHANDLE;
		var h=this.netarray[hash];
		if(async!==false){async=true;}
		if(method!="POST"){method="GET";}
		if(h){
			h.open(method,url,async);
		}
	},
	/**
	 * @ignore
	 * @param NETHANDLE
	 * @param text
	 * @returns
	 */
	send:function(NETHANDLE,text){
		var hash=NETHANDLE;
		var h=this.netarray[hash];
		if(h){
			//try{
			h.send(text||null);
			//}catch(e){alert();}
		}
	},
	/**
	 * @ignore
	 * @param dobj
	 * @returns
	 */
	data:function(dobj){
		var rs=[];
		var codetype=dobj["$codetype$"]||"";
		delete dobj["$codetype$"];
		for(var i in dobj){
			switch(codetype){
				case "escape":
					rs.push(i+"="+escape(dobj[i]));break;
				case "encode":
					rs.push(i+"="+encodeURI(dobj[i]));break;
				default:
					rs.push(i+"="+dobj[i]);break;
			}
		}
		return rs.join("&");
	},
	/**
	*@ignore
	*/
	handle:function(NETHANDLE,callback,type,async,failfunc,streamHandle,localurl){
		var that=this;
		var hash=NETHANDLE;
		var h=this.netarray[hash];
		var cstatus=h.status;
		var databack=false;
		if(cstatus==200||(localurl&&cstatus===0)){
			databack=true;
		}
		function getReturnData (type){
			var tmp=null;
			switch(type){
				case "xml":
					tmp=h.responseXML;break;
				case "stream":
					tmp=h.responseBody;break;
				case "json":
					tmp=(h.responseText?eval("("+h.responseText+")"):{});break;
				case "json_array":
					tmp=(h.responseText?eval("("+h.responseText+")"):[]);break;
				case "header":
				case "headers":
					tmp=h.getAllResponseHeaders();break;
				default:
					if(type.substring(0,7)=="header:"&&type.length>7){
						type=type.replace(/^header\:/,"");
						tmp=h.getResponseHeader(type);
					}else if(type.substring(0,8)=="charset:"&&type.length>8){
						type=type.replace(/^charset\:/,"");
						tmp=Stream.text(h.responseBody,type);
					}else if(type.substring(0,5)=="json:"&&type.length>5){
						type=type.replace(/^json\:/,"");
						tmp=eval("("+Stream.text(h.responseBody,type)+")");
					}else{
						tmp=h.responseText;
					}
					break;
			}
			return tmp;
		}
		if(databack){
			if(Net.cookie){
				Net.addCookie(h.getAllResponseHeaders());
			}
			if(callback){
				var rsdata=[];
				var types=type.split(",");
				for(var i=0;i<types.length;i++){
					rsdata.push(getReturnData(types[i]));
				}
				that.close(NETHANDLE);
				if(streamHandle){
					Stream.close(streamHandle);
				}
				Net.close(NETHANDLE);/*记得关闭连接,再callback，防止请求累计*/
				if(types.length>1){
					callback(rsdata);
				}else{
					callback(rsdata[0]);
				}
			}
		}else{
			var rsdata=[];
			var types=type.split(",");
			for(var i=0;i<types.length;i++){
				rsdata.push(getReturnData(types[i]));
			}
			Net.close(NETHANDLE);/*记得关闭连接,再callback，防止请求累计*/
			if(failfunc){failfunc(h.status,h.getAllResponseHeaders(),types.length>1?rsdata:rsdata[0]);}
		}
	},
	/**
	 * @ignore
	 * @param NETHANDLE
	 * @param callback
	 * @param type
	 * @param async
	 * @param failfunc
	 * @param streamHandle
	 * @returns
	 */
	change:function(NETHANDLE,callback,type,async,failfunc,streamHandle,localurl){
		var hash=NETHANDLE;
		var h=this.netarray[hash];
		if(async!==false){async=true;}
		if(!type){type="text";}
		if(h){
			if(async){
				/**
				 * @ignore
				 */
				h.onreadystatechange=function(){
					if(h.readyState==4){
						Net.handle(NETHANDLE,callback,type,async,failfunc,streamHandle,localurl);
					}
				};
			}
		}
	},
	/**
	 * 向服务器发送数据
	 * @param {String} url 发送地址,http://或https://开头的网络地址
	 * @param {TYPEDEF_JSONOBJECT} data 被发送的数据
	 * @param {Function} callback 回调函数,函数第一个参数为请求返回内容
	 * @param {String} [type="text"] 返回数据类型,可以是"text","json","xml","charset:字符集类型","json_array","headers","header:某一数据头","stream"
	 * @param {String} [refer=""] 请求来源地址
	 * @param {Boolean} [async=true] 请求是否异步
	 * @param {TYPEDEF_JSONOBJECT} [headers=null] 请求数据头
	 * @param {Function} [failfunc=null] 请求失败回调函数
	 * @param {Object} [failfunc=null] 请求超时对象，包括timeout与callback属性
	 * @returns
	 * @example
	 * Net.post
	 */
	post:function(url,data,callback,type,refer,async,headers,failfunc,timeout){
		/*Trahf*/
		var NETHANDLE=this.create();
		this.request(NETHANDLE,url,data,callback,type,refer,async,"POST",headers,failfunc,timeout);
	},
	/**
	 * 从服务器获取数据
	 * @param {String} url 发送地址,http://或https://开头的网络地址
	 * @param {Function} callback 回调函数,函数第一个参数为请求返回内容
	 * @param {String} [type="text"] 返回数据类型,可以是"text","json","xml","charset:字符集类型","json_array","headers","header:某一数据头","stream"
	 * @param {String} [refer=""] 请求来源地址
	 * @param {Boolean} [async=true] 请求是否异步
	 * @param {TYPEDEF_JSONOBJECT} [headers=null] 请求数据头
	 * @param {Function} [failfunc=null] 请求失败回调函数
	 * @returns
	 * @example
	 * Net.get
	 */
	get:function(url,callback,type,refer,async,headers,failfunc,timeout){
		var NETHANDLE=this.create();
		this.request(NETHANDLE,url,{},callback,type,refer,async,"GET",headers,failfunc,timeout);
	},
	local:function(url,callback,type,refer,async,headers,failfunc,timeout){
		if(url.substring(0,8)!="file:///"){
			url="file:///"+url;
		}
		var NETHANDLE=this.create();
		this.request(NETHANDLE,url,{},callback,type,"",async,"GET",headers,failfunc,timeout);
	},
	uploadFileContentType:{
		"rar":"application/octet-stream",
		"gif":"image/gif",
		"jpg":"image/jpeg",
		"png":"image/png"
	},
	/**
	 * 向服务器上传数据
	 * @param {String} url 发送地址,http://或https://开头的网络地址
	 * @param {TYPEDEF_JSONOBJECT} UP 被上传的数据
	 * @param {TYPEDEF_JSONOBJECT} UP.file 被上传的文件
	 * @param {TYPEDEF_JSONOBJECT} UP.boundary 是否有数据分割线
	 * @param {TYPEDEF_JSONOBJECT} UP.data 与文件同时上传的其他描述字段
	 * @param {Function} callback 回调函数,函数第一个参数为请求返回内容
	 * @param {String} [type="text"] 返回数据类型,可以是"text","json","xml","charset:字符集类型","json_array","headers","header:某一数据头","stream"
	 * @param {String} [refer=""] 请求来源地址
	 * @param {Boolean} [async=true] 请求是否异步
	 * @param {TYPEDEF_JSONOBJECT} [headers=null] 请求数据头
	 * @param {Function} [failfunc=null] 请求失败回调函数
	 * @returns
	 */
	 /*bug fix, no boundary bug*/
	upload:function(url,data,callback,type,refer,async,headers,failfunc,timeout){
		if(data/*&&data.file*/){
			var charset=data.charset||"utf-8";
			var sh=Stream.open(charset);
			var file=data.file;
			var boundary=data.boundary?data.boundary.replace(/%random\((\d+)\)%/,function(a,b){
				return $R(b,"sn");
			}):$R(32); //+$R(30)
			var infos="";
			data.data=data.data||{};
			for(var i in data.data){
					if(boundary){
						infos+="--"+boundary+"\r\n";
					}
					infos+="Content-Disposition: form-data; name=\""+i+"\"\r\n\r\n";
					infos+=data.data[i]+"\r\n";
			}
			var ff=0;
			for(var i in file){
				var tmp=file[i];
				var desc="--"+boundary+"\r\n";
					/*add a fake path for hacker use*/
					desc+="Content-Disposition: form-data; name=\""+i+"\"; filename=\""+File.filefullname(tmp.fakePath||tmp.path)+"\"\r\n";
					desc+="Content-Type: "+(tmp.contenttype||tmp.contentType||tmp.CONTENTTYPE||tmp.ContentType||this.uploadFileContentType[File.ext(tmp.path).toLowerCase()]||this.uploadFileContentType["rar"])+"\r\n\r\n";
				Stream.write(sh,desc);
				Stream.write(sh,Stream.load(tmp.path),"b");
				ff++;
			}
			if(ff>0){
				Stream.write(sh,"\r\n");
			}
			Stream.write(sh,infos);
			Stream.write(sh,"--"+boundary+"--\r\n");
			if(!headers){
				headers={};
			}
			headers["Content-Type"]="multipart/form-data; boundary="+boundary;
			headers["Content-Length"]=Stream.size(sh);
			var NETHANDLE=this.create();
			this.request(NETHANDLE,url,{"_toolmao_stream":Stream.obj(sh),"_toolmao_stream_handle":sh},callback,type,refer,async,"POST",headers,failfunc,timeout);
		}
	},
	/**
	 * @ignore
	 * @param headers
	 * @returns
	 */
	addCookie:function(headers){
		var sc=this.getSetCookies(headers);
		if(sc){
			Net.cookie+=";"+sc;
		}
	},
	/**
	 * @ignore
	 */
	request:function(NETHANDLE,url,data,callback,type,refer,async,method,headers,failfunc,timeout){
		var hash=NETHANDLE;
		var h=this.netarray[hash];
		var localurl=false;
		if(url.substring(0,8)=="file:///"){
			localurl=true;
		}
		if(async!==false){async=true;}
		if(!type){type="text";}
		if(method!="POST"){method="GET";}
		if(!headers){headers={};}
		if(h){
			if(async){
				this.change(NETHANDLE,callback,type,async,failfunc,data["_toolmao_stream_handle"],localurl);
			}
			this.open(NETHANDLE,url,async,method);
			if(method=="POST"&&!headers["Content-Type"]){
				headers["Content-Type"]="application/x-www-form-urlencoded";
			}
			if(refer){
				headers["Referer"]=refer;
			}
			if(this.cookie){
				headers["Cookie"]=this.cookie;
			}
			for(var i in headers){
				this.header(NETHANDLE,i,headers[i]);
			}
			if(timeout){
				setTimeout(function(){
					Net.abort(NETHANDLE,timeout["callback"]);
				},(timeout["timeout"]||20*1000))
			}
			if(data["_toolmao_stream"]){
				data["_toolmao_stream"].position=0;
				this.send(NETHANDLE,data["_toolmao_stream"]);
			}else{
				this.send(NETHANDLE,this.data(data));
			}
			if(!async){
				Net.handle(NETHANDLE,callback,type,async,failfunc,data["_toolmao_stream_handle"],localurl);
			}
		}
	},
	/**
	 * @ignore
	 * @param data
	 * @returns
	 */
	headers:function(data){
		var lines=data.split("\r\n");
		var sets={};
		for(var i=0;i<lines.length;i++){
			var tmp=lines[i];
				tmp=$T(tmp);
			if(tmp){
				tmp=tmp.split(":");
				var key=tmp[0].toLowerCase();
				if(!sets[key]){
					sets[key]=[];
				}
				sets[key].push(tmp[1]);
			}
		}
		return sets;
	},
	/**
	 * 请求所使用的cookies
	 * @field
	 */
	cookie:"",
	/**
	 * @ignore
	 * @param data
	 * @returns
	 */
	getSetCookies:function(data){
		var dekey={"PATH":1,"EXPIRES":1,"DOMAIN":1};
		var setc=this.headers(data);
		if(setc["set-cookie"]){
			setc=setc["set-cookie"].join(";");
			var cookies=setc.split(";");
			var cookies2=[];
			for(var i=0;i<cookies.length;i++){
				var tmp=$T(cookies[i]);
				if(tmp){
					var tmp2=tmp.split("=");
					if(!dekey[tmp2[0].toUpperCase()]){
						cookies2.push(tmp);
					}
				}
			}
			cookies2=cookies2.join(";");
			return cookies2;
		}else{
			return "";
		}
	},
	/**
	*	abort
	*/
	abort:function(NETHANDLE,callback){
		var hash=NETHANDLE;
		if(this.netarray[hash]){
			try{
				this.netarray[hash].abort();
			}catch(e){}
			this.netarray[hash]=null;
			delete this.netarray[hash];
			if(callback){
				callback();
			}
		}
	},
	/**
	 * @ignore
	 * @param NETHANDLE
	 * @returns
	 */
	close:function(NETHANDLE){
		var hash=NETHANDLE;
		if(this.netarray[hash]){
			try{
				this.netarray[hash].close();
			}catch(e){}
			this.netarray[hash]=null;
			delete this.netarray[hash];
		}
	},
	parseQuery:function(str){
		var obj={};
		var arr=str.split("&");
		for(var i=0;i<arr.length;i++){
			var tmp=arr[i].split("=");
			if(tmp[0]){
				obj[tmp[0]]=tmp[1]||"";
			}
		}
		return obj;
	}
};
/**
 * 伪多线程
 * @namespace 伪多线程
 */
var Thread={
	/**
	 * 伪多线程的请求路径(需能够被成功访问的请求，如http://www.baidu.com),缺省时采用魔盒自带的HTTP服务，响应最快
	 * @field
	 */
	url:"",
	/**
	 * @ignore
	 */
	list:{},
	/**
	 * 线程增加一个任务
	 * @param {Function} func 被执行的函数
	 * @param {Function} condition 用来判断线程是否继续的条件函数
	 * @param {Function} callback 线程结束时的回调函数
	 * @returns {TYPEDEF_THREADHANDLE} 线程句柄
	 */
	add:function(func,condition,callback){
		var HANDLE=$R(8);
		Thread.list[HANDLE]={
			"function":func,
			"condition":condition,
			"callback":callback,
			"suspend":false
		};
		return HANDLE;
	},
	/**
	 * 执行线程
	 * @param {TYPEDEF_THREADHANDLE} HANDLE 线程句柄
	 * @returns
	 */
	execute:function(HANDLE){
		function tmp(){
			var th=Thread.list[HANDLE];
			if(th && !th["suspend"]){
				var func=th["function"];
				var condition=th["condition"];
				var callback=th["callback"];
				if(func && $Y(func)=="function"){
					func();
				}
				var flag=true;
				if(condition && $Y(condition)=="function"){
					flag=condition();
				}
				if(flag){
					//线程依然需要被执行
					Thread.execute(HANDLE);
				}else{
					Thread.del(HANDLE);
					if(callback && $Y(callback)=="function"){
						callback();
					}
				}
			}
		}
		Net.get(Thread.url||$THREAD_URL$+"?"+Math.random(),tmp,"","","","",tmp);
	},
	/**
	 * 挂起线程
	 * @param {TYPEDEF_THREADHANDLE} HANDLE 线程句柄
	 * @returns
	 */
	suspend:function(HANDLE){
		if(Thread.list[HANDLE]){
			Thread.list[HANDLE]["suspend"]=true;
		}
	},
	/**
	 * 删除线程
	 * @param {TYPEDEF_THREADHANDLE} HANDLE 线程句柄
	 * @returns
	 */
	del:function(HANDLE){
		if(Thread.list[HANDLE]){
			delete Thread.list[HANDLE];
		}
	}
};

/**
 * 网页元素操作
 * @namespace 网页元素操作
 */
var Dom={
	/**
	 * @ignore
	 * @param id
	 * @returns
	 */
	$:function(id){
		if($(id)){return $(id);}
		else if(document.getElementsByName(id).length>0){
			return document.getElementsByName(id);
		}
	},
	/**
	 * 网页事件
	 * @namespace 网页中的事件操作
	 */
	Event:{
		/**
		 * @ignore
		 */
		eventarray:{},
		/**
		 * 新增一个事件监听
		 * @param {String|TYPEDEF_HTMLOBJECT} object 被监听的网页元素的ID或者元素本身
		 * @param {String} eventName 事件名称
		 * @param {Function} eventFunction 当事件发生时，执行的回调函数
		 * @returns {TYPEDEF_EVENTHANDLE} 事件句柄
		 */
		add:function(a,b,c){
			var eve=b.toLowerCase().substring(0,2)=="on"?b:("on"+b);
			var obj=$$(a);
			obj.attachEvent(eve,c);
			var EVENT_HANDLE=$R(16);
			this.eventarray[EVENT_HANDLE]={
				"e":eve,
				"o":obj,
				"f":c
			};
			return EVENT_HANDLE;
		},
		/**
		 * 删除一个事件
		 * @param {TYPEDEF_EVENTHANDLE} EVENT_HANDLE 事件句柄
		 * @returns
		 */
		del:function(EVENT_HANDLE){
			var tmp=this.eventarray[EVENT_HANDLE];
			if(tmp&&tmp.o){
				tmp.o.detachEvent(tmp.e,tmp.f);
			}
			delete this.eventarray[EVENT_HANDLE];
		},
		/**
		 * 获得当前发生事件的HTML元素
		 * @returns {TYPEDEF_HTMLOBJECT}
		 */
		obj:function(){
			return event.target||event.srcElement;
		},
		/**
		 * 获取当前鼠标的位置
		 * @returns {Object} 返回{x:0,y:0,sx:0,sy:0}分别表示当前鼠标相对于网页的坐标和相对于屏幕的坐标
		 */
		point:function(){
			return {
				x:$P(event.x)+$P(document.body.scrollLeft),
				y:$P(event.y)+$P(document.body.scrollTop),
				sx:$P(event.screenX),
				sy:$P(event.screenY)
			};
		},
		/**
		 * 获取当前被按下的键值
		 * @returns {Number} 键值, ASCII码
		 */
		key:function(){
			return event.keyCode;
		},
		/**
		 * 获取当前被按下的鼠标键
		 * @returns {String} 鼠标按键, r,l,c三个值中的一个，r表示右键,l表示左键,r表示滚轮
		 */
		mouse:function(){
			var rs=["r","l","r","c"];
			return rs[event.button];
		}
	},
	/**
	 * 网页中元素的操作
	 * @namespace 网页中元素的操作
	 */
	Html:{
		/**
		 * 添加一个网页元素
		 * @param {String} id 元素ID
		 * @param {String} type	元素类型
		 * @param {String} par 元素父对象或其ID，默认时为document.body
		 * @param {String} style CSS样式
		 * @param {Boolean} pos 元素插入位置，默认为末尾插入，值为true时为前面插入
		 * @returns
		 * @example
		 * pos的值, beforeBegin, afterBegin, beforeEnd, afterEnd
		 */
		add:function(id,type,par,style,pos){
			var obj=document.createElement(type);
			obj.id=id;
			obj.style.cssText=style;
			if(!document.body) document.write("<body>");
			var pobj=$$(par)||document.body;
			if(pos){
				pobj.insertAdjacentElement(pos,obj);
			}else{
				pobj.appendChild(obj);
			}
			return obj;
		},
		/**
		 * 在某个节点前插入一个元素节点
		 * @param {String} id 元素ID
		 * @param {String} type	元素类型
		 * @param {String} par 元素父对象或其ID，默认时为document.body
		 * @param {TYPEDEF_HTMLOBJECT} node 被插入的节点
		 * @param {String} style CSS样式
		 * @returns
		 */
		insert:function(id,type,par,node,style){
			var obj=document.createElement(type);
			obj.id=id;
			obj.style.cssText=style;
			if(!document.body) document.write("<body>");
			var pobj=$$(par)||document.body;
			pobj.insertBefore(obj,$$(node));
			return obj;
		},
		/**
		 * 删除一个HTML元素
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns
		 */
		del:function(obj){
			var tobj=$$(obj);tobj.parentNode.removeChild(tobj);
		},
		/**
		 * 显示一个元素
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns
		 */
		show:function(obj){
			var tobj=$$(obj);tobj.style.display="";
		},
		/**
		 * 返回一个元素的显示/隐藏状态
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns {Boolean} 返回显示或隐藏
		 */
		display:function(obj){
			return ($$(obj).style.display)?false:true;
		},
		/**
		 * 隐藏一个元素
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns
		 */
		hidden:function(obj){
			var tobj=$$(obj);tobj.style.display="none";
		},
		/**
		 * 隐藏一个元素，同 hidden
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns
		 */
		hid:function(obj){
			this.hidden(obj);
		},
		/**
		 * 切换一个元素的显示或隐藏状态
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns
		 */
		toggle:function(obj){
			var tobj=$$(obj);tobj.style.display=(this.display(obj)?"none":"");
		},
		/**
		 * 渐变显示一个HTML元素
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Object} param 渐变参数
		 * @param {Number} param.from 起始透明度
		 * @param {Number} param.to 结束透明度
		 * @param {Number} param.step 每次所改变的透明度
		 * @param {Number} param.interval 多久改变一次透明度，单位毫秒
		 * @returns
		 */
		gradient:function(obj,param){
			var tobj=$$(obj);
			if(!param){param={};}
			var from=param["from"]===0?0:(param["from"]||this.alpha(obj)||100);
			var step=param["step"]||10;
			var to=param["to"]===0?0:(param["to"]||0);
			var interval=param["interval"]===0?0:(param["interval"]||100);
			var sign=from>to?-1:1;
			this.alpha(obj,from);
			var that=this;
			Dom.Timer.start(function(){
				var alpha=that.alpha(obj);
				that.alpha(obj,alpha+sign*step);
			},interval,function(){
				var alpha=that.alpha(obj);
				return sign<0?(alpha<=to):(alpha>=to);
			});
		},
		/**
		 * 设置或获取一个元素的css样式
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {String|Object} param 字符串形式的CSS或者Object形式的JS
		 * @returns {String} 当param参数未设置时，返回此元素的CSS样式
		 */
		css:function(obj,param){
			var tobj=$$(obj);
			if(param||param===""){
				switch((typeof param).toLowerCase()){
					case "string":
						tobj.style.cssText=param;break;
					case "object":
						for(var i in param){
							try{tobj.style[i]=param[i];}catch(e){}
						}
						break;
				}
			}else{
				return tobj.style.cssText;
			}
		},
		/**
		 * 设置或获取元素的绝对位置
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} x HTML元素到其父元素的左边的横向距离
		 * @param {Number} y HTML元素到其父元素的顶边的纵向距离
		 * @returns {Object} 当x,y均未设置时，返回此元素的位置 {x:0,y:0}
		 */
		abs:function(obj,x,y){
			var tobj=$$(obj);
			if(x||y||x===0||y===0){
				tobj.style.position="absolute";
				tobj.style.left=$P(x)+"px";
				tobj.style.top=$P(y)+"px";
			}else{
				return {
					"x":$P(tobj.style.left),
					"y":$P(tobj.style.top)
				}
			}
		},
		/**
		 * 移动一个元素
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} xdis 横向移动的距离
		 * @param {Number} ydis 纵向移动的距离
		 * @returns
		 */
		move:function(obj,xdis,ydis){
			var tobj=$$(obj);
			tobj.style.left=$P(tobj.style.left)+$P(xdis)+"px";
			tobj.style.top=$P(tobj.style.top)+$P(ydis)+"px";
		},
		/**
		 * 设置或获取一个元素的大小
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} w 设置元素的宽(px)
		 * @param {Number} h 设置元素的高(px)
		 * @returns {Object} 当w,h均未设置时，返回此元素的大小 {w:0,h:0}
		 */
		size:function(obj,w,h){
			var tobj=$$(obj);
			if(w||h||w===0||h===0){
				if(w.toString().indexOf("%")!=-1){
					tobj.style.width=w;
				}else{
					tobj.style.width=$P(w)+"px";
				}
				if(h.toString().indexOf("%")!=-1){
					tobj.style.height=h;
				}else{
					tobj.style.height=$P(h)+"px";
				}
			}else{
				return {
					"w":tobj.style.width,
					"h":tobj.style.height
				}
			}
		},
		/**
		 * 将一个元素在一组元素中至于最前
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Array} elems 存放了一组HTML元素
		 * @param {Number} zindex 设置这群HTML元素默认的z序，默认为1
		 * @returns
		 */
		front:function(obj,elems,zbase){
			var tobj=$$(obj);
			var zbase=zbase||1;
			var onum=elems.length;
			for(var i=0;i<onum;i++){
				(function(i){
					if(tobj!=elems[i]){
						if(Dom.Html.Shadow.have($$(elems[i]))){
							Dom.Html.z(Dom.Html.Shadow.obj($$(elems[i])),zbase);
						}
						Dom.Html.z($$(elems[i]),zbase+1);
						zbase=zbase+2;
					}
				})(i);
			}
			if(Dom.Html.Shadow.have(tobj)){
				Dom.Html.z(Dom.Html.Shadow.obj(tobj),zbase);
			}
			this.z(tobj,zbase+1);
		},
		/**
		 * 设置或获取一个元素的z序
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} zindex z序
		 * @returns {Number} 当z未设置时，返回此元素的z序
		 */
		z:function(obj,z){
			var tobj=$$(obj);
			if(z||z===0){
				tobj.style.zIndex=z;
			}else{
				return (tobj.style.zIndex||0);
			}
		},
		/**
		 * 将元素在z轴方向上上升
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} zindex z序
		 * @returns {Number} 返回此元素的z序
		 */
		up:function(obj,z){
			var tobj=$$(obj);
			tobj.style.zIndex+=z;
			return tobj.style.zIndex;
		},
		/**
		 * 将元素在z轴方向上下降
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} zindex z序
		 * @returns {Number} 返回此元素的z序
		 */
		down:function(obj,z){
			var tobj=$$(obj);
			tobj.style.zIndex-=z;
			return tobj.style.zIndex;
		},
		/**
		 * 改变一个HTML元素的透明度
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {Number} value 透明度的值,0 ~ 100
		 * @returns {Number} 当value未设置时，返回此元素的透明度
		 */
		alpha:function(obj,value){
			var tobj=$$(obj);
			if(value||value===0){
				if(value<0){value==0;}
				if(value>100){value=100;}
				tobj.style.filter="alpha(opacity="+value+")";
			}else{
				if(tobj.filters["alpha"]){
					return tobj.filters["alpha"].opacity;
				}else{
					return 100;
				}
			}
		},
		/**
		 * 设置或获取元素的边框属性
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {String} direction 被设置的方向, Top,Left,Bottom,Right或者All中的一个值
		 * @param {String} attr 被设置的属性, Style,Width,Color中的一个值
		 * @param {String|Number} value 所设置的值的大小
		 * @returns {Number|String} value未设置时，当attr="Width"，返回边框的宽度值，否则返回样式的字符串
		 */
		border:function(obj,direction,attr,value){
			var tobj=$$(obj);
			var dirs={"Top":1,"Left":1,"Bottom":1,"Right":1,"All":1}
			var vals={"Style":1,"Width":1,"Color":1};
			direction=direction||"";
			attr=attr||"Style";
			attr=attr.substring(0,1).uc()+attr.substring(1,attr.length).lc();
			if(direction=="all"){direction=""};
			if(!vals[attr]){attr="Style";}
			if(direction!=""){
				direction=direction.substring(0,1).uc()+direction.substring(1,direction.length).lc();
				if(!dirs[direction]){direction="";}
			}
			if(value||value===0){
				if(attr=="Width"){
					value=$P(value)+"px";
				}
				tobj.style["border"+direction+attr]=value;
			}else{
				var rv=tobj.style["border"+direction+attr];
				return attr=="Width"?$P(rv):rv;
			}
		},
		/**
		 * 返回当前页面的属性
		 * @param {String} type 属性种类,为client或scroll
		 * @returns {Object} 页面的属性,type="client"时，返回 {width:...,height:...}，而type="scroll"时，则返回{width:...,height:...,top:...,left:...}
		 */
		page:function(type){
			type=type||"client";
			db=document.body;
			switch(type){
				case "client":
					return {"width":db.clientWidth,"height":db.clientHeight};
				case "scroll":
					return {"width":db.scrollWidth,"height":db.scrollHeight>db.clientHeight?db.scrollHeight:db.clientHeight,"top":db.scrollTop,"left":db.scrollLeft};
			}
		},
		/**
		 * 设置或获取HTML元素的属性
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {String} name 属性名称
		 * @param {String} value 属性值
		 * @returns {String} 当value未设置时，返回元素的属性
		 */
		attr:function(obj,name,value){
			var tobj=$$(obj);
			if(value||value===0||value===""||value===false){
				switch(name){
					case "class":
						tobj.className=value;break;
					default:
						tobj.setAttribute(name,value);
				}
			}else{
				switch(name){
					case "class":
						return tobj.className;
					default:
						if(tobj&&tobj.getAttribute){
							return tobj.getAttribute(name);
						}else{
							return "";
						}
				}
			}
		},
		/**
		 * 向一个元素中，追加内容
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {String} value 追加的内容
		 * @returns
		 */
		append:function(obj,value){
			this.value(obj,(this.value(obj)||"")+value);
		},
		/**
		 * 设置获取获取一个元素的内容
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {String} value 写入的内容
		 * @returns {String} 当value未设置时，返回元素的内容
		 */
		value:function(obj,value){
			var tobj=$$(obj);
			var tag=tobj.tagName.toLowerCase();
			switch(tag){
				case "textarea":
				case "input":
				case "button":
					if(value||value===""||value===0){
						tobj.value=value;
					}else{
						return tobj.value;
					}
					break;
				case "select":
					var sel=tobj.selectedIndex;
					if(sel!=-1){
						if(value||value===""||value===0){
							tobj.options[sel].value=value;
						}else{
							return tobj.options[sel].value;
						}
					}
					break;
				default:
					if(value||value===""||value===0){
						tobj.innerHTML=value;
					}else{
						return tobj.innerHTML;
					}
			}
		},
		/**
		 * 页面是否变灰，即不可选中状态
		 * @field
		 */
		isgray:false,
		/**
		 * 关闭页面变灰状态
		 * @returns
		 */
		bodyshow:function(){
			if($("$BOX_BODYGRAY$")){
				Dom.Html.del("$BOX_BODYGRAY$");
			}
		},
		/**
		 * 开始页面变灰状态
		 * @param {String} color 变灰的颜色，默认#cccccc
		 * @param {Number} alpha 变灰的透明度
		 * @returns {TYPEDEF_HTMLOBJECT} 灰色层的HTML元素
		 */
		bodygray:function(color,alpha){
			if($("$BOX_BODYGRAY$")){
				Dom.Html.del("$BOX_BODYGRAY$");
			}
			if(!color){color="#cccccc";}
			if(!alpha){alpha=60;}
			var g=Dom.Html.add("$BOX_BODYGRAY$","div",null,"position:absolute;top:0px;left:0px;background:"+color+";width:110%;height:100%;");
			Dom.Html.alpha(g,alpha);
			isgray=true;
			return g;
		},
		/**
		 * 阴影
		 * @namespace 阴影
		 */
		Shadow:{
			/**
			 * 给元素添加一个阴影效果
			 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
			 * @param {Object} param 阴影参数设置
			 * @param {String} param.color 阴影颜色
			 * @param {Number} param.strength 阴影强度
			 * @param {Number} param.zindex 阴影的z序
			 * @returns
			 */
			add:function(obj,param){
				var tobj=$$(obj);
				if(!param){param={};}
				var color=param["color"]||"#ccc";
				var strength=param["strength"]||20;
				var z=param["zindex"]||1;
				if(tobj.style.position=="absolute"){
					if(!tobj.id){tobj.id=$R(16);}
					if(!tobj.style.zIndex){tobj.style.zIndex=z+1;}
					var sd=Dom.Html.add(tobj.id+"_shadow","div",param["parent"],"z-index:"+z+";background:"+color+";overflow:hidden;");
					Dom.Html.size(sd,$P(tobj.style.width)+Dom.Html.border(tobj,"left","width")+Dom.Html.border(tobj,"right","width"),$P(tobj.style.height)+Dom.Html.border(tobj,"top","width")+Dom.Html.border(tobj,"bottom","width"));
					Dom.Html.abs(sd,$P(tobj.style.left)-strength,$P(tobj.style.top)-strength);
					Dom.Html.value(sd,"&nbsp;");
					sd.style.filter="progid:DXImageTransform.Microsoft.Blur(pixelradius="+strength+")";
					return sd;
				}
			},
			/**
			 * 获取阴影的ID
			 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
			 * @returns {String} 获取阴影元素的ID
			 */
			id:function(obj){
				var tobj=$$(obj);
				return tobj.id+"_shadow";
			},
			/**
			 * 获取阴影的ID
			 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
			 * @returns {TYPEDEF_HTMLOBEJCT} 获取阴影元素
			 */
			obj:function(obj){
				var tobj=$$(obj);
				if(this.have(obj)){
					return $(tobj.id+"_shadow");
				}
			},
			/**
			 * 判断元素是否带有阴影
			 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
			 * @returns {Boolean}元素是否带有阴影
			 */
			have:function(obj){
				var tobj=$$(obj);
				return tobj.id&&$(tobj.id+"_shadow");
			},
			/**
			 * 删除元素阴影效果
			 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
			 * @returns
			 */
			del:function(obj){
				var tobj=$$(obj);
				if(this.have(obj)){
					Dom.Html.del(tobj.id+"_shadow");
				}
			}
		},
		/**
		 * 让元素变得可以移动
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @param {String|TYPEDEF_HTMLOBJECT} dragitem 移动的元素中，可以被来移动的子元素的ID, 默认为全部元素均可作为控制元素
		 * @param {Array} followitem 跟随此元素一起移动的元素ID（或元素本身）组成的数组
		 * @param {Object} eventFunc 函数移动时的自定义操作
		 * @param {Function} eventFunc.mousemove 移动时执行的函数
		 * @param {Function} eventFunc.mousedown 鼠标按下时的操作
		 * @param {Function} eventFunc.mouseup 鼠标抬起时的操作
		 * @param {String} cursor 移动元素时鼠标的样式 默认为十字架
		 * @returns
		 */
		moveable:function(obj,dragitem,followitem,eventFunc,cursor){
			if(!eventFunc){eventFunc={};}
			var tobj=$$(obj);
			var mvitem=dragitem?$$(dragitem):"";
			if(!followitem){followitem=[];}
			if(this.Shadow.have(obj)){followitem.push(this.Shadow.obj(obj));}
			if(this.attr(tobj,"moveable")!="yes"){
				tobj.style.position="absolute";
				if(cursor){(mvitem||tobj).style.cursor="move";}
				this.attr(tobj,"mv","no");
				this.attr(tobj,"ox","-1");
				this.attr(tobj,"oy","-1");
				var md=Dom.Event.add(mvitem||tobj,"onmousedown",function(){
					var p=Dom.Event.point();
					var m=Dom.Event.mouse();
					if(m=="l"){
						Dom.Html.attr(tobj,"ox",p.x);
						Dom.Html.attr(tobj,"oy",p.y);
						Dom.Html.attr(tobj,"mv","yes");
						/**
						 * @ignore
						 */
						document.body.onselectstart=function(){document.selection.empty();return false;};
						var func=eventFunc["mousedown"]||eventFunc["onmousedown"];
						if(func){func(mvitem||tobj);}
					}
				});
				var mm=Dom.Event.add(document,"onmousemove",function(){
					if(Dom.Html.attr(tobj,"mv")=="yes"){
						var p=Dom.Event.point();
						var o={
							"x":$P(Dom.Html.attr(tobj,"ox")),
							"y":$P(Dom.Html.attr(tobj,"oy"))
						};
						Dom.Html.move(tobj,$P(p.x)-o.x,$P(p.y)-o.y);
						if(followitem.length>0){
							for(var i=0,l=followitem.length;i<l;i++){
								Dom.Html.move($$(followitem[i]),$P(p.x)-o.x,$P(p.y)-o.y);
							}
						}
						Dom.Html.attr(tobj,"ox",p.x);
						Dom.Html.attr(tobj,"oy",p.y);
						var func=eventFunc["mousemove"]||eventFunc["onmousemove"];
						if(func){func(mvitem||tobj,$P(p.x)-o.x,$P(p.y)-o.y);}
					}
					try{
						if(Dom.Event.obj().tagName.toLowerCase()=="img"){
							event.returnValue=false;
						}
					}catch(e){/*防止有disabled的元素*/}
				});
				var mu=Dom.Event.add(mvitem||tobj,"onmouseup",function(){
					Dom.Html.attr(tobj,"mv","no");
					/**
					 * @ignore
					 */
					document.body.onselectstart=function(){};
					var func=eventFunc["mouseup"]||eventFunc["onmouseup"];
					if(func){func(mvitem||tobj);}
				});
				this.attr(tobj,"moveable","yes");
				this.attr(tobj,"downfunc",md);
				this.attr(tobj,"movefunc",mm);
				this.attr(tobj,"upfunc",mu);
			}
		},
		/**
		 * 让元素变得不可移动
		 * @param {TYPEDEF_HTMLOBJECT} object HTML元素ID或元素本身
		 * @returns
		 */
		unmoveable:function(obj){
			var tobj=$$(obj);
			if(this.attr(tobj,"moveable")=="yes"){
				Dom.Event.del(this.attr(tobj,"downfunc"));
				Dom.Event.del(this.attr(tobj,"movefunc"));
				Dom.Event.del(this.attr(tobj,"upfunc"));
				this.attr(tobj,"moveable","no");
				var ehash=Dom.Html.attr(tobj,"ehash");
				if(ehash){
					Dom.Event.del(ehash);
				}
			}
		},
		/**
		 * @ignore
		 */
		div:function(id,w,h,x,y,p,bg,noabs){
			return this.add(id||$R(16),"div",p,"width:"+$P(w||100)+"px;height:"+$P(h||100)+"px;left:"+$P(x||0)+"px;top:"+$P(y||0)+";background:"+(bg||"url('')")+";"+(!noabs?"position:absolute;":""));
		},
		/**
		 * 快速创建一个表单元素
		 * @param {String} id 元素ID
		 * @param {String} type 表单元素类型:text,password,hidden,checkbox,radio,button,image
		 * @param {String|TYPEDEF_HTMLOBJECT} p 父级元素ID或父级元素本身
		 * @param {String} style CSS样式
		 * @param {String} value 默认值
		 * @param {String} name 表单元素的name值，缺省时与id相同
		 * @returns
		 */
		input:function(id,type,p,style,value,name){
			return this.add(id||$R(16),"<input type='"+type+"' name='"+(name||id)+"' value='"+(value||"")+"'/>",p,style);
		},
		/**
		 * 创建一个tabpage控件
		 * @param {String} id 控件ID
		 * @param {Object} param 控件参数, 使用该控件时，请使用sciTE的模板功能，极为方便
		 * @param {Function} func 保留参数
		 * @returns
		 */
		tabpage:function(id,param,func){
			if(!param){param={};}
			if(!id){id=$R(16);}
			var bordercolor=param["bordercolor"]||"#000";
			var p=$(id)||this.add(id,"div",param["parent"],"width:250px;height:250px;"+param["tab_style"]);
			Dom.Html.attr(p,"x_color1",Dom.Html.attr(p,"x_color1")||param["color1"]||"#f1f1f1");
			Dom.Html.attr(p,"x_color2",Dom.Html.attr(p,"x_color2")||param["color2"]||"#ccff00");
			Dom.Html.attr(p,"x_bordercolor",Dom.Html.attr(p,"x_bordercolor")||param["bordercolor"]||"#000");
			Dom.Html.attr(p,"x_index",Dom.Html.attr(p,"x_index")||param["index"]||"0");
			Dom.Html.attr(p,"x_headerheight",Dom.Html.attr(p,"x_headerheight")||param["headerheight"]||"20px");
			Dom.Html.attr(p,"x_headerwidth",Dom.Html.attr(p,"x_headerwidth")||param["headerwidth"]||"50px");
			Dom.Html.attr(p,"x_bodyheight",Dom.Html.attr(p,"x_bodyheight")||param["bodyheight"]||"230px");
			Dom.Html.attr(p,"innerObject",id+"_body");
			Dom.Html.attr(p,"innerObjectAttr","x_bodyheight");
			var h=$(id+"_header")||this.add(id+"_header","div",p,"clear:both;width:100%;height:20px;"+(param["head_style"]||""));
			var b=$(id+"_body")||this.add(id+"_body","div",p,"clear:both;width:100%;height:"+$P(Dom.Html.attr(p,"x_bodyheight"))+"px;border:1px solid "+bordercolor+";"+(param["body_style"]||""));
			return {
				"index":Dom.Html.attr(p,"x_index"),
				"count":0,
				"tab":p,
				"head":h,
				"body":b,
				"add":function(text,clickfunc,before){
					var color1=Dom.Html.attr(p,"x_color1")||"#f1f1f1";
					var color2=Dom.Html.attr(p,"x_color2")||"#ccff00";
					var bordercolor=Dom.Html.attr(p,"x_bordercolor")||"#000";
					var headerheight=Dom.Html.attr(p,"x_headerheight")||"20px";
					var headerwidth=Dom.Html.attr(p,"x_headerwidth")||"50px";
					var bodyheight=Dom.Html.attr(p,"x_bodyheight")||"230px";
					var index=this.count;
					var hitem=null;
					var hitem_style="float:left;text-align:center;width:"+headerwidth+";height:"+headerheight+";line-height:"+headerheight+";border:1px solid "+bordercolor+";cursor:pointer;"+(this.index==index?"background:"+color1+";":"background:"+color2+";")+(param["head_item_style"]||"");
					if(!before&&before!==0){
						hitem=$(id+"_header_"+index)||Dom.Html.add(id+"_header_"+index,"div",h,hitem_style);
					}else{
						hitem=$(id+"_header_"+index)||Dom.Html.insert(id+"_header_"+index,"div",h,$(id+"_header_"+before),hitem_style);
					}
					var bitem=$(id+"_body_"+index)||Dom.Html.add(id+"_body_"+index,"div",b,"float:left;width:100%;height:100%;background:"+color1+";"+(this.index==index?"":"display:none;")+(param["body_item_style"]||""));
					Dom.Html.value(hitem,"<span id='"+id+"_text_"+index+"'>"+(text||"")+"</span>");
					Dom.Html.attr(hitem,"parentObject",id);
					Dom.Html.attr(bitem,"parentObject",id);
					var l=$(id+"_line_"+index)||Dom.Html.add(id+"_line_"+index,"div",hitem,"position:relative;top:2px;left:0px;width:0px;overflow:hidden;border:0px solid none;height:2px;background:"+(this.index==index?color1:bordercolor)+";"+(param["line_style"]||""));
					l.style.width=($P(hitem.style.width)-2)+"px";
					Dom.Event.add(hitem,"click",function(){
						var tmpindex=Dom.Html.attr(p,"x_index")||0;
						if($(id+"_body_"+tmpindex)){
							Dom.Html.hid(id+"_body_"+tmpindex);
							$(id+"_line_"+tmpindex).style.background=Dom.Html.attr(p,"x_bordercolor")||"#000";
							$(id+"_header_"+tmpindex).style.background=Dom.Html.attr(p,"x_color2")||"#ccff00";
						}
						Dom.Html.show(bitem);
						l.style.background=Dom.Html.attr(p,"x_color1")||"#f1f1f1";
						hitem.style.background=Dom.Html.attr(p,"x_color1")||"#f1f1f1";
						Dom.Html.attr(p,"x_index",index);
						if(clickfunc){clickfunc(index);};
					});
					this.count++;
					return {
						"head":hitem,
						"text":$(id+"_text_"+index),
						"body":bitem,
						"index":index
					};
				}
			};
		},
		/**
		 * 创建一个panel控件
		 * @param {String} id 控件ID
		 * @param {Object} param 控件参数, 使用该控件时，请使用sciTE的模板功能，极为方便
		 * @param {Function} func 保留参数
		 * @returns
		 */
		panel:function(id,param,func){
			if(!param){param={};}
			if(!id){id=$R(16);}
			if(!param["panel_width"]){param["panel_width"]=100;}
			if(!param["panel_height"]){param["panel_height"]=100;}
			param["panel_style"]="width:"+param["panel_width"]+"px;height:"+param["panel_height"]+"px;"+(param["panel_style"]||";background:#fff;border:1px solid #000;top:0px;left:0px;");
			param["head_style"]="width:100%;height:22px;line-height:22px;background:#3366cc;"+param["head_style"];
			param["body_style"]="width:100%;background:#fff;"+param["body_style"];
			var p=this.add(id,"div",param["parent"],param["panel_style"]);
			var h=this.add(id+"_header","div",p,param["head_style"]);
			h.innerHTML=param["title"]||"未命名";
			param["body_style"]=param["body_style"]+";height:"+($P(p.style.height)-$P(h.style.height))+"px;";
			var b=this.add(id+"_body","div",p,param["body_style"]);
			var s="";
			var cbt="";
			var clsfunc=function(){
				if(param["closefunc"]){
					param["closefunc"]();
				}
				Dom.Html.del(p);
				if(Dom.Html.Shadow.have(p)){
					Dom.Html.del(Dom.Html.Shadow.obj(p));
				}
				var zitems=window[param["zitem"]];
				for(var i=0;i<zitems.length;i++){
					if(p.id==zitems[i]){
						window[param["zitem"]].splice(i,1);
					}
				}
				if(param["modal"]){
					Dom.Html.bodyshow();
				}
			};
			if(param["zitem"]){
				if(!window[param["zitem"]]){
					window[param["zitem"]]=[]
				}
				window[param["zitem"]].unshift(p);
			}
			if(param["closebutton"]){
				var cbstyle=param["closebutton"]["normal"]||"";
				var ccstyle="text-align:center;line-height:16px;position:absolute;top:0px;right:5px;width:30px;height:16px;cursor:pointer;";
				cbstyle=ccstyle+cbstyle;
				var cbover=param["closebutton"]["over"]||cbstyle;
				cbover=ccstyle+cbover;
				if(!p.style.left||!p.style.top){
					Dom.Html.abs(p,0,0);
				}
				var cbt=Dom.Html.add(id+"_closebutton","div",p,cbstyle);
				Dom.Event.add(cbt,"click",clsfunc);
				Dom.Event.add(cbt,"mouseover",function(){
					$(id+"_closebutton").style.cssText=cbover;
				});
				Dom.Event.add(cbt,"mouseout",function(){
					$(id+"_closebutton").style.cssText=cbstyle;
				});
				Dom.Html.value(cbt,param["closebutton"]["text"]||"X");
			}
			if(param["minbutton"]){
				if(!p.style.left||!p.style.top){
					Dom.Html.abs(p,0,0);
				}
				var cbt=Dom.Html.add(id+"_minbutton","div",p,param["minbutton"]);
				Dom.Event.add(cbt,"click",function(){
					if(param["minfunc"]){
						param["minfunc"]();
					}
				});
				Dom.Event.add(cbt,"mouseover",function(){
					$(id+"_minbutton").style.cssText=param["minbutton_over"]||param["minbutton"];
				});
				Dom.Event.add(cbt,"mouseout",function(){
					$(id+"_minbutton").style.cssText=param["minbutton"];
				});
			}
			var myfunc={};
			func=func||{};
			myfunc["mousemove"]=function(e){
				if(func["mousemove"]){
					func["mousemove"]();
				}
				if(!param["noalpha"]){
					Dom.Html.alpha(p,60);
				}
			};
			myfunc["mouseup"]=function(){
				if(!param["noalpha"]){
					Dom.Html.alpha(p,100);
				}
				if(func["mouseup"]){
					func["mouseup"]();
				}
			};
			myfunc["mousedown"]=function(e){
				if(func["mousedown"]){
					func["mousedown"]();
				}
				Dom.Html.front(p,window[param["zitem"]]||[],param["zindex"]);
			};
			if(param["moveable"]){
				if(p.style.position!="absolute"){
					Dom.Html.abs(p,0,0);
					if(param["center"]){
						var pg=Dom.Html.page("scroll");
						var cl=Dom.Html.page("client");
						Dom.Html.abs(p,$P(pg["left"])+($P(cl["width"])-$P(param["panel_width"]))/2,$P(pg["top"])+($P(cl["height"])-$P(param["panel_height"]))/2);
					}
				}
				if(param["shadow"]){
					param["shadow"]["parent"]=param["parent"];
					s=Dom.Html.Shadow.add(p,param["shadow"]);
				}
				Dom.Html.moveable(p,h,[],myfunc,true);
			}
			Dom.Html.front(p,window[param["zitem"]]||[],param["zindex"]);
			if(param["modal"]){
				Dom.Html.bodygray();
			}
			return {
				"panel":p,
				"head":h,
				"body":b,
				"shadow":s,
				"close":clsfunc
			};
		},
		/**
		 * 创建一个list控件
		 * @param {String} id 控件ID
		 * @param {Object} param 控件参数, 使用该控件时，请使用sciTE的模板功能，极为方便
		 * @returns
		 */
		list:function(id,param){
			var tid=id||$R(8);
			var s=$(tid)||Dom.Html.add(tid,"ul",Dom.Html.attr(s,"parentObject")||param["parent"],param["style"]);
			Dom.Html.attr(s,"x_itemheight",Dom.Html.attr(s,"x_itemheight")||param["itemheight"]||"22");
			Dom.Html.attr(s,"x_oddcolor",Dom.Html.attr(s,"x_oddcolor")||param["oddcolor"]||"#fff");
			Dom.Html.attr(s,"x_evencolor",Dom.Html.attr(s,"x_evencolor")||param["evencolor"]||"#fff");
			Dom.Html.attr(s,"x_overcolor",Dom.Html.attr(s,"x_overcolor")||param["overcolor"]||"#66ccff");
			Dom.Html.attr(s,"x_selectcolor",Dom.Html.attr(s,"x_selectcolor")||param["selectcolor"]||"#ff6666");
			return {
				list:s,
				itemcount:0,
				items:{},
				selectedIndex:-1,
				selectedItem:-1,
				colorconfig:null,
				onAddEvent:null,
				onDelEvent:null,
				add:function(itemtext,head){
					if(head){
						var tmp=$(tid+"_item"+this.itemcount)||Dom.Html.add(tid+"_item"+this.itemcount,"li",$(tid),(param["headstyle"]||"")+param["itemstyle"]);
					}else{
						var tmp=$(tid+"_item"+this.itemcount)||Dom.Html.add(tid+"_item"+this.itemcount,"li",$(tid),param["itemstyle"]);
					}
					tmp.style["height"]=Dom.Html.attr(this.list,"x_itemheight")+"px";
					/*tmp.style["lineHeight"]=Dom.Html.attr(this.list,"x_itemheight")+"px";*/
					Dom.Html.value(tmp,itemtext);
					this.items[this.itemcount]=tid+"_item"+this.itemcount;
					this.itemcount++;
					Dom.Html.attr(this.list,"itemcount",this.itemcount);
					if(this.onAddEvent){this.onAddEvent(this.itemcount-1,itemtext,head);}
				},
				adds:function(arr){
					for(var i=0;i<arr.length;i++){
						this.add(arr[i]);
					}
				},
				del:function(i){
					if($(tid+"_item"+i)){
						Dom.Html.del(tid+"_item"+i);
					}
					if(this.onDelEvent){this.onDelEvent(i);}
					delete this.items[i];
					this.selectedIndex=-1;
					this.selectedItem=-1;
				},
				dels:function(arr){
					for(var i=0;i<arr.length;i++){
						this.del(arr[i]);
					}
				},
				clear:function(){
					var items=this.items;
					for(var i in items){
						Dom.Html.del(items[i]);
						delete items[i];
					}
					this.itemcount=0;
				},
				recolor:function(param,datagrid,cols){
					this.color(param,datagrid,cols,true);
				},
				color:function(param,datagrid,cols,redraw){
					if(!param){param={};}
					if(!this.colorconfig){
						this.colorconfig=param;
					}else{
						param=this.colorconfig;
					}
					var that=this;
					var ct=0;
					var precol=tid.replace(/\d+$/,"");
					param["odd"]=Dom.Html.attr(this.list,"x_oddcolor");
					param["even"]=Dom.Html.attr(this.list,"x_evencolor");
					param["over"]=Dom.Html.attr(this.list,"x_overcolor");
					param["select"]=Dom.Html.attr(this.list,"x_selectcolor");
					if(param["odd"]||param["even"]){
						if(!param["odd"]){param["odd"]=param["color"];}
						if(!param["even"]){param["even"]=param["color"];}
						if(!param["over"]){param["over"]=param["color"];}
						if(!param["select"]){param["select"]=param["color"];}
						var items=this.items;
						for(var i in items){
							(function(i){
								if(ct%2){
									$(items[i]).style.background=param["odd"];
								}else{
									$(items[i]).style.background=param["even"];
								}
								if(!redraw){
									var clickfunc=function(){
										if(that.selectedItem!=-1){
											if($(that.selectedItem)){

												var itemIndex=parseInt(that.selectedItem.replace(new RegExp(tid+"_item"),""));
												if(datagrid){
													for(var m=0;m<datagrid;m++){
														if(itemIndex%2){
															$(precol+m+"_item"+itemIndex).style.background=Dom.Html.attr(that.list,"x_oddcolor");
														}else{
															$(precol+m+"_item"+itemIndex).style.background=Dom.Html.attr(that.list,"x_evencolor");
														}
													}
												}else{
													if(itemIndex%2){
														$(that.selectedItem).style.background=Dom.Html.attr(that.list,"x_oddcolor");
													}else{
														$(that.selectedItem).style.background=Dom.Html.attr(that.list,"x_evencolor");
													}
												}
											}
										}
										if(!datagrid){
											$(items[i]).style.background=Dom.Html.attr(that.list,"x_selectcolor");
											that.selectedItem=items[i];
											that.selectedIndex=i;
											Dom.Html.attr(that.list,"selectedIndex",i);
										}else{
											var itemIndex=parseInt(items[i].replace(new RegExp(tid+"_item"),""));
											for(var m=0;m<datagrid;m++){
												$(precol+m+"_item"+itemIndex).style.background=Dom.Html.attr(that.list,"x_selectcolor");
												cols[m].selectedItem=precol+m+"_item"+itemIndex;
											}
										}
										if(param["itemclick"]){
											param["itemclick"]($(items[i]),i);
										}
									};
									Dom.Event.add($(items[i]),"mousedown",clickfunc);
									//Dom.Event.add($(items[i]),"click",clickfunc);
									Dom.Event.add($(items[i]),"mouseover",function(){
										if(that.selectedItem!=items[i]){
											if(!datagrid){
												$(items[i]).style.background=Dom.Html.attr(that.list,"x_overcolor");
											}else{
												var itemIndex=parseInt(items[i].replace(new RegExp(tid+"_item"),""));
												for(var m=0;m<datagrid;m++){
													$(precol+m+"_item"+itemIndex).style.background=Dom.Html.attr(that.list,"x_overcolor");
												}
											}
										}
										if(param["itemover"]){
											param["itemover"]($(items[i]));
										}
									});
									Dom.Event.add($(items[i]),"mouseout",function(){
										if(that.selectedItem!=items[i]){
											var itemIndex=parseInt(items[i].replace(new RegExp(tid+"_item"),""));
											if(!datagrid){
												if(itemIndex%2){
													$(items[i]).style.background=Dom.Html.attr(that.list,"x_oddcolor");
												}else{
													$(items[i]).style.background=Dom.Html.attr(that.list,"x_evencolor");
												}
											}else{
												for(var m=0;m<datagrid;m++){

													if(itemIndex%2){
														$(precol+m+"_item"+itemIndex).style.background=Dom.Html.attr(that.list,"x_oddcolor");
													}else{
														$(precol+m+"_item"+itemIndex).style.background=Dom.Html.attr(that.list,"x_evencolor");
													}
												}
											}
										}
										if(param["itemout"]){
											param["itemout"]($(items[i]));
										}
									});
								}
							})(i);
							ct++;
						}
					}

				}
			};
		},
		/**
		 * 创建一个tree控件
		 * @param {String} id 控件ID
		 * @param {Object} param 控件参数, 使用该控件时，请使用sciTE的模板功能，极为方便保留参数
		 * @returns
		 */
		tree:function(id,param){
			var data=param["data"]||[{id:"_treeroot",name:"root",subnodes:[]}];
			var tid=id||$R(8);
			var tr=$(tid)||Dom.Html.add(tid,"div",param["parent"],"overflow:auto;"+param["style"]);
			var indent=$P(param["indent"]||10);
			var itemWidth=$P(param["itemWidth"]||100);
			var itemHeight=$P(param["itemHeight"]||20);
			var itemClick=param["click"]||null;
			var iconFold=param["iconFold"];
			var iconUnFold=param["iconUnFold"];
			var iconNormal=param["iconNormal"];
			function addNode(arr,parent,level){
				for(var i=0;i<arr.length;i++){
					(function(i){
						var node=arr[i];
						var cindent=indent*(level+1);
						var icontag=tid+"_"+node.id+"_icon";
						var pnode=Dom.Html.add(tid+"_"+node.id,"div",parent,"width:"+itemWidth+"px;height:"+itemHeight+"px;margin-left:"+indent*level+"px;");
						pnode.innerHTML="<div id='"+icontag+"' style='border:1px solid #000;overflow:hidden;text-align:center;font-size:16px;line-height:16px;cursor:default;float:left;width:16px;height:16px;'>-</div>"+node.name;
						var snode=Dom.Html.add(tid+"_"+node.id+"_subnode","div",parent,"cursor:pointer;border-left:1px dotted #000;margin-left:"+cindent+"px;");
						Dom.Html.attr(snode,"listIcon",icontag);
						Dom.Html.attr(snode,"hasChild","yes");
						Dom.Html.attr(snode,"level",level);
						if(/_subnode$/.test($$(parent).id)){
							Dom.Html.show(parent);
							Dom.Html.attr(parent,"hasChild","yes");
							$$(Dom.Html.attr(parent,"listIcon")).innerHTML="-";
						}
						if(node.subnodes&&node.subnodes.length>0){
							addNode(node.subnodes,snode,level+1);
						}else{
							$$(Dom.Html.attr(snode,"listIcon")).innerHTML="目";
							Dom.Html.attr(snode,"hasChild","no");
							Dom.Html.hid(snode);
						}
						var clickfunc=function(){
							if(Dom.Html.attr(snode,"hasChild")=="yes"){
								Dom.Html.toggle(snode);
								$$(Dom.Html.attr(snode,"listIcon")).innerHTML=($$(Dom.Html.attr(snode,"listIcon")).innerHTML=="+")?"-":"+";
								document.selection.empty();
							}
						}
						Dom.Event.add(pnode,"dblclick",clickfunc);
						Dom.Event.add(pnode,"click",function(){
							if(Dom.Html.attr(tr,"selectedNode")){
								$$(Dom.Html.attr(tr,"selectedNode")).style.border="0px none #ccc";
							}
							Dom.Html.attr(tr,"selectedNode",pnode.id);
							pnode.style.border="1px dotted #ccc";
							if(itemClick&&$Y(itemClick)=="function"){
								itemClick(pnode);
							}
						});
						Dom.Event.add(icontag,"click",clickfunc);
					})(i);
				}
			}
			addNode(data,tr,0);
			return {
				"addNode":addNode,
				"getNodeById":function(id){
					return {
						"node":$(tid+"_"+id),
						"subnodes":$(tid+"_"+id+"_subnode"),
						"level":Dom.Html.attr(tid+"_"+id+"_subnode","level"),
						"addNode":function(data){
							addNode(data,this.subnodes,this.level);
						},
						"del":function(){
							try{
								Dom.Html.del(this.node);
								Dom.Html.del(this.subnodes);
								Dom.Html.attr(tr,"selectedNode","")
							}catch(e){}
						},
						"show":function(){
							this.node.click();
						}
					}
				}
			};
		},
		/**
		 * 创建一个datagrid控件
		 * @param {String} id 控件ID
		 * @param {Object} param 控件参数, 使用该控件时，请使用sciTE的模板功能，极为方便保留参数
		 * @returns
		 */
		datagrid:function(id,param,columns){
			var tid=id||$R(8);
			var grid=$(tid)||Dom.Html.add(tid,"div",param["parent"],param["style"]);
			Dom.Html.attr(grid,"x_bordercolor",Dom.Html.attr(grid,"x_bordercolor")||"#ccc");
			Dom.Html.attr(grid,"x_borderstyle",Dom.Html.attr(grid,"x_borderstyle")||param["borderstyle"]||"1px solid #000");
			var bdcolor=Dom.Html.attr(grid,"x_bordercolor");
			var bdstyle=Dom.Html.attr(grid,"x_borderstyle");
			var hc=$(tid+"_head")||Dom.Html.add(tid+"_head","div",grid,"clear:both");
			//hc.style.border="1px solid #000";
			//hc.style.borderColor=Dom.Html.attr(grid,"x_bordercolor");
			//hc.style.borderBottomStyle="none";
			if(!param["hasHead"]){
				hc.style.display="none";
			}
			var s=$(tid+"_body")||Dom.Html.add(tid+"_body","div",grid,"clear:both;"+param["bodystyle"]);
			Dom.Html.attr(grid,"x_headheight","28");
			Dom.Html.attr(grid,"x_bodyheight","150");
			Dom.Html.attr(grid,"innerObject",id+"_body");
			Dom.Html.attr(grid,"innerObjectAttr","x_bodyheight");
			var cols=[];
			for(var i=0;i<columns.length;i++){
				(function(i){
					if(!columns[i]["itemstyle"]){
						columns[i]["itemstyle"]=param["itemstyle"]+"list-style-position:outside;";
					}
					columns[i]["parent"]=tid+"_body";
					columns[i]["style"]="list-style:none;margin:0px;padding:0px;float:left;width:"+columns[i]["width"]+";"+(i==0?("border-left:"+bdstyle+";"):"")+"border-top:"+bdstyle+";border-right:"+bdstyle+";border-bottom:"+bdstyle+";"+param["columnstyle"];
					var ll=Dom.Html.list(tid+"_column"+i,columns[i]);
					cols.push(ll);
					var hd=Dom.Html.list(tid+"_columnhead"+i,{
						"parent":tid+"_head",
						"style":columns[i]["style"],
						"headstyle":param["headstyle"],
						"itemstyle":columns[i]["itemstyle"]
					});
					hd.add(columns[i]["text"],true);
				})(i);
			}
			return {
				grid:grid,
				head:hc,
				body:s,
				data:[],
				addRow:function(contents,head){
					this.data.push(contents);
					for(var i=0;i<cols.length;i++){
						if(cols[i]){
							var tmpcontent=contents[i].toString().replace(/\[%=itemindex%\]/g,this.data.length-1);
							cols[i].add(tmpcontent,head);
						}
					}
				},
				delRow:function(index){
					for(var i=0;i<cols.length;i++){
						if(cols[i]){
							cols[i].del(index);
						}
					}
					this.data.splice(index,1);
					this.reDraw();
				},
				color:function(cparam){
					for(var i=0;i<cols.length;i++){
						cols[i].color(cparam,cols.length,cols);
					}
				},
				clear:function(){
					for(var i=0;i<cols.length;i++){
						if(cols[i]){
							cols[i].clear();
						}
					}
					this.data=[];
				},
				reDraw:function(){
					var arr=this.data.splice(0,this.data.length);
					this.clear();
					for(var i=0;i<arr.length;i++){
						this.addRow(arr[i]);
					}
					this.recolor();
				}
			};
		}
	},
	/**
	 * 网页定时器
	 * @namespace 网页定时器
	 */
	Timer:{
		/**
		 * @ignore
		 */
		timerarray:{},
		/**
		 * 创建一个定时器
		 * @param {Function} func 被定时执行的函数
		 * @param {Number} interval 执行间隔，单位毫秒
		 * @param {Function} condition 执行停止的条件判断函数
		 * @param {Number} maxcount 被执行的最大次数，默认不限制
		 * @returns {TYPEDEF_TIMEHANDLE} 定时器句柄
		 */
		start:function(func,interval,condition,maxcount){
			pthis=this;
			var TIMEHANDLE=$R(16);
			this.timerarray[TIMEHANDLE]={
				"count":0,
				"maxcount":maxcount||Infinity,
				"timer":setInterval(function(){
					var $self=pthis.timerarray[TIMEHANDLE];
					if($self){
						if($self.count>$self.maxcount||(condition&&condition())){
							pthis.stop(TIMEHANDLE);
						}else{
							func();
							$self.count++;
						}
					}
				},interval||1000)
			};
			return TIMEHANDLE;
		},
		/**
		 * 停止定时操作
		 * @param {TYPEDEF_TIMEHANDLE} TIMEHANDLE 定时器句柄
		 * @returns
		 */
		stop:function(TIMEHANDLE){
			if(this.timerarray[TIMEHANDLE]){
				clearInterval(this.timerarray[TIMEHANDLE].timer);
				delete this.timerarray[TIMEHANDLE];
			}
		},
		/**
		 * 打点器
		 * @namespace 打点器
		 */
		Counter:{
			/**
			 * @ignore
			 */
			timer:{},
			/**
			 * 开始倒计时
			 * @param {String} id 显示倒计时的元素ID
			 * @param {Boolean} direction 倒计时的方向,false为倒计时，true为正计时
			 * @param {Number} basic 倒计时的初始值
			 * @param {Function} endFunc 倒计时结束时的执行函数
			 * @returns {TYPEDEF_TIMEHANDLE} 定时器句柄
			 */
			start:function(id,direction,basic,endFunc){
				Dom.Html.value(id,basic||"0");
				var HD=$R(8);
				if(!direction){
					Dom.Html.value(id,basic||"60");
					this.timer[HD]=Dom.Timer.start(function(){
						Dom.Html.value(id,$P(Dom.Html.value(id))-1);
						if($P(Dom.Html.value(id))==0){
							if(endFunc){endFunc();}
						}
					},1000);
				}else{
					this.timer[HD]=Dom.Timer.start(function(){
						Dom.Html.value(id,$P(Dom.Html.value(id))+1);
					},1000);
				}
				return HD;
			},
			/**
			 * 停止倒计时
			 * @param {TYPEDEF_TIMEHANDLE} TIMEHANDLE 定时器句柄
			 * @returns
			 */
			stop:function(HD){
				var timer=this.timer[HD];
				if(timer){
					Dom.Timer.stop(timer);
					delete this.timer[HD];
				}
			}
		}
	},
	/**
	 * 网页Cookie操作
	 * @namespace 网页Cookie操作
	 */
	Cookie:{
		/**
		 * 获得指定网址的cookies
		 * @param {String} url 网页地址
		 * @returns {String} Cookies数据
		 */
		get:function(url){
			if(url.substring(0,7)!="http://" && url.substring(0,8)!="https://"){
				url="http://"+url;
			}
			return external.cookieRead(url);
		},
		/**
		 * 设置指定网址的cookies
		 * @param {String} url 网页地址
		 * @param {String} cookies Cookies数据
		 * @returns
		 */
		set:function(url,data){
			if(url.substring(0,7)!="http://" && url.substring(0,8)!="https://"){
				url="http://"+url;
			}
			var x=false;
			if(data){
				x=external.cookieWrite(url,data);
			}
			return x;
		},
		/**
		 * 加载并解析cookies数据
		 * @param {String} data cookies数据
		 * @returns {Object} cookie Object类型的cookies数据
		 * @returns {Function} read 读取cookies中指定的值, 带有一个name参数
		 * @returns {Function} write 写入cookies数据, 带有name和value两个参数
		 */
		load:function(data){
			/*load external cookies data*/
			var c=data.split(";");
			var h={};
			for(var i=0,l=c.length;i<l;i++){
				var tmp=c[i].split("=");
				h[$T(tmp[0])]=$T(tmp[1]||"");
			}
			return {
				"data":h,
				"read":function(name){
					return this.data[name]||false;
				},
				"write":function(name,value){
					this.data[name]=value||"";
				},
				"text":function(){
					var tmp=[];
					for(var i in this.data){
						tmp.push(i+"="+data[i]);
					}
					return tmp.join("; ");
				}
			};
		},
		/**
		 * 获得当前页面的文本数据
		 * @returns {String} Cookies
		 */
		text:function(){
			return document.cookie;
		},
		/**
		 * 获得当前页面的Object类型的cookies数据
		 * @returns {Object} Cookies
		 */
		hash:function(){
			var c=document.cookie.split(";");
			var h={};
			for(var i=0,l=c.length;i<l;i++){
				var tmp=c[i].split("=");
				h[$T(tmp[0])]=$T(tmp[1]||"");
			}
			return h;
		},
		/**
		 * 从当前cookies中读取指定的cookies值
		 * @param {String} key cookies键
		 * @returns
		 */
		read:function(name){
			return this.hash()[name]||false;
		},
		/**
		 * 向当前cookies中写入指定的cookies值
		 * @param {String} key cookies键
		 * @param {String} value cookies值
		 * @returns
		 */
		write:function(name,value){
			document.cookie=name+"="+value+";";
		},
		/**
		 * @ignore
		 * @param name
		 * @param value
		 * @returns
		 */
		temp:function(name,value){
			/*not be used outside*/
			if(value){
				this.write(name,value);
			}
			return this.read(name);
		},
		/**
		 * 设置或获取当前cookies的domain
		 * @param value 设置cookies的domain的值
		 * @returns 当values未设置时，返回cookies的domain的值
		 */
		domain:function(value){
			return this.temp("domain",value);
		},
		/**
		 * 设置或获取当前cookies的path
		 * @param value 设置cookies的path的值
		 * @returns 当values未设置时，返回cookies的path的值
		 */
		path:function(value){
			return this.temp("path",value);
		},
		/**
		 * 设置或获取当前cookies的过期时间
		 * @param value 设置cookies的expires的值
		 * @returns 当values未设置时，返回cookies的expires的值
		 */
		expires:function(value){
			return this.temp("expires",value);
		}
	},
	/**
	 * 网页地址请求字符串操作
	 * @namespace 网页地址请求字符串操作
	 */
	Query:{
		/**
		 * 获取当前页面地址的hash值，即地址末尾#之后的数据
		 * @param {String} key Hash的键
		 * @param {Boolean} topframe 是否获取的是顶级页面的地址,缺省为false
		 * @param {String} spliter Hash数据的分隔符
		 * @returns {String} Hash的值
		 */
		hash:function(key,topframe,spliter){
			var o=topframe?top.location:self.location;
			var hash=o.hash;
				hash=hash.replace(/^#/,"").split((spliter||"&"));
			var rs={};
			for(var i=0,l=hash.length;i<l;i++){
				var tmp=hash[i].split("=");
				rs[tmp[0]]=tmp[1];
			}
			if(rs[key]){return rs[key];}else{return false;}
		},
		/**
		 * 获取当前页面地址的请求数据，即 ? 之后的数据
		 * @param {String} key 请求数据的键
		 * @param {Boolean} topframe 是否获取的是顶级页面的地址,缺省为false
		 * @returns {String} 请求数据的值
		 */
		$:function(key,topframe){
			var o=topframe?topframe.location:self.location;
			var sh=o.search;
				sh=sh.replace(/^\?/,"").split("&");
			var rs={};
			for(var i=0,l=sh.length;i<l;i++){
				var tmp=sh[i].split("=");
				rs[tmp[0]]=tmp[1];
			}
			if(rs[key]){return rs[key];}else{return false;}
		}
	},
	/**
	 * 网页中随机数字与时间
	 * @namespace 网页随机数字与时间
	 */
	Random:{
		/**
		 * 生成时间串
		 * @param {String} type 长时间串13位，或短时间串10位,值可为 short|s|long|l中的一种
		 * @returns {String} 时间串
		 */
		time:function(type){
			type=type||"short";
			var time=new Date().getTime();
			switch(type){
				case "short":
					return Math.floor(time/1000);
				case "s":
					return Math.floor(time/1000);
				case "long":
					return time;
				case "l":
					return time;
			}
		},
		/**
		 * 返回一个随机数，同Math.random()
		 * @returns
		 */
		number:function(){
			return Math.random();
		}
	}
};
/**
 * 字符串小写的简写，同 toLowerCase()
 * @returns {String} 小写形式的字符串
 */
String.prototype.lc=function(){
	return this.toLowerCase();
};
/**
 * 字符串大写的简写，同 toUpperCase()
 * @returns {String} 大写形式的字符串
 */
String.prototype.uc=function(){
	return this.toUpperCase();
};
/**
 * 字符串转JSON, 与str2obj同
 * @returns {TYPEDEF_JSONOBJECT}
 */
String.prototype.obj=function(){
	return eval("("+this+")");
};
/**
 * 字符串匹配获取指定的内容
 * @param {RegExp} pat 正则表达式,其中第一括号中为返回数据
 * @param {Boolean} multi 是否获取多个匹配
 * @returns {String|Array} 当multi缺省或false时，返回正则中第一个括号的数据;否则，返回一个数组
 * @example
 * String.getMatch
 */
String.prototype.getMatch=function(pat,multi){
	if(!multi){
		return (this.match(pat)||["",""])[1];
	}else{
		return this.match(pat)||[];
	}
};
/**
 * 字符串重复
 * @param {Number} times 字符串重复次数
 * @returns {String} 返回重复多次后的字符串
 * @example
 * String.repeat
 */
String.prototype.repeat=function(nn){
	if(!nn&&nn!==0) nn=1;
	var str="";
	for(var i=0;i<nn;i++){
		str+=this;
	}
	return str;
};
/**
 * 产生随机字符串
 * @param {Number} length 字符串长度
 * @returns {String} length个长度的随机字符串
 * @example
 * String.random
 * @see $R
 */
String.prototype.random=function(n){
	return $R(n,this);
};
/**
 * 字符串反转
 * @returns {String} 反转之后的字符串
 * @example
 * String.reverse
 */
String.prototype.reverse=function(){
	return this.split("").reverse().join("");
};
/**
 * 裁剪字符串并显示
 * @param {Number} n 保留的字符串长度
 * @param {String} end 字符串裁剪后，末尾所添加的文字
 * @returns {String}
 * @example
 * String.show
 */
String.prototype.show=function(n,end){
	if(this.length<=n){
		return this;
	}else{
		return this.substring(0,n)+end||"";
	}
};
/**
 * 字符串填充
 * @param {Number} n 最短字符长度
 * @param {String} ch 填充的字符内容
 * @param {Boolean} pos 默认为左填充，为true时，为右填充
 * @returns {String} 填充后的字符
 * @example
 * String.fill
 */
String.prototype.fill=function(n,ch,pos){
	ch=ch||"";
	if($Y(ch)!="string"){
		ch="";
	}
	if(this.length<n){
		if(pos){
			return this+ch.repeat(n-this.length);
		}
		return ch.repeat(n-this.length)+this;
	}
	return this;
};
/**
 * 格式化显示字符串
 * @param {Number} n 分割的长度
 * @param {String} ch 分割的字符,默认为一个空格
 * @returns {String} 格式化后的字符
 * @example
 * String.format
 */
String.prototype.format=function(n,ch){
	ch=ch||" ";
	if($Y(ch)!="string"){
		ch=" ";
	}
	var str="";
	for(var i=0,l=this.length-n;i<l;i+=n){
		str+=this.substring(i,i+n)+ch;
	}
	str+=this.substring(this.length-n,this.length);
	return str;
};
/**
 * @ignore
 */
window.attachEvent("onload",function(){
	for(var i=0,l=Win.Drag.item.length;i<l;i++){
		var tmp=$(Win.Drag.item[i]);
		if(tmp){
			with(tmp){
				onmousedown=Win.Drag.mouseDown;
				onmouseup=Win.Drag.mouseUp;
				onmousemove=Win.Drag.mouseMove;
			}
		}
	}
	if($('_toolmao_box_')){
		$('_toolmao_box_').innerHTML="v "+$VERSION$;
	}
	/*默认右键菜单*/
	Win.Menu.defaultMenu();
});
