<?php
@error_reporting(0); 
@session_start(); 
$dbhost = '127.0.0.1';
$dbuser = 'root';
$dbpw = '123456';
$dbname = 'sxs';
$adminpw= 'admin';
$pconnect = 0;
$dbcharset = 'utf-8';

function filter($string){
    $string = str_replace('<','&lt;',$string);
    $string = str_replace('>','&gt;',$string);
    return addslashes($string);
}

function page($page,$total,$phpfile,$pagesize=3,$pagelen=3){
$pagecode = '';
$page = intval($page);
$total = intval($total);
if(!$total) return array();
$pages = ceil($total/$pagesize);
if($page<1) $page = 1;
if($page>$pages) $page = $pages;
$offset = $pagesize*($page-1);
$init = 1;
$max = $pages;
$pagelen = ($pagelen%2)?$pagelen:$pagelen+1;
$pageoffset = ($pagelen-1)/2;
$pagecode='<div class="style13">';
$pagecode.="<span>$page/$pages</span>";
if($page!=1){
$pagecode.="<a href=\"{$phpfile}?page=1\">First</a>";
$pagecode.="<a href=\"{$phpfile}?page=".($page-1)."\">PrePage</a>";
}
if($pages>$pagelen){
if($page<=$pageoffset){
$init=1;
$max = $pagelen;
}else{
if($page+$pageoffset>=$pages+1){
$init = $pages-$pagelen+1;
}else{
$init = $page-$pageoffset;
$max = $page+$pageoffset;
}
}
}
for($i=$init;$i<=$max;$i++){
if($i==$page){
$pagecode.='<span>'.$i.'</span>';
} else {
$pagecode.="<a href=\"{$phpfile}?page={$i}\">$i</a>";
}
}
if($page!=$pages){
$pagecode.="<a href=\"{$phpfile}?page=".($page+1)."\">NextPage</a>";
$pagecode.="<a href=\"{$phpfile}?page={$pages}\">End</a>";
}
$pagecode.='</div>';
return array('pagecode'=>$pagecode,'sqllimit'=>' LIMIT '.$offset.','.$pagesize);
}

?>