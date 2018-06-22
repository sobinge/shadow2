#!/usr/bin/python2
# -*- coding: utf-8 -*-

'''
gui for SQLmap
'''
from Tkinter import *
import ttk
import os
import subprocess
import re
from urlparse import urlparse

class app(Frame):
	def __init__(self, mw):
		Frame.__init__(self, mw)
		self.grid( sticky='nswe' )
		self.rowconfigure( 0, weight=1 )
		self.columnconfigure( 0, weight=1 )
		#
		n = ttk.Notebook(self)
		BuilderFrame = ttk.Frame(n)
		WatchLog = ttk.Frame(n)
		HelpMe = ttk.Frame(n)
                Thanks = ttk.Frame(n)
		#
		n.add(BuilderFrame, text=u'功能')
		n.add(WatchLog, text=u'查看记录')
		n.add(HelpMe, text=u'帮助')
                n.add(Thanks, text=u'感谢')
		n.rowconfigure( 0, weight=1 )
		n.columnconfigure( 0, weight=1 )
		n.grid(row=0, column=0, sticky='nswe')
		BuilderFrame.rowconfigure( 0, weight=1 )
		BuilderFrame.columnconfigure( 0, weight=1)
                # Thanks
                thx=ttk.Label(Thanks,text=u'''\n\n\n
                        首先，尤其感谢sqm的原作者给我们带来那么好的作品\n
                        其次，感谢 F4ck Team 和 Dis9 Team ，感谢你们对我的帮助\n
                        最后，感谢CCAV，感谢Helen黑客！\n\n
                        如果大家使用过程中发现什么问题，联系我：QQ 535335466 Email：ettack@gmail.com\n
                        ''')
                thx.grid()
		# Help SqlMAP
		lfhelp = ttk.Labelframe(HelpMe)
		lfhelp.grid(sticky='nswe')
		#
		scrolHelp = ttk.Scrollbar(lfhelp)
		scrolHelp.grid(row=0, column=1, sticky='ns')
		#
		HelpMe.rowconfigure( 0, weight=1 )
		HelpMe.columnconfigure( 0, weight=1)
		#
		lfhelp.rowconfigure( 0, weight=1 )
		lfhelp.columnconfigure( 0, weight=1)
		# about...
		manual_sqlmap = 'python sqlmap.py -h'
		process = subprocess.Popen(manual_sqlmap, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
		helpTXT = Text(lfhelp, yscrollcommand=scrolHelp.set, width = 73,
			height=24,bg='black', fg='#7E9F51')
		helpTXT.insert('1.0', process.communicate()[0])
		scrolHelp.config(command= helpTXT.yview)
		helpTXT.grid(row=0, column=0,ipadx=30,sticky='nswe')
		helpTXT.bind('<Button-3>',self.rClicker, add='')
		# Load Log...
		lfWatchLog = ttk.Labelframe(WatchLog, text='')
		WatchLog.rowconfigure( 0, weight=1 )
		WatchLog.columnconfigure( 0, weight=1)
		lfWatchLog.grid(row = 0, column =0, sticky='nswe', columnspan=4)
		lfWatchLog.rowconfigure( 0, weight=1 )
		lfWatchLog.columnconfigure( 0, weight=1)
		#
		scrolSes = ttk.Scrollbar(lfWatchLog)
		scrolSes.grid(row=0, column=1, sticky='ns')
		#
		self.sesTXT = Text(lfWatchLog, yscrollcommand=scrolSes.set, width = 73,
			height=22,bg='black', fg='#7E9F51')
		scrolSes.config(command= self.sesTXT.yview)
		self.sesTXT.grid(row=0, column=0,ipadx=30,sticky='nswe')
		self.sesTXT.bind('<Button-3>',self.rClicker, add='')
		#
		logbut = ttk.Button(WatchLog)
		logbut.config(text ="log", command=self.logs)
		logbut.grid(row =1, column=3, sticky='ws')
		#
		sesbut = ttk.Button(WatchLog)
		sesbut.config(text ="session", command=self.session)
		sesbut.grid(row =1, column=2,sticky='ws')
		#
		panedUrl = ttk.Panedwindow(BuilderFrame, orient=VERTICAL)
		panedUrl.rowconfigure( 0, weight=1 )
		panedUrl.columnconfigure( 0, weight=1 )
		#--url=URL
		urlLF = ttk.Labelframe(panedUrl, text=u'目标 url', width=100, height=100)
		urlLF.rowconfigure( 0, weight=1 )
		urlLF.columnconfigure( 0, weight=1)
		panedUrl.add(urlLF)
		#
		self.urlentry = ttk.Combobox(urlLF)
		self.urlentry.grid(row=0, column=0,sticky = 'we', pady=5)
		texturl = open(r"./last.uri", 'a+').readlines()
		self.urlentry['values'] = texturl
		self.urlentry.bind('<Button-3>',self.rClicker, add='')
		#query to sqlmap
		queryLF = ttk.Labelframe(panedUrl, text=u'sqlmap命令语句:', width=100, height=100)
		queryLF.rowconfigure( 0, weight=1 )
		queryLF.columnconfigure( 0, weight=1 )
		panedUrl.add(queryLF)
		self.sql_var = StringVar()
		self.sqlEdit = ttk.Entry(queryLF)
		self.sqlEdit.config(text="", textvariable = self.sql_var)
		self.sqlEdit.grid(sticky = 'we', pady=5)
		self.sqlEdit.columnconfigure(0, weight=1)
		self.sqlEdit.bind('<Button-3>',self.rClicker, add='')
		#
		panedUrl.grid(row=0, column=0, sticky='we', rowspan =2)
		#
		noBF = ttk.Notebook(BuilderFrame)
		setingsF = ttk.Frame(noBF)
		requestF = ttk.Frame(noBF)
		enumerationF = ttk.Frame(noBF)
		fileF = ttk.Frame(noBF)
		noBF.add(setingsF, text=u'设置')
		noBF.add(requestF, text=u'请求')
		noBF.add(enumerationF, text=u'枚举')
		noBF.add(fileF, text=u'文件')
		noBF.columnconfigure(0, weight=1)
		noBF.grid(sticky = 'nswe')
		#
		setingsF.columnconfigure(0, weight=1)
		requestF.columnconfigure(0, weight=1)
		fileF.columnconfigure(0, weight=1)
		# take query SqlMAP
		but = ttk.Button(BuilderFrame)
		but.config(text =u"构造命令语句",width = 10, command=self.commands)
		#
		but.grid(row=3,column=0, sticky='nw')
		#
		butInj = ttk.Button(BuilderFrame)
		butInj.config(text =u"开始",width = 10, command=self.injectIT)
		butInj.grid(row=3,column=0, sticky='ne')
		# Group (I-njections,T-ampers,O-ptimize)
		panedITO = ttk.Panedwindow(setingsF, orient=HORIZONTAL)
		panedITO.rowconfigure( 0, weight=1 )
		panedITO.columnconfigure( 0, weight=1 )
		#
		injectionLF = ttk.Labelframe(panedITO, text=u'注入')
		injectionLF.rowconfigure( 0, weight=1 )
		injectionLF.columnconfigure( 0, weight=1 )
		#
		tampersLF = ttk.Labelframe(panedITO, text=u'temper脚本')
		tampersLF.rowconfigure( 0, weight=1 )
		tampersLF.columnconfigure( 0, weight=1 )
		#
		panedITO.add(injectionLF)
		panedITO.add(tampersLF)
		panedITO.grid(row=0, column=0, sticky='nswe')
		#############################
		panedO = ttk.Panedwindow(setingsF, orient=HORIZONTAL)
		panedO.rowconfigure( 0, weight=1 )
		panedO.columnconfigure( 0, weight=1 )
		#
		optimizLF = ttk.Labelframe(panedO, text='')
		optimizLF.rowconfigure( 0, weight=1)
		optimizLF.columnconfigure( 0, weight=1 )
		#
		panedO.add(optimizLF)
		panedO.grid(row=0, column=1, sticky='nswe', rowspan=2)
		#-p TESTPARAMETER    Testable parameter(s)
		self.entryParam = ttk.Entry(injectionLF)
		self.entryParam.config(width=15)
		self.entryParam.grid(row=3,column=1, sticky='nswe')
		self.entryParam.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkParam = ttk.Checkbutton(injectionLF)
		self.chkParam_var = StringVar()
		self.chkParam.config(text=u"待测试参数", variable= self.chkParam_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekParam)
		self.chkParam.grid(row=3,column = 0, sticky = 'w')
		# Select database
		self.chk_dbms = ttk.Checkbutton(injectionLF)
		self.chk_dbms_var = StringVar()
		self.chk_dbms.config(text=u"数据库类型", variable= self.chk_dbms_var, onvalue= "on" ,
                        offvalue = "off", command= self.chek_dbms)
		self.chk_dbms.grid(row=0,column=0,sticky = 'sw')
		#
		self.box = ttk.Combobox(injectionLF)
		self.box_value = StringVar()
		self.box.config(textvariable=self.box_value, state='disabled', width = 15)
		self.box['values'] = ("access", "db2", "firebird", "maxdb", "mssqlserver", "mysql", "oracle", "postgresql", "sqlite", "sybase")
		self.box.current(0)
		self.box.bind('<<ComboboxSelected>>', self.chek_dbms)
		self.box.grid(row=0,column=1,sticky ='sw')
		# Prefix:
		self.entryPrefix = ttk.Entry(injectionLF)
		self.entryPrefix .config(text="" , textvariable="", width = 15)
		self.entryPrefix.grid(row=4,column=1, sticky='nswe')
		self.entryPrefix.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkPrefix = ttk.Checkbutton(injectionLF)
		self.chkPrefix_var = StringVar()
		self.chkPrefix.config(text=u"前缀", variable= self.chkPrefix_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekPrefix)
		self.chkPrefix.grid(row=4,column = 0, sticky = W)
		# Suffix:
		self.entrySuffix = ttk.Entry(injectionLF)
		self.entrySuffix.config(text="" , textvariable="", width = 15)
		self.entrySuffix.grid(row=5,column=1, sticky='nswe')
		self.entrySuffix.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkSuffix = ttk.Checkbutton(injectionLF)
		self.chkSuffix_var = StringVar()
		self.chkSuffix.config(text=u"后缀", variable= self.chkSuffix_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekSuffix)
		self.chkSuffix.grid(row=5,column = 0, sticky = 'w')
		# --os
		self.entryOS = ttk.Entry(injectionLF)
		self.entryOS.config(text="" , textvariable="", width = 15)
		self.entryOS.grid(row=6,column=1, sticky='nswe')
		self.entryOS.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkOS = ttk.Checkbutton(injectionLF)
		self.chkOS_var = StringVar()
		self.chkOS.config(text=u"操作系统", variable= self.chkOS_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekOS)
		self.chkOS.grid(row=6,column = 0, sticky = 'w')
		#--skip
		self.entrySkip = ttk.Entry(injectionLF)
		self.entrySkip.config(text="" , textvariable="", width = 15)
		self.entrySkip.grid(row=7,column=1, sticky='nswe')
		self.entrySkip.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkSkip = ttk.Checkbutton(injectionLF)
		self.chkSkip_var = StringVar()
		self.chkSkip.config(text=u"跳过某参数", variable= self.chkSkip_var, onvalue= "on" ,
                                  offvalue = "off", command= self.chekSkip)
		self.chkSkip.grid(row=7,column = 0, sticky = 'w')
		#--logic-negative
		self.chkNeg = ttk.Checkbutton(injectionLF)
		self.chkNeg_var = StringVar()
		self.chkNeg.config(text=u"使用逻辑选项", variable= self.chkNeg_var, onvalue= "on" ,
                                    offvalue = "off", command= self.chekNeg)
		self.chkNeg.grid(row=8,column = 0, sticky = 'w')
		#-Tamper:
		self.Ltamper=Listbox(tampersLF,height=8,width=31,selectmode=EXTENDED)
		# *.py in listbox, exclude __init__.py
		files_tamper = os.listdir('./tamper')
		tampers = filter(lambda x: x.endswith('.py'), files_tamper)
		for tamp_list in tampers:
			if tamp_list not in "__init__.py":
				self.Ltamper.insert(END,tamp_list)
		self.Ltamper.rowconfigure( 0, weight=1 )
		self.Ltamper.columnconfigure( 0, weight=1 )
		self.Ltamper.grid(row =0, column = 0, padx=5, sticky='nswe')

		# Tamper Scroll
		scrollTamper = ttk.Scrollbar(tampersLF, orient=VERTICAL, command=self.Ltamper.yview)
		self.Ltamper['yscrollcommand'] = scrollTamper.set

		scrollTamper.grid(row=0,column=1, sticky='ns')
		#
		optimiz_LF = ttk.Labelframe(optimizLF, text=u'优化')
		optimiz_LF.grid(row=0, sticky='nw', pady=1)
		#
		self.chkOpt = ttk.Checkbutton(optimiz_LF)
		self.chkOpt_var = StringVar()
		self.chkOpt.config(text=u"打开所有优化选项", variable= self.chkOpt_var, onvalue= "on" ,
                                   offvalue = "off", command= self.chekOpt)
		self.chkOpt.grid(row=0,column = 0, sticky = 'wn', pady=1)
		#--predict-output    Predict common queries output
		self.chkPred = ttk.Checkbutton(optimiz_LF)
		self.chkPred_var = StringVar()
		self.chkPred.config(text=u"预测输出结果", variable= self.chkPred_var, onvalue= "on" ,
                                   offvalue = "off", command= self.chekPred)
		self.chkPred.grid(row=1,column = 0, sticky = 'wn', pady=1)
		#--keep-alive
		self.chkKeep = ttk.Checkbutton(optimiz_LF)
		self.chkKeep_var = StringVar()
		self.chkKeep.config(text=u"持续连接", variable= self.chkKeep_var, onvalue= "on" ,
                                    offvalue = "off", command= self.chekKeep)
		self.chkKeep.grid(row=2,column = 0, sticky = 'wn', pady=1)
		#--null-connection   Retrieve page length without actual HTTP response body
		self.chkNull = ttk.Checkbutton(optimiz_LF)
		self.chkNull_var = StringVar()
		self.chkNull.config(text=u"只比较响应包长度", variable= self.chkNull_var, onvalue= "on" ,
                                    offvalue = "off", command= self.chekNull)
		self.chkNull.grid(row=3,column = 0, sticky = 'wn', pady=1)
		#--threads=THREADS   Max number of concurrent HTTP(s) requests (default 1)
		self.chk_thr = ttk.Checkbutton(optimiz_LF)
		self.chk_thr_var = StringVar()
		self.chk_thr.config(text=u"线程数", variable= self.chk_thr_var, onvalue= "on",
                                    offvalue = "off", command= self.chek_thr)
		self.chk_thr.grid(row=4,column=0,sticky = 'wn', pady=1)
		self.thr = ttk.Combobox(optimiz_LF)
		self.thr_value = StringVar()
		self.thr.config(textvariable=self.thr_value, state='disable', width = 5)
		self.thr['values'] = ('1','2', '3','4','5','6','7','8','9','10')
		self.thr.current(0)
		self.thr.bind('<<ComboboxSelected>>', self.chek_thr)
		self.thr.grid(row=4,column=1,sticky ='w')
		# Verbose
		otherLF = ttk.Labelframe(optimizLF, text=u'其他')
		otherLF.grid(row=1, sticky='nwe')
		#-f, --fingerprint
		self.chk_fing = ttk.Checkbutton(otherLF)
		self.chk_fing_var = StringVar()
		self.chk_fing.config(text=u"详细检测数据库类型", variable= self.chk_fing_var, onvalue= "on",
                                      offvalue = "off", command= self.chekFing)
		self.chk_fing.grid(row=0,column=0, sticky= 'nw')
		# Banner
		self.chk_Banner = ttk.Checkbutton(otherLF)
		self.chk_Banner_var = StringVar()
		self.chk_Banner.config(text=u"数据库版本信息", variable= self.chk_Banner_var, onvalue= "on",
                                       offvalue = "off", command= self.chekBanner)
		self.chk_Banner.grid(row=1,column=0, sticky= 'w')
		# --hex
		self.chk_Hex = ttk.Checkbutton(otherLF)
		self.chk_Hex_var = StringVar()
		self.chk_Hex.config(text=u"hex", variable= self.chk_Hex_var, onvalue= "on",
                                      offvalue = "off", command= self.chekHex)
		self.chk_Hex.grid(row=2,column=0, sticky= 'nw')
		# Batch / Verbose OTHER
		self.chk_Batch = ttk.Checkbutton(otherLF)
		self.chk_Batch_var = StringVar()
		self.chk_Batch.config(text=u"无交互模式", variable= self.chk_Batch_var, onvalue= "on",
                                      offvalue = "off", command= self.chekBatch)
		self.chk_Batch.grid(row=3,column=0, sticky= 'nw')
		#
		self.chk_verb = ttk.Checkbutton(otherLF)
		self.chk_verb_var = StringVar()
		self.chk_verb.config(text=u"输出详细度            ", variable= self.chk_verb_var, onvalue= "on",
                        offvalue = "off", command= self.chek_verb)
		self.chk_verb.grid(row=4,column=0, sticky='wn')
		self.box_verb = ttk.Combobox(otherLF)
		self.box_verb_value = StringVar()
		self.box_verb.config(textvariable=self.box_verb_value, state='disabled', width = 5)
		self.box_verb['values'] = ('1', '2', '3','4','5','6')
		self.box_verb.current(0)
		self.box_verb.bind('<<ComboboxSelected>>', self.chek_verb)
		self.box_verb.grid(row=4,column=1,sticky ='e')
		# Group (Detections,Techniques,Other)
		panedDTO = ttk.Panedwindow(setingsF, orient=HORIZONTAL)
		panedDTO.rowconfigure( 0, weight=1 )
		panedDTO.columnconfigure( 0, weight=1 )
		#
		detectionLF = ttk.Labelframe(panedDTO, text=u'检测', width=100, height=100)
		detectionLF.rowconfigure( 0, weight=1 )
		detectionLF.columnconfigure( 0, weight=1 )
		#
		techniqueLF = ttk.Labelframe(panedDTO, text=u'技术', width=100, height=100)
		techniqueLF.rowconfigure( 0, weight=1 )
		techniqueLF.columnconfigure( 0, weight=1 )
		#
		panedDTO.add(detectionLF)
		panedDTO.add(techniqueLF)
		panedDTO.grid(row=1, column=0, columnspan=1,sticky='we',ipady=0)
		# String:
		self.entryStr = ttk.Entry(detectionLF)
		self.entryStr .config(text="" , textvariable="")
		self.entryStr.grid(row=0,column=1, sticky = 'we')
		self.entryStr.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkStr = ttk.Checkbutton(detectionLF)
		self.chkStr_var = StringVar()
		self.chkStr.config(text=u"字符串", variable= self.chkStr_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekStr)
		self.chkStr.grid(row=0,column = 0, sticky = 'sw')
		#--regexp=REGEXP
		self.entryReg = ttk.Entry(detectionLF)
		self.entryReg.config(text="" , textvariable="", width = 22)
		self.entryReg.grid(row=1,column=1)
		self.entryReg.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkReg = ttk.Checkbutton(detectionLF)
		self.chkReg_var = StringVar()
		self.chkReg.config(text=u"正则", variable= self.chkReg_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekReg)
		self.chkReg.grid(row=1,column = 0, sticky = 'sw')
		#--code=CODE
		self.chkCode = ttk.Checkbutton(detectionLF)
		self.chkCode_var = StringVar()
		self.chkCode.config(text=u"代码", variable= self.chkCode_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekCode)
		self.chkCode.grid(row=3,column = 0, sticky = 'w')
		#
		self.entryCode = ttk.Entry(detectionLF)
		self.entryCode.config(text="" , textvariable="", width = 22)
		self.entryCode.grid(row=3,column=1)
		#--level=LEVEL
		self.chk_level = ttk.Checkbutton(detectionLF)
		self.chk_level_var = StringVar()
		self.chk_level.config(text=u"等级", variable= self.chk_level_var, onvalue= "on" ,
                        offvalue = "off", command= self.chek_level)
		self.chk_level.grid(row=4,column=0,sticky = 'w')
		#
		self.box_level = ttk.Combobox(detectionLF)
		self.box_level_value = StringVar()
		self.box_level.config(textvariable=self.box_level_value, state='disabled', width = 5)
		self.box_level['values'] = ('1', '2', '3','4','5')
		self.box_level.current(0)
		self.box_level.bind('<<ComboboxSelected>>', self.chek_level)
		self.box_level.grid(row=4,column=1,sticky = 'w')
		#--risk=RISK
		self.chk_risk = ttk.Checkbutton(detectionLF)
		self.chk_risk_var = StringVar()
		self.chk_risk.config(text=u"风险度", variable= self.chk_risk_var, onvalue= "on",
                        offvalue = "off", command= self.chek_risk)
		self.chk_risk.grid(row=5,column=0,sticky = 'w')
		#
		self.box_risk = ttk.Combobox(detectionLF)
		self.box_risk_value = StringVar()
		self.box_risk.config(textvariable=self.box_risk_value, state='disabled', width = 5)
		self.box_risk['values'] = ('1', '2', '3')
		self.box_risk.current(0)
		self.box_risk.bind('<<ComboboxSelected>>', self.chek_risk)
		self.box_risk.grid(row=5,column=1,sticky = 'w')
		#--text-only
		self.chkTxt = ttk.Checkbutton(detectionLF)
		self.chk_Txt_var = StringVar()
		self.chkTxt.config(text=u"仅文本", variable= self.chk_Txt_var, onvalue= "on" ,
                                   offvalue = "off", command= self.chekTxt)
		self.chkTxt.grid(row=4,column = 1, sticky = 'e')
		#--titles
		self.chkTit = ttk.Checkbutton(detectionLF)
		self.chk_Tit_var = StringVar()
		self.chkTit.config(text=u"标题", variable= self.chk_Tit_var, onvalue= "on" ,
                                   offvalue = "off", command= self.chekTit)
		self.chkTit.grid(row=5,column = 1, sticky = 'e', padx=22)
		#--technique=TECH
		self.chk_tech = ttk.Checkbutton(techniqueLF)
		self.chk_tech_var = StringVar()
		self.chk_tech.config(text=u"注入技术", variable= self.chk_tech_var, onvalue= "on",
                        offvalue = "off", command= self.chek_tech)
		self.chk_tech.grid(row=0,column=0,sticky = 'nw')
		#
		self.boxInj = ttk.Combobox(techniqueLF)
		self.boxInj_value = StringVar()
		self.boxInj.config(textvariable=self.boxInj_value, state='disabled', width = 15)
		self.boxInj['values'] = ('B','E', 'U','S','T')
		self.boxInj.current(0)
		self.boxInj.bind('<<ComboboxSelected>>', self.chek_tech)
		self.boxInj.grid(row=0,column=1,sticky ='nwe')
		#
		self.entryCol = ttk.Entry(techniqueLF)
		self.entryCol.config(text = "" , textvariable = "", width = 15)
		self.entryCol.grid(row = 1,column = 1, sticky='nwe')
		#
		sep = ttk.Separator(techniqueLF, orient=HORIZONTAL)
		sep.grid(row = 4, sticky='w', pady=10)
		#
		self.chkCol = ttk.Checkbutton(techniqueLF)
		self.chkCol_var = StringVar()
		self.chkCol.config(text=u"union数", variable= self.chkCol_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekCol)
		self.chkCol.grid(row=1,column = 0, sticky = 'nw')
		#--union-char
		self.entryChar = ttk.Entry(techniqueLF)
		self.entryChar.config(text="" , textvariable="", width = 15)
		self.entryChar.grid(row=2,column=1, sticky='nwe')
		#
		self.chkChar = ttk.Checkbutton(techniqueLF)
		self.chkChar_var = StringVar()
		self.chkChar.config(text=u"union字符", variable= self.chkChar_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekChar)
		self.chkChar.grid(row=2,column = 0, sticky = 'nw')
		#--time-sec
		self.entrySec = ttk.Entry(techniqueLF)
		self.entrySec.config(text="" , textvariable="", width = 15)
		self.entrySec.grid(row=3,column=1, sticky='nwe')
		#
		self.chkSec = ttk.Checkbutton(techniqueLF)
		self.chkSec_var = StringVar()
		self.chkSec.config(text=u"查询延迟时间", variable= self.chkSec_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekSec)
		self.chkSec.grid(row=3,column = 0, sticky = 'nw')
		# data
		dataLF = ttk.Labelframe(requestF, text=u'POST数据')
		dataLF.grid(row = 0, column =0, sticky='we')
		dataLF.columnconfigure(0, weight=1)
		#
		self.chkdata = ttk.Checkbutton(dataLF)
		self.chkdata_var = StringVar()
		self.chkdata.config(text = "", variable= self.chkdata_var, onvalue= "on" ,
			offvalue = "off", command= self.chekdata)
		self.chkdata.grid(row=0,column=0, sticky='w')
		#
		self.entryData = ttk.Entry(dataLF)
		self.entryData.grid(row =0,column=0, sticky='we', padx=30)
		self.entryData.bind('<Button-3>',self.rClicker, add='')
		# cookie:
		cookieLF = ttk.Labelframe(requestF, text=u'cookie')
		cookieLF.grid(row = 1, column =0, sticky='we')
		cookieLF.columnconfigure(0, weight=1)
		#
		self.chkCook = ttk.Checkbutton(cookieLF)
		self.chkCook_var = StringVar()
		self.chkCook.config(text="", variable= self.chkCook_var, onvalue= "on" ,
			offvalue = "off", command= self.chekCook)
		self.chkCook.grid(row=0,column=0, sticky='w')
		#
		self.entryCook = ttk.Entry(cookieLF)
		self.entryCook.grid(row=0,column=0, sticky='snwe', padx=30)
		self.entryCook.bind('<Button-3>',self.rClicker, add='')
		#
		enumerateLF = ttk.Labelframe(enumerationF, text=u'枚举')
		enumerateLF.grid(row = 0, column = 0, padx=10, pady = 10, sticky='w')
		# Retrieve DBMS current user
		self.chkCurrent_user = ttk.Checkbutton(enumerateLF)
		self.chkCurrent_user_var = StringVar()
		self.chkCurrent_user.config(text=u"当前用户", variable= self.chkCurrent_user_var, onvalue= "on" ,
			offvalue = "off", command= self.chekCurrent_user)
		self.chkCurrent_user.grid(row=0,column=0,sticky = 'w')
		# Retrieve DBMS current database
		self.chkCurrent_db = ttk.Checkbutton(enumerateLF)
		self.chkCurrent_db_var = StringVar()
		self.chkCurrent_db.config(text=u"当前数据库", variable= self.chkCurrent_db_var, onvalue= "on" ,
			offvalue = "off", command= self.chekCurrent_db)
		self.chkCurrent_db.grid(row=1,column=0,sticky = 'w')
		#--is-dba   Detect if the DBMS current user is DBA
		self.chk_is_dba = ttk.Checkbutton(enumerateLF)
		self.chk_is_dba_var = StringVar()
		self.chk_is_dba.config(text=u"是否是DBA", variable= self.chk_is_dba_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_is_dba)
		self.chk_is_dba.grid(row=2,column=0,sticky = 'w')
		#--users             Enumerate DBMS users
		self.chk_users = ttk.Checkbutton(enumerateLF)
		self.chk_users_var = StringVar()
		self.chk_users.config(text=u"用户", variable= self.chk_users_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_users)
		self.chk_users.grid(row=3,column=0,sticky = 'w')
		#-passwords         Enumerate DBMS users password hashes
		self.chk_passwords = ttk.Checkbutton(enumerateLF)
		self.chk_passwords_var = StringVar()
		self.chk_passwords.config(text=u"密码", variable= self.chk_passwords_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_passwords)
		self.chk_passwords.grid(row=0,column=1,sticky = 'w')
		#--privileges        Enumerate DBMS users privileges
		self.chk_privileges  = ttk.Checkbutton(enumerateLF)
		self.chk_privileges_var = StringVar()
		self.chk_privileges.config(text=u"权限", variable= self.chk_privileges_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_privileges)
		self.chk_privileges.grid(row=1,column=1,sticky = 'w')
		#--roles             Enumerate DBMS users roles
		self.chk_roles = ttk.Checkbutton(enumerateLF)
		self.chk_roles_var = StringVar()
		self.chk_roles .config(text=u"角色", variable= self.chk_roles_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_roles)
		self.chk_roles.grid(row=2,column=1,sticky = 'w')
		#-dbs               Enumerate DBMS databases
		self.chk_dbs = ttk.Checkbutton(enumerateLF)
		self.chk_dbs_var = StringVar()
		self.chk_dbs.config(text=u"数据库", variable= self.chk_dbs_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_dbs)
		self.chk_dbs.grid(row=3,column=1,sticky = 'w')
		#--tables            Enumerate DBMS database tables
		self.chk_tables = ttk.Checkbutton(enumerateLF)
		self.chk_tables_var = StringVar()
		self.chk_tables.config(text=u"表", variable= self.chk_tables_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_tables)
		self.chk_tables.grid(row=0,column=2,sticky = 'w')
		#--columns           Enumerate DBMS database table columns
		self.chk_columns = ttk.Checkbutton(enumerateLF)
		self.chk_columns_var = StringVar()
		self.chk_columns.config(text=u"字段", variable= self.chk_columns_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_columns)
		self.chk_columns.grid(row=1,column=2,sticky = 'w')
		#--schema            Enumerate DBMS schema
		self.chk_schema = ttk.Checkbutton(enumerateLF)
		self.chk_schema_var = StringVar()
		self.chk_schema.config(text=u"架构", variable= self.chk_schema_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_schema)
		self.chk_schema.grid(row=2,column=2,sticky = 'w')
		#--count             Retrieve number of entries for table(s)
		self.chk_count  = ttk.Checkbutton(enumerateLF)
		self.chk_count_var = StringVar()
		self.chk_count.config(text=u"计数", variable= self.chk_count_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_count)
		self.chk_count.grid(row=3,column=2,sticky = 'w')
		#--dump              Dump DBMS database table entries
		dumpLF = ttk.Labelframe(enumerationF, text=u'Dump')
		dumpLF.grid(row = 0, column=1, pady = 10, padx=10, sticky='w')
		#
		self.chk_dump = ttk.Checkbutton(dumpLF)
		self.chk_dump_var = StringVar()
		self.chk_dump.config(text=u"dump", variable= self.chk_dump_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_dump)
		self.chk_dump.grid(row=1,column=1,sticky = 'w')
		#--dump-all          Dump all DBMS databases tables entries
		self.chk_dump_all = ttk.Checkbutton(dumpLF)
		self.chk_dump_all_var = StringVar()
		self.chk_dump_all.config(text=u"全部dump", variable= self.chk_dump_all_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_dump_all)
		self.chk_dump_all.grid(row=2,column=1,sticky = 'w')
		#--search            Search column(s), table(s) and/or database name(s)
		self.chk_search = ttk.Checkbutton(dumpLF)
		self.chk_search_var = StringVar()
		self.chk_search.config(text=u"搜索", variable= self.chk_search_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_search)
		self.chk_search.grid(row=3,column=1,sticky = 'w')
		#--exclude-sysdbs    Exclude DBMS system databases when enumerating tables
		self.chk_exclude = ttk.Checkbutton(dumpLF)
		self.chk_exclude_var = StringVar()
		self.chk_exclude.config(text=u"不包含系统数据库", variable= self.chk_exclude_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_exclude)
		self.chk_exclude.grid(row=4,column=1,sticky = 'w')
		#-D DB               DBMS database to enumerate БД, Таблица, Колонка
		dtcLF = ttk.Labelframe(enumerationF, text=u'数据库名, 表名, 列名')
		dtcLF.grid(row = 1, column=0, pady = 10, ipady=5, padx=10, sticky='we', columnspan=5)
		dtcLF.columnconfigure(0, weight=1)
		#
		self.entryD = ttk.Entry(dtcLF)
		self.entryD.config(text="" , textvariable="")
		self.entryD.grid(row=0,column=0, sticky='we', padx=30)
		self.entryD.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkD = ttk.Checkbutton(dtcLF)
		self.chkD_var = StringVar()
		self.chkD.config(text=u"指定数据库名", variable= self.chkD_var, onvalue= "on" ,
			offvalue = "off", command= self.chekD)
		self.chkD.grid(row=0,column = 0, sticky = 'w')
		#-T TBL              DBMS database table to enumerate
		self.entryT = ttk.Entry(dtcLF)
		self.entryT.config(text="" , textvariable="")
		self.entryT.grid(row=1,column=0,sticky='we', padx=30)
		self.entryT.bind('<Button-3>',self.rClicker, add='')
		self.chkT = ttk.Checkbutton(dtcLF)
		self.chkT_var = StringVar()
		self.chkT.config(text=u"指定表名", variable= self.chkT_var, onvalue= "on" ,
			offvalue = "off", command= self.chekT)
		self.chkT.grid(row=1,column = 0, sticky = 'w')
		#-C COL              DBMS database table column to enumerate
		self.entryC = ttk.Entry(dtcLF)
		self.entryC.config(text="" , textvariable="")
		self.entryC.grid(row=2,column=0, sticky='we', padx=30)
		self.entryC.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkC = ttk.Checkbutton(dtcLF)
		self.chkC_var = StringVar()
		self.chkC.config(text=u"指定列名", variable= self.chkC_var, onvalue= "on" ,
			offvalue = "off", command= self.chekC)
		self.chkC.grid(row=2,column = 0, sticky = W)
		#
		#--sql-query=:
		sqlQueryLF = ttk.Labelframe(enumerationF, text=u'执行SQL语句:')
		sqlQueryLF.grid(row = 2, column=0, ipady=5, pady = 10, padx=10, sticky='we', columnspan=5)
		sqlQueryLF.columnconfigure(0, weight=1)
		#
		self.entryQuery = ttk.Entry(sqlQueryLF)
		self.entryQuery.config(text="" , textvariable="")
		self.entryQuery.grid(row=0,column=0, sticky='we', padx=30)
		self.entryQuery.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkQuery = ttk.Checkbutton(sqlQueryLF)
		self.chkQuery_var = StringVar()
		self.chkQuery.config(text="", variable= self.chkQuery_var, onvalue= "on" ,
                        offvalue = "off", command= self.chekQuery)
		self.chkQuery.grid(row=0,column=0,sticky = 'w')
		#--start=LIMITSTART  First query output entry to retrieve
		limitLF = ttk.Labelframe(enumerationF, text=u'limit')
		limitLF.grid(row = 0, column=4, pady=10, padx=10, sticky='w')
		#
		self.entry_start= ttk.Entry(limitLF)
		self.entry_start .config(text="" , textvariable="", width = 5)
		self.entry_start.grid(row=1,column=1)
		#
		self.chk_start = ttk.Checkbutton(limitLF)
		self.chk_start_var = StringVar()
		self.chk_start.config(text=u"始", variable= self.chk_start_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_start)
		self.chk_start.grid(row=1,column = 0, sticky = W)
		#--stop=LIMITSTOP    Last query output entry to retrieve
		self.entry_stop= ttk.Entry(limitLF)
		self.entry_stop.config(text="" , textvariable="", width = 5)
		self.entry_stop.grid(row=2,column=1)
		#
		self.chk_stop = ttk.Checkbutton(limitLF)
		self.chk_stop_var = StringVar()
		self.chk_stop.config(text=u"末", variable= self.chk_stop_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_stop)
		self.chk_stop.grid(row=2,column = 0, sticky = W)
		#--first=FIRSTCHAR   First query output word character to retrieve
		charblindLF = ttk.Labelframe(enumerationF, text=u'盲注选项')
		charblindLF.grid(row = 0, column = 3, pady=10, padx=10, sticky='w')
		#
		self.entry_first= ttk.Entry(charblindLF)
		self.entry_first .config(text="" , textvariable="", width = 5)
		self.entry_first.grid(row=0,column=1)
		#
		self.chk_first = ttk.Checkbutton(charblindLF)
		self.chk_first_var = StringVar()
		self.chk_first.config(text=u"第一字符", variable= self.chk_first_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_first)
		self.chk_first.grid(row=0,column = 0)
		#--last=LASTCHAR     Last query output word character to retrieve
		self.entry_last= ttk.Entry(charblindLF)
		self.entry_last .config(text="" , textvariable="", width = 5)
		self.entry_last.grid(row=1,column=1)
		#
		self.chk_last = ttk.Checkbutton(charblindLF)
		self.chk_last_var = StringVar()
		self.chk_last.config(text=u"最末字符", variable= self.chk_last_var, onvalue= "on" ,
			offvalue = "off", command= self.chek_last)
		self.chk_last.grid(row=1,column = 0)
		#--file-read:
		filereadLF = ttk.Labelframe(fileF, text=u'读文件:')
		filereadLF.grid(sticky='we', ipady=3)
		filereadLF.columnconfigure(0, weight=1)
		#
		self.entryFile = ttk.Entry(filereadLF)
		self.entryFile.grid(row=0,column=0, sticky='we', padx=30)
		self.entryFile.bind('<Button-3>',self.rClicker, add='')
		#
		self.chkFile = ttk.Checkbutton(filereadLF)
		self.chkFile_var = StringVar()
		self.chkFile.config(text="", variable= self.chkFile_var, onvalue= "on" ,
			offvalue = "off", command= self.chekFile)
		self.chkFile.grid(row=0,column=0,sticky = 'w')
		#
		self.viewfile = ttk.Button(fileF)
		self.viewfile.config(text =u"在记录中查看", command=self.vfile)
		self.viewfile.grid(row =0, column=1,sticky='es')
		#Default *log,*config
		configDL = ttk.Panedwindow(fileF, orient=HORIZONTAL, width=100, height=240)
		configDL.rowconfigure( 0, weight=1 )
		configDL.columnconfigure( 0, weight=1)
		#
		catLF = ttk.Labelframe(configDL, text=u'类别')
		catLF.rowconfigure( 0, weight=1 )
		catLF.columnconfigure( 0, weight=1 )
		#
		listLF = ttk.Labelframe(configDL, text=u'默认 *log, *config')
		listLF.rowconfigure( 0, weight=1 )
		listLF.columnconfigure( 0, weight=1 )
		#
		configDL.add(catLF)
		configDL.add(listLF)
		configDL.grid(row=1,columnspan=2, sticky='we', pady=5)
		#Category ./cfg_dir/*.txt
		self.Lcat = Listbox(catLF,height=100,width=20,selectmode=EXTENDED)
		files_cat = os.listdir('./cfg_dir')
		cats = filter(lambda x: x.endswith('.txt'), files_cat)
		for cat_list in cats:
			cat_list = cat_list.replace('.txt', '')
			self.Lcat.insert(END, cat_list)
		self.Lcat.grid(row =0, column = 0)
		self.Lcat.bind("<Double-Button-1>", self.show_def_log)
		# Scroll
		scrollcat = ttk.Scrollbar(catLF, orient=VERTICAL, command=self.Lcat.yview)
		self.Lcat['yscrollcommand'] = scrollcat.set
		scrollcat.grid(row=0,column=1, sticky='ns')
		#Show Default *log, *config
		s_def_log = ttk.Scrollbar(listLF)
		s_def_log.grid(row=0, column=1, sticky='ns')
		#
		self.d_log_TXT = Text(listLF, yscrollcommand=s_def_log.set, width = 73,
		               height=50,bg='black', fg='#7E9F51')
		s_def_log.config(command= self.d_log_TXT.yview)
		self.d_log_TXT.grid(row=0, column=0,ipadx=30,sticky='nswe')
		self.d_log_TXT.bind('<Button-3>',self.rClicker, add='')

	# ####################################################
	#Func:
	# ####################################################
	def show_def_log(self, *args):
		load_d_log = self.Lcat.curselection()
		self.d_log_TXT.delete("1.0",END)
		if 1 == len(load_d_log):
			file_d_log = ','.join([self.Lcat.get(ind) for ind in load_d_log])
			self.d_log_TXT.insert(END, open(r'./cfg_dir/'+file_d_log+'.txt', 'r').read())
			self.d_log_TXT.mark_set(INSERT, '1.0')
			self.d_log_TXT.focus()
		else:
			self.d_log_TXT.insert(END, u"默认记录文件为空.")

	def vfile(self):
		load_file = self.entryFile.get()
		load_url = self.urlentry.get()
                if 'http' not in load_url:
                    load_url='http://'+load_url
		self.sesTXT.delete("1.0",END)
		load_file = load_file.replace("/", "_")
		load_host = urlparse(load_url).netloc
		try:
			log_size = os.path.getsize("./output/"+load_host+"/files/"+load_file)
			if log_size != 0:
				self.sesTXT.insert(END, open(r"./output/"+load_host+"/files/"+load_file, 'r').read())
				self.sesTXT.mark_set(INSERT, '1.0')
				self.sesTXT.focus()
			else:
				self.sesTXT.insert(END, u"File-Empty. ")
		except (IOError,OSError):
			self.sesTXT.insert(END, u"文件未找到.")
		return
	# file-read
	def chekFile(self):
		sqlFile = self.chkFile_var.get()
		if sqlFile == "on" :
			file_sql= ' --file-read="'+self.entryFile.get()+'"'
		else:
			file_sql= ''
		return file_sql
	# sql-query
	def chekQuery(self):
		sqlQuery = self.chkQuery_var.get()
		if sqlQuery == "on" :
			query_sql= ' --sql-query="'+self.entryQuery.get()+'"'
		else:
			query_sql= ''
		return query_sql
	# - data
	def chekdata(self):
		sqlData = self.chkdata_var.get()
		if sqlData == "on" :
			data_sql= ' --data="'+self.entryData.get()+'"'
		else:
			data_sql= ''
		return data_sql
	# -Cookie:
	def chekCook(self):
		sqlCook = self.chkCook_var.get()
		if sqlCook == "on" :
			cook_sql= ' --cookie="'+self.entryCook.get()+'"'
		else:
			cook_sql= ''
		return cook_sql
	#-Prefix
	def chekPrefix(self):
		sqlPrefix = self.chkPrefix_var.get()
		if sqlPrefix == "on" :
			prefix_sql= ' --prefix="'+self.entryPrefix.get()+'"'
		else:
			prefix_sql= ''
		return    prefix_sql
	#-Suffix
	def chekSuffix(self):
		sqlSuffix = self.chkSuffix_var.get()
		if sqlSuffix == "on" :
			suffix_sql= ' --suffix="'+self.entrySuffix.get()+'"'
		else:
			suffix_sql= ''
		return suffix_sql
	#--os
	def chekOS(self):
		sqlOS = self.chkOS_var.get()
		if sqlOS == "on" :
			os_sql= ' --os="'+self.entryOS.get()+'"'
		else:
			os_sql= ''
		return os_sql
	#--skip
	def chekSkip(self):
		sqlSkip = self.chkSkip_var.get()
		if sqlSkip == "on" :
			skip_sql= ' --skip="'+self.entrySkip.get()+'"'
		else:
			skip_sql= ''
		return skip_sql
	#--logic-negative
	def chekNeg(self):
		sqlNeg = self.chkNeg_var.get()
		if sqlNeg == "on" :
			neg_sql= ' --logic-negative'
		else:
			neg_sql= ''
		return neg_sql
	# --string
	def chekStr(self):
		sqlStr = self.chkStr_var.get()
		if sqlStr == "on" :
			str_sql= ' --string="'+self.entryStr.get()+'"'
		else:
			str_sql= ''
		return    str_sql
	# --regexp
	def chekReg(self):
		sqlReg = self.chkReg_var.get()
		if sqlReg == "on" :
			reg_sql= ' --regexp="'+self.entryReg.get()+'"'
		else:
			reg_sql= ''
		return reg_sql
	# -code
	def chekCode(self):
		sqlCode = self.chkCode_var.get()
		if sqlCode == "on" :
			code_sql= ' --code="'+self.entryCode.get()+'"'
		else:
			code_sql= ''
		return code_sql

	# uCols
	def chekCol(self):
		sqlCol = self.chkCol_var.get()
		if sqlCol == "on" :
			col_sql= ' --union-cols="'+self.entryCol.get()+'"'
		else:
			col_sql= ''
		return    col_sql
	# uChar
	def chekChar(self):
		sqlChar = self.chkChar_var.get()
		if sqlChar == "on" :
			char_sql= ' --union-char="'+self.entryChar.get()+'"'
		else:
			char_sql= ''
		return char_sql
	def chekSec(self):
		sqlSec = self.chkSec_var.get()
		if sqlSec == "on" :
			sec_sql= ' --time-sec="'+self.entrySec.get()+'"'
		else:
			sec_sql= ''
		return sec_sql
	# -o
	def chekOpt(self):
		sqlOpt = self.chkOpt_var.get()
		if sqlOpt == "on" :
			opt_sql= " -o"
		else:
			opt_sql= ''
		return opt_sql
	#--predict-output
	def chekPred(self):
		sqlPred = self.chkPred_var.get()
		if sqlPred == "on" :
			pred_sql= " --predict-output"
		else:
			pred_sql= ''
		return pred_sql
	#--keep-alive
	def chekKeep(self):
		sqlKeep = self.chkKeep_var.get()
		if sqlKeep == "on" :
			keep_sql= " --keep-alive"
		else:
			keep_sql= ''
		return keep_sql
	#--null-connection
	def chekNull(self):
		sqlNull = self.chkNull_var.get()
		if sqlNull == "on" :
			null_sql= " --null-connection"
		else:
			null_sql= ''
		return null_sql

	# text only
	def chekTxt(self):
		sqlTxt = self.chk_Txt_var.get()
		if sqlTxt == "on" :
			txt_sql= " --text-only"
		else:
			txt_sql= ''
		return txt_sql
	# -Title
	def chekTit(self):
		sqlTit = self.chk_Tit_var.get()
		if sqlTit == "on" :
			tit_sql= " --titles"
		else:
			tit_sql= ''
		return tit_sql
	# --batch
	def chekBatch(self):
		sqlBatch = self.chk_Batch_var.get()
		if sqlBatch == "on" :
			batch_sql= " --batch"
		else:
			batch_sql= ''
		return batch_sql
	 #--HEX
	def chekHex(self):
		sqlHex = self.chk_Hex_var.get()
		if sqlHex == "on" :
			hex_sql= " --hex"
		else:
			hex_sql= ''
		return hex_sql
	# -b --Banner
	def chekBanner(self):
		sqlBanner = self.chk_Banner_var.get()
		if sqlBanner == "on" :
			banner_sql= " --banner"
		else:
			banner_sql= ''
		return banner_sql

	#-f, --fingerprint
	def chekFing(self):
		sqlFing = self.chk_fing_var.get()
		if sqlFing == "on" :
			fing_sql= " --fingerprint"
		else:
			fing_sql= ''
		return fing_sql

	# DBMS
	def chek_dbms(self, *args):
		sql_dbms = self.chk_dbms_var.get()
		if sql_dbms == "on" :
			self.box.config(state = 'readonly')
			sqlDB = " --dbms="+self.box_value.get()
		else:
			self.box.config(state = 'disabled')
			sqlDB = ""
		return sqlDB
	#-p
	def chekParam(self):
		sqlParam = self.chkParam_var.get()
		if sqlParam == "on" :
			param_sql= ' -p "'+self.entryParam.get()+'"'
		else:
			param_sql= ''
		return    param_sql
	#Level
	def chek_level(self, *args):
		sql_level= self.chk_level_var.get()
		if sql_level == "on" :
			self.box_level.config(state = 'readonly')
			level_sql = " --level="+self.box_level_value.get()
		else:
			self.box_level.config(state = 'disabled')
			level_sql = ""
		return level_sql
	# Risk
	def chek_risk(self, *args):
		sql_risk= self.chk_risk_var.get()
		if sql_risk == "on" :
			self.box_risk.config(state = 'readonly')
			risk_sql = " --risk="+self.box_risk_value.get()
		else:
			self.box_risk.config(state = 'disabled')
			risk_sql = ""
		return risk_sql
	# VERBOSE LEVEL Func
	def chek_verb(self, *args):
		sql_verb= self.chk_verb_var.get()
		if sql_verb == "on" :
			self.box_verb.config(state = 'readonly')
			verb_sql = " -v "+self.box_verb_value.get()
		else:
			self.box_verb.config(state = 'disabled')
			verb_sql = ""
		return verb_sql
	# Threads chek_thr
	def chek_thr(self, *args):
		sql_thr= self.chk_thr_var.get()
		if sql_thr == "on" :
			self.thr.config(state = 'normal')
			thr_sql = ' --threads="'+self.thr_value.get()+'"'
		else:
			self.thr.config(state = 'disabled')
			thr_sql = ""
		return thr_sql
	# Tec
	def chek_tech(self, *args):
		sql_tech= self.chk_tech_var.get()
		if sql_tech == "on" :
			self.boxInj.config(state = 'normal')
			tech_sql= " --technique="+self.boxInj_value.get()
		else:
			self.boxInj.config(state = 'disabled')
			tech_sql = ""
		return tech_sql
	# tamper
	def chek_tam(self, *args):
		sel = self.Ltamper.curselection()
		if 0 < len(sel):
			tam_sql= " --tamper "+'"'+','.join([self.Ltamper.get(x) for x in sel])+'"'
		else:
			tam_sql = ""
		return tam_sql
	# log viewer
	def sqlmap(self, *args):
		load_url = self.urlentry.get()
                if 'http' not in load_url:
                    load_url='http://'+load_url
		load_host = urlparse(load_url).netloc
		text = open(r"./output/"+load_host+"/log", 'r').readlines()
		pattern = re.compile(r'(?m)(^sqlmap(.*)|^---$|^Place:(.*)|^Parameter:(.*)|\s{4,}Type:(.*)|\s{4,}Title:(.*)|\s{4,}Payload:(.*)|\s{4,}Vector:(.*))$', re.DOTALL)
		mode = os.O_CREAT | os.O_TRUNC
		f = os.open(r"./output/"+load_host+"/gui_log", mode)
		os.close(f)
		for x in text:
			qq = pattern.sub('', x).strip("\n")
			if len(qq) > 4:
				mode = os.O_WRONLY | os.O_APPEND
				f = os.open(r"./output/"+load_host+"/gui_log", mode)
				os.write(f,qq+'\n')
				os.close(f)
	# load log whitout query
	def logs(self, *args):
		load_url = self.urlentry.get()
                if 'http' not in load_url:
                    load_url='http://'+load_url
		load_host = urlparse(load_url).netloc
		self.sesTXT.delete("1.0",END)
		# highlight it
		s = ['available databases', 'Database:', 'Table:', '[', ']', '|' ]
		try:
			log_size = os.path.getsize("./output/"+load_host+"/log")
			if log_size != 0:
				self.sqlmap()
				self.sesTXT.insert(END, open(r"./output/"+load_host+"/gui_log", 'r').read())
				self.sesTXT.mark_set(INSERT, '1.0')
				for tagz in s:
					idx = '1.0'
					while 1:
						idx = self.sesTXT.search(tagz, idx, nocase=1, stopindex=END)
						if not idx: break
						lastidx = '%s+%dc' % (idx, len(tagz))
						self.sesTXT.tag_add('found', idx, lastidx)
						idx = lastidx
						self.sesTXT.tag_config('found', foreground='green')
						self.sesTXT.focus()
			else:
				self.sesTXT.insert(END, u"Log-Empty "+load_host+".")
		except (IOError,OSError):
			self.sesTXT.insert(END, u"Log-Not-Found "+load_host+".")
		return
	def session(self):
		load_url = self.urlentry.get()
                if 'http' not in load_url:
                    load_url='http://'+load_url
		load_host = urlparse(load_url).netloc
		self.sesTXT.delete("1.0",END)
		try:
			session_size = os.path.getsize("./output/"+load_host+"/session")
			if session_size != 0:
				self.sesTXT.insert(END, open(r"./output/"+load_host+"/session", 'r').read())
				self.sesTXT.mark_set(INSERT, '1.0')
				self.sesTXT.focus()
			else:
				self.sesTXT.insert(END, u"Session-File-Empty "+load_host+".")
		except (IOError,OSError):
			self.sesTXT.insert(END, u"Session-File-Not-Found "+load_host+".")
		return
	# cur-t user
	def chekCurrent_user(self):
		sqlCurrent_user = self.chkCurrent_user_var.get()
		if sqlCurrent_user == "on" :
			current_user_sql= ' --current-user'
		else:
			current_user_sql= ''
		return current_user_sql
	# cur-t db:
	def chekCurrent_db(self):
		sqlCurrent_db = self.chkCurrent_db_var.get()
		if sqlCurrent_db == "on" :
			current_db_sql= ' --current-db'
		else:
				current_db_sql= ''
		return current_db_sql
	# dba
	def chek_is_dba(self):
		sql_is_dba = self.chk_is_dba_var.get()
		if sql_is_dba == "on" :
			is_dba_sql= ' --is-dba'
		else:
			is_dba_sql= ''
		return is_dba_sql
	# users
	def chek_users(self):
		sql_users = self.chk_users_var.get()
		if sql_users == "on" :
			users_sql= ' --users'
		else:
			users_sql= ''
		return users_sql
	# pas
	def chek_passwords(self):
		sql_passwords = self.chk_passwords_var.get()
		if sql_passwords == "on" :
			passwords_sql= ' --passwords'
		else:
			passwords_sql= ''
		return passwords_sql
	# priv
	def chek_privileges(self):
		sql_privileges = self.chk_privileges_var.get()
		if sql_privileges == "on" :
			privileges_sql= ' --privileges'
		else:
			privileges_sql= ''
		return privileges_sql
	# roles
	def chek_roles(self):
		sql_roles = self.chk_roles_var.get()
		if sql_roles == "on" :
			roles_sql= ' --roles'
		else:
			roles_sql= ''
		return roles_sql
	# dbs
	def chek_dbs(self):
		sql_dbs = self.chk_dbs_var.get()
		if sql_dbs == "on" :
			dbs_sql= ' --dbs'
		else:
			dbs_sql= ''
		return dbs_sql
	# tbl
	def chek_tables(self):
		sql_tables = self.chk_tables_var.get()
		if sql_tables == "on" :
			tables_sql= ' --tables'
		else:
			tables_sql= ''
		return tables_sql
	# clmn
	def chek_columns(self):
		sql_columns = self.chk_columns_var.get()
		if sql_columns == "on" :
			columns_sql= ' --columns'
		else:
			columns_sql= ''
		return columns_sql
	# schema
	def chek_schema(self):
		sql_schema = self.chk_schema_var.get()
		if sql_schema == "on" :
			schema_sql= ' --schema'
		else:
			schema_sql= ''
		return schema_sql
	# count
	def chek_count(self):
		sql_count = self.chk_count_var.get()
		if sql_count == "on" :
			count_sql= ' --count'
		else:
			count_sql= ''
		return count_sql
	# --dump
	def chek_dump(self):
		sql_dump = self.chk_dump_var.get()
		if sql_dump == "on" :
			dump_sql= ' --dump'
		else:
			dump_sql= ''
		return dump_sql
	# --dump-all
	def chek_dump_all(self):
		sql_dump_all = self.chk_dump_all_var.get()
		if sql_dump_all == "on" :
			dump_all_sql= ' --dump-all'
		else:
			dump_all_sql= ''
		return dump_all_sql
	# --dump-all
	def chek_exclude(self):
		sql_exclude = self.chk_exclude_var.get()
		if sql_exclude == "on" :
			exclude_sql= ' --exclude-sysdbs'
		else:
			exclude_sql= ''
		return exclude_sql
	# --search
	def chek_search(self):
		sql_search = self.chk_search_var.get()
		if sql_search == "on" :
			search_sql= ' --search'
		else:
			search_sql= ''
		return search_sql
	# -D
	def chekD(self):
		sqlD = self.chkD_var.get()
		if sqlD == "on" :
			D_sql= ' -D "'+self.entryD.get()+'"'
		else:
			D_sql= ''
		return    D_sql
	#-T TBL
	def chekT(self):
		sqlT = self.chkT_var.get()
		if sqlT == "on" :
			T_sql= ' -T "'+self.entryT.get()+'"'
		else:
			T_sql= ''
		return    T_sql
	#-C COL
	def chekC(self):
		sqlC = self.chkC_var.get()
		if sqlC == "on" :
			C_sql= ' -C "'+self.entryC.get()+'"'
		else:
			C_sql= ''
		return    C_sql
	# --start limit
	def chek_start(self):
		sql_start= self.chk_start_var.get()
		if sql_start == "on" :
			start_sql= ' --start="'+self.entry_start.get()+'"'
		else:
			start_sql= ''
		return start_sql
	# --stop limit
	def chek_stop(self):
		sql_stop= self.chk_stop_var.get()
		if sql_stop == "on" :
			stop_sql= ' --stop="'+self.entry_stop.get()+'"'
		else:
			stop_sql= ''
		return stop_sql
	# --first limit
	def chek_first(self):
		sql_first= self.chk_first_var.get()
		if sql_first == "on" :
			first_sql= ' --first="'+self.entry_first.get()+'"'
		else:
			first_sql= ''
		return first_sql
	# --last limit
	def chek_last(self):
		sql_last = self.chk_last_var.get()
		if sql_last == "on" :
			last_sql= ' --last="'+self.entry_last.get()+'"'
		else:
			last_sql= ''
		return last_sql
	# sqlmap:
	def commands(self):
		target = ' -u "'+self.urlentry.get()+'"'
		z_param = ' --random-agent'
		inject = target+self.chekParam()+z_param+self.chek_tam()+ \
		        self.chekFile()+self.chekQuery()+self.chekdata()+ \
		        self.chek_level()+self.chek_risk()+self.chekTit()+self.chekHex()+ \
		        self.chekTxt()+self.chekCode()+self.chekReg()+self.chekStr()+ \
		        self.chekSec()+self.chek_tech()+self.chekOpt()+self.chekPred()+ \
		        self.chekKeep()+self.chekNull()+self.chek_thr()+self.chek_dbms()+ \
		        self.chekCol()+self.chekChar()+self.chekCook()+self.chekPrefix()+ \
		        self.chekSuffix()+self.chekOS()+self.chekSkip()+ self.chekNeg()+ \
		        self.chekBatch()+self.chekCurrent_user()+self.chekCurrent_db()+ \
		        self.chek_is_dba()+self.chek_users()+self.chek_passwords()+ \
		        self.chek_privileges()+self.chek_roles()+self.chek_dbs()+ \
		        self.chek_tables()+self.chek_columns()+self.chek_schema()+ \
		        self.chek_count()+self.chek_dump()+self.chek_dump_all()+ \
		        self.chek_search()+self.chekD()+self.chekT()+self.chekC()+ \
		        self.chek_exclude()+self.chek_start()+self.chek_stop()+ \
		        self.chek_first()+self.chek_last()+self.chek_verb()+ \
		        self.chekFing() + self.chekBanner()
		self.sql_var.set(inject)
	# GOGO!!!
	def injectIT(self):
		if (os.name == "posix"):
			cmd = "xterm -hold -e python sqlmap.py" + self.sqlEdit.get()
		else:
			cmd = "start cmd /k python sqlmap.py" + self.sqlEdit.get()
		#Write last target
		mode = os.O_TRUNC | os.O_WRONLY
		fwr = os.open(r"./last.uri", mode)
		os.write(fwr,self.urlentry.get())
		os.close(fwr)
		subprocess.Popen(cmd, shell = True)
	# CopyPasteCut
	def rClicker(self, e):
		try:
			def rClick_Copy(e, apnd=0):
				e.widget.event_generate('<Control-c>')

			def rClick_Cut(e):
				e.widget.event_generate('<Control-x>')

			def rClick_Paste(e):
				e.widget.event_generate('<Control-v>')

			e.widget.focus()
			nclst=[
				(' Cut', lambda e=e: rClick_Cut(e)),
				(' Copy', lambda e=e: rClick_Copy(e)),
				(' Paste', lambda e=e: rClick_Paste(e)),
				]
			rmenu = Menu(None, tearoff=0, takefocus=0)

			for (txt, cmd) in nclst:
				rmenu.add_command(label=txt, command=cmd)

			rmenu.tk_popup(e.x_root+40, e.y_root+10,entry="0")
		except TclError:
			pass
		return "break"

	def rClickbinder(self):
		try:
			for b in [ 'Text', 'Entry', 'Listbox', 'Label']:
				self.bind_class(b, sequence='<Button-3>', func = self.rClicker, add='')
		except TclError:
			pass
#-----------------------------------------
def main():
	root = Tk()
	s = ttk.Style()
	s.theme_use('clam')
	root.title(u'sqm---RootsSecurityTeam')
	root.rowconfigure(0, weight=1)
	root.columnconfigure(0, weight=1)
	appl = app(mw=root)
	appl.mainloop()
#-----------------------------------------
if __name__ == '__main__':
	main()
