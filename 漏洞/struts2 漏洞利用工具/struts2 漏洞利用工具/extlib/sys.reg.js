/****************************
//[[Description:注册表操作]]
//[[Author: gainover]]
****************************/
//需前置定义Sys
$Q("Sys");
/**
 * 注册表
 * @namespace 注册表操作
 */
Sys.Reg={
	/*
	Key------
	   |----Value [Name-Data]
	   |----Value [Name-Data]
	   |----Key
			   |----Value [Name-Data]
			   |----Value [Name-Data]
	*/
	head:{
		"HKEY_CLASSES_ROOT":0x80000000,
		"HKEY_CURRENT_USER":0x80000001,
		"HKEY_LOCAL_MACHINE":0x80000002,
		"HKEY_USERS":0x80000003,
		"HKEY_CURRENT_CONFIG":0x80000005,
		"HKEY_DYN_DATA":0x80000006,
		"HKCR":0x80000000,
		"HKCU":0x80000001,
		"HKLM":0x80000002,
		"HKU":0x80000003
	},
	pre:{
		/*some registry used always*/
	},
	type:{
		STR:"REG_SZ", /*Regular String with end \0*/
		STR_EX:"REG_EXPAND_SZ", /*String with variable such as %WINDIR%*/
		BIN:"REG_BINARY", /*Binary data*/
		INT:"REG_DWORD" /*Integer with 4 byte(32 bit)*/
	},
	root:"",
	path:"",
	regObj:null,
	wssObj:null,
	wssReg:null,
	change:function(path,sep,root){
		if(sep){var x=new RegExp(seq,"gi");path=path.replace(x,"\\");}
		this.root=root||this.root;
		this.path=path||"";
	},
	open:function(root){
		this.root=root||this.root;
		try{
			this.regObj=Win.obj(Win.com.WSH);
			this.wssObj=Win.obj(Win.com.WSS);
			var srv=this.wssObj.ConnectServer(null,"root\\default");
			var reg=srv.Get("StdRegProv");
			this.wssReg=reg;
		}catch(e){
			alert("Create Registry Object Error:"+e.description);
		}
	},
	readDirs:function(){
		var ms=this.wssReg.Methods_.Item("EnumKey");
		var param=ms.InParameters.SpawnInstance_();
			param.hDefKey=this.head[this.root];
			param.sSubKeyName=this.path;
		var out=this.wssReg.ExecMethod_(ms.Name,param);
		try{
			return out.sNames.toArray();
		}catch(e){
			return [];
		}
	},
	readFiles:function(){
		var ms=this.wssReg.Methods_.Item("EnumValues");
		var param=ms.InParameters.SpawnInstance_();
			param.hDefKey=this.head[this.root];
			param.sSubKeyName=this.path;
		var out=this.wssReg.ExecMethod_(ms.Name,param);
		try{
			return out.sNames.toArray();
		}catch(e){
			return [];
		}
	},
	readData:function(value){
		if(this.regObj){
			var obj=this.regObj;
			return obj.RegRead(this.root+"\\"+(this.path?(this.path+"\\"):"")+value);
		}else{
			alert("you should run Reg.open function to initiate this Object");
		}
	},
	writeData:function(value,data,type,bFile){
		type=type||this.type.STR;
		if(this.regObj){
			var obj=this.regObj;
			obj.RegWrite(this.root+"\\"+(this.path?(this.path+"\\"):"")+value,data,type);
		}else{
			alert("you should run Reg.open function to initiate this Object");
		}
	},
	addFile:function(filename,data,type){
		this.writeData(filename,data,type,true);
	},
	delFile:function(value,keyflag){
		if(keyflag){
			value+="\\";
		}
		if(this.regObj){
			var obj=this.regObj;
			try{
				obj.RegDelete(this.root+"\\"+(this.path?(this.path+"\\"):"")+value);
				return true;
			}catch(e){
				//alert(e.description);
				return null;
			}
		}else{
			alert("you should run Reg.open function to initiate this Object");
		}
	},
	addDir:function(key,autoChange){
		var ms=this.wssReg.Methods_.Item("createKey");
		var param=ms.InParameters.SpawnInstance_();
			param.hDefKey=this.head[this.root];
			param.sSubKeyName=(this.path?(this.path+"\\"):"")+key;
			//alert(param.sSubKeyName);
		var out=this.wssReg.ExecMethod_(ms.Name,param);
		if(autoChange){
			this.change(param.sSubKeyName);
		}
		return out;
	},
	delDir:function(key){
		return this.delFile(key,true);
	},
	close:function(){
		this.regObj=null;
		this.wssObj=null;
		this.wssReg=null;
		this.root="";
		this.path="";
	}
};
