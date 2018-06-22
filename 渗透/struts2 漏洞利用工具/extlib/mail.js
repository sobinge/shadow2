/****************************
//[[Description:邮件发送库]]
//[[Author: gainover]]
****************************/
$D("mail");

var Mail={
	obj:null,
	param:{},
	configurl:"http://schemas.microsoft.com/cdo/configuration/",
	init:function(){
		if(!this.obj){
			this.obj=Win.obj("cdo.message");
		}
	},
	config:function(param){
		param=param||{};
		param["type"]=param["type"]||2;
		param["server"]=param["server"]||"127.0.0.1";
		param["port"]=param["port"]||25;
		param["user"]=param["user"]||"toolmao";
		param["password"]=param["password"]||"toolmao";
		param["auth"]=param["auth"]||1;
		param["timeout"]=param["timeout"]||60*1000;
		param["ssl"]=!!param["ssl"];
		var paramMap={
			"server":"smtpserver",
			"port":"smtpserverport",
			"user":"sendusername",
			"password":"sendpassword",
			"auth":"smtpauthenticate",
			"timeout":"smtpconnectiontimeout",
			"ssl":"smtpusessl",
			"type":"SendUsing"
		};
		for(var i in param){
			this.obj.configuration.fields.item(this.configurl+paramMap[i])=param[i];
		}
		this.obj.configuration.fields.update();
		this.param=param;
	},
	post:function(to,title,content,html,attachments,from){
		this.obj.from=from||this.param["user"];
		this.obj.to=to;
		this.obj.subject=title;
		content=content||"..";
		html?(this.obj.htmlbody=content):(this.obj.textbody=content);
		if(attachments&&$Y(attachments)=="array"){
			for(var i=0;i<attachments.length;i++){
				this.obj.addAttachment(attachments[i]);
			}
		}
		this.obj.send();
	},
	open:function(){
		this.init();
	},
	close:function(){
		this.obj=null;
	}
};
/*
//Mail用法举例
Mail.open();
Mail.config({
	"server":"smtp.163.com",  //设置邮件的smtp服务器
	"user":"gainover@163.com", //设置发送邮件的邮箱名字
	"password":"**********"   //设置你发送邮件的邮箱密码
});
//Mail.post用法参见后面说明
Mail.post("gainover@qq.com","测试一下的邮件哦","测试下","",[
	external.path+"main.js"
]);
alert("发送成功");
Mail.close();
*/