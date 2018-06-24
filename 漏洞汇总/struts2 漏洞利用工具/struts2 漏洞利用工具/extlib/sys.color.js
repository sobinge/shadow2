/****************************
//[[Description:颜色控件]]
//[[Author: gainover]]
****************************/
//需前置定义Sys
$Q("Sys"); 
/**
 * 颜色对象
 * @namespace 颜色
 */
Sys.Color={
	/**
	 * 常用颜色英文名称表
	 * @field
	 */
	obj:{
		"aqua":"#00FFFF",
		"black":"#000000",
		"blue":"#0000ff",
		"fuchsia":"#FF00FF",
		"gray":"#808080",
		"green":"#008000",
		"lime":"#00FF00",
		"maroon":"#800000",
		"navy":"#000080",
		"olive":"#808000",
		"purple":"#800080",
		"red":"#FF0000",
		"silver":"#C0C0C0",
		"teal":"#008080",
		"white":"#FFFFFF",
		"yellow":"#FFFF00"
	},
	/**
	 * 常用颜色对应中文值
	 * @field
	 */
	cn:{
		"aqua":"%E6%B5%85%E7%BB%BF",
		"black":"%E9%BB%91%E8%89%B2",
		"blue":"%E7%99%BD%E8%89%B2",
		"fuchsia":"%E7%B4%AB%E7%BA%A2",
		"gray":"%E7%81%B0%E8%89%B2",
		"green":"%E7%BB%BF%E8%89%B2",
		"lime":"%E4%BA%AE%E7%BB%BF",
		"maroon":"%E8%A4%90%E7%BA%A2",
		"navy":"%E5%A4%A9%E8%93%9D",
		"olive":"%E6%A9%84%E6%A6%84",
		"purple":"%E7%B4%AB%E8%89%B2",
		"red":"%E7%BA%A2%E8%89%B2",
		"silver":"%E9%93%B6%E8%89%B2",
		"teal":"%E9%9D%92%E8%89%B2",
		"white":"%E7%99%BD%E8%89%B2",
		"yellow":"%E9%BB%84%E8%89%B2"
	},
	/**
	 * 返回option字符串，一般作为下拉框内容, 见示例
	 * @param {String} type 下拉框中显示中文还是英文名称,中文用字符串"cn"
	 * @returns {String} HTML字符串
	 * @example
	 * HTML代码
	 * &lt;select id="test1"&gt;&lt;/select&gt;
	 * &lt;select id="test2"&gt;&lt;/select&gt;
	 *
	 * 脚本如下:
	 * $("test1").innerHTML=Win.Color.options();
	 * $("test2").innerHTML=Win.Color.options("cn");
	 *
	 */
	options:function(type){
		var str="";
		for(var i in this.obj){
			str+="<option value='"+this.obj[i]+"'>"+(type=="cn"?decodeURI(this.cn[i]):i)+"</option>";
		}
		return str;
	},
	/**
	 * 返回一个下拉框HTML字符串
	 * @param {String} id 下拉框的id值
	 * @param {String} type 下拉框显示的英文或是中文, 中文用字符串"cn"
	 * @returns {String} HTML字符串
	 */
	control:function(id,type){
		var str="<select id='"+id+"'>";
		for(var i in this.obj){
			str+="<option value='"+this.obj[i]+"'>"+(type=="cn"?decodeURI(this.cn[i]):i)+"</option>";
		}
		str+="</select>";
		return str;
	}
};