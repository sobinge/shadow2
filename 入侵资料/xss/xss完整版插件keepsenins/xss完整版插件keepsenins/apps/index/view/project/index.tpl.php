<?php require_once PUBLIC_PATH."public.php"; ?>
</head>
<body>
<table width="100%" cellspacing="0" cellpadding="0" border="0" align="left">
  <tbody>
    <tr>
      <td height="30"><table width="100%" cellspacing="0" cellpadding="0" border="0">
          <tbody>
            <tr>
              <td width="15" height="30"><img width="15" height="30" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_03.gif"></td>
              <td width="24" background="<?php  echo PUBLIC_STYLE_URL ?>tab_05.gif"><img width="16" height="16" src="<?php  echo PUBLIC_STYLE_URL ?>311.gif"></td>
              <td width="1373" background="/coder/waiku/Public/Admin/images/tab_05.gif" class="title1">项目管理</td>
              <td width="14"><img width="14" height="30" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_07.gif"></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
    <tr>
      <td><table width="95%" cellspacing="2" cellpadding="3" border="0" align="center" style="margin-bottom:5px;" class="admintable">
          <tbody>
                 <tr>
              <td height="25" bgcolor="f7f7f7"><center> <strong>
              
              <font  color="#FF0000">     总项目: <font  color="#33CC00"><?php echo  $count['total'] ?></font>  
                                       
                      &nbsp;&nbsp;        正在进行:  <font  color="#33CC00"><?php echo  $count['doing'] ?></font> 
                      &nbsp;&nbsp;        已完成:  <font  color="#33CC00"><?php echo  $count['completed'] ?></font> 
                      &nbsp;&nbsp;        未开始:  <font  color="#33CC00"><?php echo  $count['nostart'] ?></font> 
              </strong></center></font></td>
               
            </tr>
            <tr>
              <td height="25" bgcolor="f7f7f7">快速查找：
                <select name="s" size="1" >
                  <option selected="" value="">-=请选择=-</option>
                  <option value="/coder/waiku/admin.php?s=/Article/index">所有项目</option>
                  <option value="/coder/waiku/admin.php?s=/Article/index/status/1">已审的文章</option>
                  <option value="/coder/waiku/admin.php?s=/Article/index/status/0">未审的文章</option>
                </select></td>
              <td bgcolor="f7f7f7" align="center"><form action="/coder/waiku/admin.php?s=/Article/search" method="POST" name="form1">
                  <input type="text" class="s26" value="" id="keyword" name="keywords">
                  <input type="submit" value="搜索" class="gbtn">
                </form></td>
              <td bgcolor="f7f7f7" align="right">跳转到：
                <select onChange="javascript:window.open(this.options[this.selectedIndex].value,'main')" id="ClassID" name="ClassID">
                  <option value="">请选择分类</option>
                  <option value="/coder/waiku/admin.php?s=/Article/index/typeid/2">|-as</option>
                </select></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
    <tr>
      <td><table width="95%" cellspacing="1" cellpadding="3" border="0" bgcolor="#F2F9E8" align="center" class="admintable">
          <tbody>
            <tr>
              <td align="left" class="admintitle" colspan="5">文章列表&#12288;[<a href="?m=project&a=add"><font color="green" > 添加 </font></a>] </td>
            </tr>
            <tr bgcolor="#f1f3f5" style="font-weight:bold;">
              <td width="2%" height="30" align="center" class="ButtonList">&nbsp;</td>
              <td width="3%" height="30" align="center" class="ButtonList">序号</td>
              <td width="15%" align="center" class="ButtonList">项目名称</td>
              <td width="7%" align="center" class="ButtonList">金额</td>
              <td width="15%" align="center" class="ButtonList">完成进度</td>
              <td width="15%" align="center" class="ButtonList">更新时间</td>
              <td width="7%" height="25" align="center" class="ButtonList">项目类型</td>
              <td width="15%" height="25" align="center" class="ButtonList">管理</td>
            </tr>
            <?php
			 
			 if(is_array($projects)){
			  
			   
			   foreach($projects  as  $project){
			   	
			   	$utime=date("Y-m-d H:i:s",$project['utime']);
			   	
			   	print<<<END
			   	      <tr>
              <td></td>
              <td>{$project['pid']}</td>
              <td>{$project['name']}</td>
              <td> {$project['price']}k</td>
              <td>{$project['status']}%</td>
              <td> {$utime} </td>
              <td> 开发 </td>
              <td>
                  <a href="?m=project&a=view&pid={$project['pid']}"><span class="ico_Preview"> </span> 查看 </a> 
                  <a href="?m=project&a=edit&pid={$project['pid']}"><span class="ico_Modify"> </span> 编辑 </a> 
                  <a href="?m=project&a=del&pid={$project['pid']}"><span class="ico_Del"> </span> 删除 </a></td>
            </tr>
            <tr>
END;
			   	
				   
			   }
			   
				 
			 }
				
			
			
			?>
            
      
              <td bgcolor="f7f7f7" colspan="5"><div id="page">
                  <ul style="text-align:left;">
                  </ul>
                </div></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
    <tr>
      <td height="29"><table width="100%" cellspacing="0" cellpadding="0" border="0">
          <tbody>
            <tr>
              <td width="15" height="29"><img width="15" height="29" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_20.gif"></td>
              <td background="<?php  echo PUBLIC_STYLE_URL ?>/tab_21.gif">&nbsp;</td>
              <td width="14"><img width="14" height="29" src="<?php  echo PUBLIC_STYLE_URL ?>/tab_22.gif"></td>
            </tr>
          </tbody>
        </table></td>
    </tr>
  </tbody>
</table>
</body>
