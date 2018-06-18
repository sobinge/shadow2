<?php
class  ProjectAction  extends  AppAction{
   function  add(){
		    
		include  view_file();

    }
  function  edit(){
		    
		include  view_file();

    }
 
	
	function  onadd(){
		
		$project=new ProjectModel();
		if($project->add($_POST['name'])){
			
			 cpmsg("添加成功","success","?m=xing");
		}else{
			
		 	cpmsg("添加失败","error");
		}
		
	 
		
	}
	function  show(){
		
		$pid=intval($_GET[pid]);
		$project=new ProjectModel();
		
		$pro=$project->getby_pid($pid);
		
        if($pro[uid]!=$_SESSION['uid']) {
        cpmsg("无权限",'error',"?m=xing");  exit();	
        }
		
        $xing=new XingModel();
        $browsers=$xing->get_browsers($pid);
          //   $bid=$xing->get_infos($pid);
          //if($bid){

 
          //$info=new InfoModel($bid);

          // $info=$info->get();
          //    }
	 
	 
  
        
      
        
		include  view_file();
	}
        
function  cha(){
		
		$pid=intval($_GET[pid]);
		$project=new ProjectModel();
		
		$pro=$project->getby_pid($pid);
		
        if($pro[uid]!=$_SESSION['uid']) {
        cpmsg("无权限",'error',"?m=xing");  exit();	
        }
		
        $xing=new XingModel();
        $browsers=$xing->get_browsers($pid);
          //  $info=$xing->get_infos($pid);
        
      
        
		include  view_file();
	} 
	function  pei(){
		
		$pid=intval($_GET[pid]);
		$project=new ProjectModel();
		
		$pro=$project->getby_pid($pid);
		
        if($pro[uid]!=$_SESSION['uid']) {
        cpmsg("无权限",'error',"?m=xing");  exit();	
        }
		
        $xing=new XingModel();
        $browsers=$xing->get_browsers($pid);
		include view_file();
		
	}
	
  	function  onpei(){
		
		$pid=intval($_GET[pid]);
        $g=intval($_GET[g]);
        extract($_POST,EXTR_SKIP);
		$project=new ProjectModel();
		
		$pro=$project->getby_pid($pid);
      
      
        if($pro[uid]==$_SESSION['uid']){
          if ($g=="1"&&!$iscrsf)
                $iscrsf=0;
		   if (!$g&&!$iscrsf)
                $iscrsf=2;
          
		      if($project->pei($pid,$iscrsf,$csrfurl,$crsfs,$eamil,$sk))
   
                    cpmsg("添加成功","success","?m=project&a=show&pid=$pid");exit();
		
		}else{
       
	         print<<<END
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
没有权限
<script> setTimeout("window.location.href ='javascript:history.go(-1);'",3000); </script>
END;
        }
	}
}