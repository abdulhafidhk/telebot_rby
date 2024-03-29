#!/usr/bin/env ruby
require 'telegram/bot'
require 'bundler'
Bundler.require

class Mainbot
	@gsession
	@spreadsheet
	@orain
	@myin
	@teletoken
	@filelog
	@whitelist

	def initialize
		@gsession 		= GoogleDrive::Session.from_service_account_key("client_secret.json");
		@spreadsheet 	= @gsession.spreadsheet_by_title("telebot_ssi_modb");
		@orain			= @spreadsheet.worksheets.first;
		@myin			= @spreadsheet.worksheets[1];
		@postgre		= @spreadsheet.worksheets[2];
		@whitelist		= @spreadsheet.worksheets[3];
		@issuelog		= @spreadsheet.worksheets[4];
		@teletoken 		= '1063487728:AAE6TEMGGgxntgZr-DDtb5bitvFG1PeAvh4';
		@filelog		= File.open('log.txt','a');
	end

	def bot_hello(username)
		return "Hello om #{username}"
	end
	
	def bot_exa()
		return "
		exa 42
scan```
10.250.193.107
10.250.193.105
10.250.193.106```
vip
node 1 = `10.250.193.103`
node 2 = `10.250.193.104`
---------------------------
exapdb62a-scan
scan```
10.49.3.202
10.49.3.201
10.49.3.203```
vip
node 1 = `10.49.3.197`
node 2 = `10.49.3.198`
---------------------------
exapdb62a-scan
scan```
10.49.3.205
10.49.3.204
10.49.3.206```
vip
node 1 = `10.49.3.199`
node 2 = `10.49.3.200`
---------------------------
exaimcpdb-scan
scan```
10.53.71.166
10.53.71.165
10.53.71.167```
vip 
node 1 = `10.53.71.163`
node 2 = `10.53.71.164`
---------------------------
exapdb62tbsa-scan
scan```
10.39.64.135
10.39.64.134
10.39.64.133```
vip
node 1 = `10.39.64.131`
node 2 = `10.39.64.132`
---------------------------
exa62bsda-scan
scan```
10.54.128.133
10.54.128.135
10.54.128.134```
vip
node 1 = `10.54.128.131`
node 2 = `10.54.128.132`"
	end

	def bot_flip(username)
		if (rand(1..100) % 2 == 0)
			return "om #{username} get *Tail*"
		else
			return "om #{username} get *Head*"
		end
	end

	def bot_about
		str = "hello - say hello
oradb - ex: /db OPDB
oradblist - ex: /dblist exadata
orahosts - hostname list ex: /orahost
oraapp - search with app name ex: /oraapp crm
mydb - ex: /mydb appname
mydblist - dblist on hostname ex: /mydblist hostname 
mydbhosts - hostname list ex: /myhosts
pdb - search postgress db by hostname
phost - search postgress host
papp - search postgress db by app name
exalist - exadata scan & vip list
issueoracle - insert new issue with format service;description;severity;date(optional)
issuepost - insert new issue with format service;description;severity;date(optional)
issuemysql - insert new issue with format service;description;severity;date(optional)
issueinfra - insert new issue with format service;description;severity;date(optional)
issueprint - print issue today or by date ex: /issueprint 2022-02-02
issueclose - print issue today or by date ex: /issueclose ticket0001
issueremove - print issue today or by date ex: /issueremove ticket0001
issueview - detail view by ticket number ex: /issueview ticket0001
flip - head or tails ?
about - this bot
		Created on 2 Dec 2019, with RUBY gem\n Last update: 2022-02-05"
		return str
	end
	### oracle ###
	def bot_oradb(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = ''
		i = 0;
		@orain = @spreadsheet.worksheets.first;
		@orain.rows.each{|row|
			if row[0].upcase.include?(search.upcase)  
				str += "\n##{i+=1})DBNAME: #{row[0]}\nHOSTNAME: #{row[1]}\nIP: #{row[2]}\nCAT: #{row[3]}\nPIC: #{row[5]}\nDB.ver: ORACLE #{row[12]}\nAPP: #{row[4]}\nCREATED: #{row[16]}\nContact:#{row[6]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_oradblist(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = '';
		i=0;
		@orain = @spreadsheet.worksheets.first;
		@orain.rows.each{|row|
			if row[1].upcase.include?(search.upcase)  
				str += "##{i+=1}|#{row[0]}|#{row[3]}|#{row[1]}|#{row[3]}|#{row[12]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_oraapp(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = '';
		i=0;
		@orain = @spreadsheet.worksheets.first;
		@orain.rows.each{|row|
			if row[4].upcase.include?(search.upcase)  
				str += "##{i+=1}|#{row[0]}|#{row[3]}|#{row[1]}|#{row[4]}|#{row[10]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_orahosts
		hosts=[];
		str="";
		@orain = @spreadsheet.worksheets.first;
		@orain.rows.each{|row|
			if !(hosts.include?(row[1]+":"+row[2]))
				hosts.push(row[1]+":"+row[2]);
			end
		}
		i=0
		hosts.uniq.each{|host|
			str+= "##{i+=1}|#{host}\n" 
		}
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end
	### mysql ### 
	def bot_mydb(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = '';
		i = 0;
		@myin = @spreadsheet.worksheets[1];
		@myin.rows.each{|row|
			if row[7].upcase.include?(search.upcase)  
				str += "\n##{i+=1})APP: #{row[7]}\nHOSTNAME: #{row[0]}\nIP: #{row[1]} : #{row[2]}\nCAT: #{row[8]}\nPIC: #{row[9]}\nDB.ver: #{row[4]}\nNOTE: #{row[10]}, #{row[11]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_mydblist(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = '';
		i=0;
		@myin = @spreadsheet.worksheets[1];
		@myin.rows.each{|row|
			if row[7].upcase.include?(search.upcase)  
				str += "##{i+=1}|#{row[7]}|#{row[0]}|#{row[1]}:#{row[2]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_myhosts(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		hosts=[]
		str='';
		@myin = @spreadsheet.worksheets[1];
		@myin.rows.each{|row|
			h=row[0]+":"+row[2]
			if (h.upcase.include?(search.upcase))
				hosts.push("("+row[7]+")"+row[1]+":"+row[2]);
			end
		}
		i=0
		hosts.uniq.each{|host|
			str+= "##{i+=1}|#{host}\n " 
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_oracat_key
		kb = [
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Critical', callback_data: 'BC'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Mission Critical', callback_data: 'MC'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Support', callback_data: 'BS'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Important', callback_data: 'BI'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Mission Critical Business Critical', callback_data: 'MCBC')
		]
		return kb
	end

	def bot_mycat_key
		kb = [
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Critical', callback_data: 'MYBC'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Mission Critical', callback_data: 'MYMC'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Support', callback_data: 'MYBS'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Important', callback_data: 'MYBI'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Important/Business Support', callback_data: 'MYBIBS'),
		  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Mission Critical Business Critical', callback_data: 'MYMCBC')
		]
		return kb
	end

	###POSTGRESS###
	def bot_post(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = ''
		i = 0
		@postgre = @spreadsheet.worksheets[2];
		@postgre.rows.each{|row|
			if row[1].upcase.include?(search.upcase) || row[11].upcase.include?(search.upcase)  
				str += "\n##{i+=1})APP: #{row[11]}\nHOSTNAME: #{row[1]}\nIP: #{row[3]}:#{row[6]}\nCAT: #{row[13]}\nPIC: #{row[14]}\nDB.ver: #{row[7]}\nNOTE: #{row[5]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_postlist(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		str = '';
		i=0;
		@postgre = @spreadsheet.worksheets[2];
		@postgre.rows.each{|row|
			if row[1].upcase.include?(search.upcase)  
				str += "##{i+=1}|#{row[1]}|#{row[3]}:#{row[6]}|#{row[5]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_postapp(search)
		return "command butuh parameter " if search.size <=0 || search == ""
		hosts=[];
		str='';
		@postgre = @spreadsheet.worksheets[2];
		@postgre.rows.each{|row|
			if (row[11].upcase.include?(search.upcase))
				hosts.push(row[11]+"|"+row[1]+"|"+row[3]+":"+row[6]);
			end
		}
		i=0
		hosts.uniq.each{|host|
			str+= "##{i+=1}|#{host}\n " 
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end


	def bot_getoracat(search)
		str = ''
		i=0
		@orain.rows.each{|row|
			if row[3].upcase.include?(search.upcase)  
				str += "#{i+=1})#{row[0]}\n"
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_getmycat(search)
		str = ''
		i=0
		@myin.rows.each{|row|
			if row[8].upcase.include?(search.upcase)  
				str += "#{i+=1})#{row[7]}-#{row[0]}\n"
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end
	
	def logging(str)
	#@filelog.puts str
	puts str
	end
	
	def whitelist?(username)
		return false if username.empty?
		#return true if username == "abdulhk"
		@whitelist = @spreadsheet.worksheets[3];
		@whitelist.rows.each{|row|
			return true if row[0].upcase == username.upcase
		}
		return false
	end
	
	def whitelist_user()
		str = ''
		i=1
		@whitelist.rows.each{|row|
			str += "#{i+=1}) #{row}\n"
		}
		return str
	end
	
	def issueoracle(message,firstname)
		@issuelog.reload;
		submittime = Time.now + 7*60*60;
		arrtext	= message.split(";");
		return "issue is not submited, format is `tittle;description;severity;date open (optional)`" if arrtext.size <3;
		title 	= arrtext[0];
		desc 	= arrtext[1];
		sev 	= arrtext[2];
		date	= submittime.strftime("%Y-%m-%d %H:%M:%S"); 
		date	= arrtext[3] if arrtext.size >= 4;
		ticket 	= "TSORC"+Time.now.strftime("%Y%m%d%H")+"#{@issuelog.num_rows}";
		result 	= "Ticket=#{ticket}\nService = #{title}\nDesc = #{desc}\nSeverity = #{sev.upcase}\nOpen = #{date}\nRequest = #{firstname}";
		#sheetrow=["#{ticket}","","#{title}","#{desc}","OPEN","#{sev}","#{date}","#{date}","#{firstname}"];
		sheetrows=@issuelog.num_rows+1;
		@issuelog[sheetrows,1] = ticket.upcase;
		@issuelog[sheetrows,3] = title;
		@issuelog[sheetrows,4] = desc;
		@issuelog[sheetrows,5] = "OPEN";
		@issuelog[sheetrows,6] = sev.upcase;
		@issuelog[sheetrows,7] = date;
		@issuelog[sheetrows,8] = date;
		@issuelog[sheetrows,11] = firstname;
		@issuelog[sheetrows,12] = "BOT";
		@issuelog.save;
		return result;
	end

	def issuepost(message,firstname)
		@issuelog.reload;
		submittime = Time.now + 7*60*60;
		arrtext	= message.split(";");
		return "issue is not submited, format is `tittle;description;severity;date open (optional)`" if arrtext.size <3;
		title 	= arrtext[0];
		desc 	= arrtext[1];
		sev 	= arrtext[2];
		date	= submittime.strftime("%Y-%m-%d %H:%M:%S"); 
		date	= arrtext[3] if arrtext.size >= 4;
		ticket 	= "TSPOS"+Time.now.strftime("%Y%m%d%H")+"#{@issuelog.num_rows}";
		result 	= "Ticket=#{ticket}\nService = #{title}\nDesc = #{desc}\nSeverity = #{sev.upcase}\nOpen = #{date}\nRequest = #{firstname}";
		#sheetrow=["#{ticket}","","#{title}","#{desc}","OPEN","#{sev}","#{date}","#{date}","#{firstname}"];
		sheetrows=@issuelog.num_rows+1;
		@issuelog[sheetrows,1] = ticket.upcase;
		@issuelog[sheetrows,3] = title;
		@issuelog[sheetrows,4] = desc;
		@issuelog[sheetrows,5] = "OPEN";
		@issuelog[sheetrows,6] = sev.upcase;
		@issuelog[sheetrows,7] = date;
		@issuelog[sheetrows,8] = date;
		@issuelog[sheetrows,11] = firstname;
		@issuelog[sheetrows,12] = "BOT";
		@issuelog.save;
		return result;
	end
	
	def issuemysql(message,firstname)
		@issuelog.reload;
		submittime = Time.now + 7*60*60;
		arrtext	= message.split(";");
		return "issue is not submited, format is `tittle;description;severity;date open (optional)`" if arrtext.size <3;
		title 	= arrtext[0];
		desc 	= arrtext[1];
		sev 	= arrtext[2];
		date	= submittime.strftime("%Y-%m-%d %H:%M:%S"); 
		date	= arrtext[3] if arrtext.size >= 4;
		ticket 	= "TSMYS"+Time.now.strftime("%Y%m%d%H")+"#{@issuelog.num_rows}";
		result 	= "Ticket=#{ticket}\nService = #{title}\nDesc = #{desc}\nSeverity = #{sev.upcase}\nOpen = #{date}\nRequest = #{firstname}";
		#sheetrow=["#{ticket}","","#{title}","#{desc}","OPEN","#{sev}","#{date}","#{date}","#{firstname}"];
		sheetrows=@issuelog.num_rows+1;
		@issuelog[sheetrows,1] = ticket.upcase;
		@issuelog[sheetrows,3] = title;
		@issuelog[sheetrows,4] = desc;
		@issuelog[sheetrows,5] = "OPEN";
		@issuelog[sheetrows,6] = sev.upcase;
		@issuelog[sheetrows,7] = date;
		@issuelog[sheetrows,8] = date;
		@issuelog[sheetrows,11] = firstname;
		@issuelog[sheetrows,12] = "BOT";
		@issuelog.save;
		return result;
	end

	def issueinfra(message,firstname)
		@issuelog.reload;
		submittime = Time.now + 7*60*60;
		arrtext	= message.split(";");
		return "issue is not submited, format is `tittle;description;severity;date open (optional)`" if arrtext.size <3;
		title 	= arrtext[0];
		desc 	= arrtext[1];
		sev 	= arrtext[2];
		date	= submittime.strftime("%Y-%m-%d %H:%M:%S"); 
		date	= arrtext[3] if arrtext.size >= 4;
		ticket 	= "TSINF"+Time.now.strftime("%Y%m%d%H")+"#{@issuelog.num_rows}";
		result 	= "Ticket=#{ticket}\nService = #{title}\nDesc = #{desc}\nSeverity = #{sev.upcase}\nOpen = #{date}\nRequest = #{firstname}";
		#sheetrow=["#{ticket}","","#{title}","#{desc}","OPEN","#{sev}","#{date}","#{date}","#{firstname}"];
		sheetrows=@issuelog.num_rows+1;
		@issuelog[sheetrows,1] = ticket.upcase;
		@issuelog[sheetrows,3] = title;
		@issuelog[sheetrows,4] = desc;
		@issuelog[sheetrows,5] = "OPEN";
		@issuelog[sheetrows,6] = sev.upcase;
		@issuelog[sheetrows,7] = date;
		@issuelog[sheetrows,8] = date;
		@issuelog[sheetrows,11] = firstname;
		@issuelog[sheetrows,12] = "BOT";
		@issuelog.save;
		return result;
	end

	def issueprint(tanggal=nil)
		if tanggal.nil? || tanggal=="" then 
			submittime = Time.now + 7*60*60;
			tanggal=submittime.strftime("%Y-%m-%d");
		end
		str = "";
		@issuelog.reload;
		@issuelog.rows.each{|row|
			if row[6].upcase.include?(tanggal.upcase) and row[4].upcase == "OPEN" then
				str += "+ #{row[0]}|#{row[2]}|*#{row[4]}*|#{row[5]}|#{row[6]}|#{row[10]}\n";
			end
		}
		@issuelog.rows.each{|row|
			if row[6].upcase.include?(tanggal.upcase) and row[4].upcase == "CLOSE" then
				str += "- #{row[0]}|#{row[2]}|*#{row[4]}*|#{row[5]}|#{row[6]}|#{row[10]}\n";
			end
		}
		return "No Issue found at #{tanggal}" if str == "" ;
		return "Issue at #{tanggal}:\n"+str;
	end

	def issueview(ticket=nil)
		return "Input ticket number" if ticket.nil? || ticket=="" 
		str = "";
		@issuelog.reload;
		@issuelog.rows.each{|row|
			if row[0].upcase == ticket.upcase then
				str += "Ticket=#{row[0]}\nService = #{row[2]}\nDesc = #{row[3]}\nSeverity = #{row[5]}\nOpen = #{row[6]}\nClosed = #{row[8]}\nRequest = #{row[10]}\nStatus = #{row[4]}\n";
			end
		}
		return "No Issue found #{ticket}" if str == "" ;
		return str;
	end
	
	def issueclose(ticket=nil)
		return "Input ticket number" if ticket.nil? || ticket=="" 
		str = "";
		@issuelog.reload;
		@issuelog.rows.each_with_index {|row, rindex|
			if row[0].upcase == ticket.upcase then
				idx=rindex+1;
				submittime = Time.now + (7*60*60);
				@issuelog[idx,9] = submittime.strftime("%Y-%m-%d %H:%M:%S");
				@issuelog[idx,5] = "CLOSE";
				@issuelog.save;
				#str += "Ticket=#{row[0]}\nTitle = #{row[2]}\nDesc = #{row[3]}\nSeverity = #{row[5]}\nOpen = #{row[6]}\nClosed = #{row[8]}\nRequest = #{row[10]}\nStatus = #{row[4]}\n";
				str += "Ticket=#{row[0]}\nService = #{row[2]}\nDesc = #{row[3]}\nSeverity = #{row[5]}";
			end
		}
		return "No Issue found #{ticket}" if str == "" ;
		return "Issue Closed\n"+str;
	end
	
	def issuerem(ticket=nil)
		return "Input ticket number" if ticket.nil? || ticket=="" 
		str = "";
		@issuelog.reload;
		@issuelog.rows.each_with_index {|row, rindex|
			if row[0].upcase == ticket.upcase then
				#str += "Ticket=#{row[0]}\nTitle = #{row[2]}\nDesc = #{row[3]}\nSeverity = #{row[5]}\nOpen = #{row[6]}\nClosed = #{row[8]}\nRequest = #{row[10]}\nStatus = #{row[4]}\n";
				#idx = rindex+1
				#for i in 1..12 do
				#	@issuelog[idx,i]="";
				#end
				idx=rindex+1;
				submittime = Time.now + (7*60*60);
				@issuelog[idx,9] = submittime.strftime("%Y-%m-%d %H:%M:%S");
				@issuelog[idx,5] = "DELETED";
				@issuelog.save;
				str = "#{ticket}";
			end
		}
		return "No Issue found #{ticket}" if str == "" ;
		return "Issue deleted\n"+str;
	end

	def message_filter(message,bot)
		case message
		when Telegram::Bot::Types::CallbackQuery
			if whitelist?(message.from.username)
			then
			self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|REQUEST|#{message.from.username}|#{message.from.first_name}|#{message.message.chat.id}|#{message.message.chat.title}|#{message.message.chat.type}|#{message.message.text}")			
				case message.data
				#-------------------------------------------------
				# Oracle
				#-------------------------------------------------
				# Business Critical
				# Mission Critical
				# Business Support
				# Business Important
				# Mission Critical Business Critical
				when 'BC'
					search = 'Business Critical'
					#puts message.message.inspect;
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getoracat(search)} ```")
				when 'MC'
					search = 'Mission Critical'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getoracat(search)} ```")
				when 'BS'
					search = 'Business Support'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getoracat(search)} ```")
				when 'BI'
					search = 'Business Important'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getoracat(search)} ```")
				when 'MCBC'
					search = 'Mission Critical Business Critical'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getoracat(search)} ```")
				#-------------------------------------------------
				# MYSQL
				#-------------------------------------------------
				#BIBS
				#Business Critical
				#Business Important
				#Business Support
				#MCBC
				#Mission Critical
				when 'MYBIBS'
					search='BIBS'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getmycat(search)} ```")
				when 'MYBC'
					search='Business Critical'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getmycat(search)} ```")
				when 'MYBI'
					search='Business Important'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getmycat(search)} ```")
				when 'MYBS'
					search='Business Support'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getmycat(search)} ```")
				when 'MYMCBC'
					search='MCBC'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getmycat(search)} ```")
				when 'MYMC'
					search='Mission Critical'
					bot.api.editMessageReplyMarkup(chat_id:message.message.chat.id,message_id:message.message.message_id,text: "#{search} picked",reply_markup: {inline_keyboard: []} )
					bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_getmycat(search)} ```")
				end
			else
				bot.api.send_message(chat_id: message.message.chat.id, parse_mode: 'markdown',text: "request diabaikan")
				self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|BLACKLIST|#{message.from.username}|#{message.from.first_name}|#{message.message.chat.id}|#{message.message.chat.title}|#{message.message.chat.type}|#{message.message.text}")
			end
		when Telegram::Bot::Types::Message
			if message.text.to_s.strip.empty?
			then 
				#bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: self.bot_hello(message.from.first_name))
				self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|NOTEXT|#{message.inspect.to_s}")
			else
				if self.whitelist?(message.from.username)
				then 
				self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|REQUEST|#{message.from.username}|#{message.from.first_name}|#{message.chat.id}|#{message.chat.title}|#{message.chat.type}|#{message.text}")
					case message.text.downcase
					when /^\/hello/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: self.bot_hello(message.from.first_name))
					when /^\/flip/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: self.bot_flip(message.from.first_name))
					when /^\/about/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: self.bot_about)
					when /^\/oradb (.+)/, /^\/oradb@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_oradb(search)} ```")
					when /^\/oradblist (.+)/, /^\/oradblist@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_oradblist(search)} ```")
					when /^\/oraapp (.+)/, /^\/oraapp@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_oraapp(search)} ```")
					when /^\/orahosts/, /^\/orahosts@oramodb_ssi_bot/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_orahosts} ```")
					#when /^\/oracat/,/^\/oracat@oramodb_ssi_bot/
					#	markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: self.bot_oracat_key,one_time_keyboard: true)
					#	bot.api.send_message(chat_id: message.chat.id, text: 'Pilih Kategori ORACLE', reply_markup: markup)
					when /^\/mydb (.+)/, /^\/mydb@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_mydb(search)} ```")
					when /^\/mydblist (.+)/, /^\/mydblist@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_mydblist(search)} ```")
					when /^\/mydbhosts (.+)/, /^\/mydbhosts@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_myhosts(search)} ```")
					#when /^\/mydbcat (.+)/,/^\/mydbcat@oramodb_ssi_bot(.+)/
					#	markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: self.bot_mycat_key,one_time_keyboard: true)
					#	bot.api.send_message(chat_id: message.chat.id, text: 'Pilih Kategori MYSQL', reply_markup: markup)
					when /^\/pdb (.+)/,/^\/pdb@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_post(search)} ```")
					when /^\/phost (.+)/,/^\/phost@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_postlist(search)} ```")
					when /^\/papp (.+)/,/^\/papp@oramodb_ssi_bot (.+)/
						search = $1
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_postapp(search)} ```")
					when /^\/whitelist/, /^\/whitelist@oramodb_ssi_bot/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.whitelist_user} ```")
					when /^\/exalist/, /^\/exalist@oramodb_ssi_bot/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.bot_exa}")
					when /^\/issueoracle (.+)/, /^\/issueoracle@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issueoracle($1,message.from.first_name)}")
					when /^\/issuepost (.+)/, /^\/issuepost@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issuepost($1,message.from.first_name)}")
					when /^\/issuemysql (.+)/, /^\/issuemysql@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issuemysql($1,message.from.first_name)}")
					when /^\/issueinfra (.+)/, /^\/issueinfra@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issueinfra($1,message.from.first_name)}")
					when /^\/issueprint (.+)/, /^\/issueprint@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issueprint($1)}")
					when /^\/issueprint/, /^\/issueprint@oramodb_ssi_bot/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issueprint()}")
					when /^\/issueview (.+)/, /^\/issueview@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issueview($1)}")
					when /^\/issueclose (.+)/, /^\/issueclose@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issueclose($1)}")
					when /^\/issueremove (.+)/, /^\/issueremove@oramodb_ssi_bot (.+)/
						bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "#{self.issuerem($1)}")
					end
				else
					bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "request diabaikan")
					self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|BLACKLIST|#{message.from.username}|#{message.from.first_name}|#{message.chat.id}|#{message.chat.title}|#{message.chat.type}|#{message.text}")
				end
			end
		end
			
	end

	def start
		Telegram::Bot::Client.run(@teletoken) do |bot|
			bot.listen do |message|
				begin
					self.message_filter(message,bot)
				rescue Telegram::Bot::Exceptions::ResponseError => e
					self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|error|#{e.to_s}|#{message.inspect}")
				rescue Exception => e
					self.logging("#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|ERROR|#{e.to_s}")
				end
			end 
		end 
	end
end

mybot = Mainbot.new
=begin
sample:
https://api.telegram.org/bot1063487728:AAE6TEMGGgxntgZr-DDtb5bitvFG1PeAvh4/sendMessage?chat_id=-261979504&text=hai+ganteng
puts mybot.bot_hello("me")
puts mybot.bot_flip("me")
puts mybot.bot_oradb("OPCMC")
puts mybot.bot_myhost("reflex")
=end
mybot.start