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

	def initialize
		@gsession 		= GoogleDrive::Session.from_service_account_key("client_secret.json");
		@spreadsheet 	= @gsession.spreadsheet_by_title("telebot_ssi_modb");
		@orain			= @spreadsheet.worksheets.first;
		@myin			= @spreadsheet.worksheets[1];
		@teletoken 		= '1063487728:AAE6TEMGGgxntgZr-DDtb5bitvFG1PeAvh4';
	end

	def bot_hello(username)
		return "Hello om #{username}"
	end

	def bot_flip(username)
		if (rand(1..100) % 2 == 0)
			return "om #{username} get *Tail*"
		else
			return "om #{username} get *Head*"
		end
	end

	def bot_about
		str = "`/hello`
		- patrick will say hello
		`/oradb` 
		- get oracle db info ex: /db OPDB
		`/oradblist`
		- get oracledb list in hostname ex: /dblist exadata
		`/orahosts` 
		- show all oracle hostname ex: /orahost
		`/oracat`
		- get oracle category ex: /oracat
		`/mydb`
		- get mysql db info ex: /mydb appname
		`/mydblist`
		- get mysql db list on hostname ex: /mydblist hostname 
		`/mydbhosts` 
		- get mysql hostname list ex: /myhosts
		`/flip` 
		- head or tails ?
		`/about` - this message
		Created on 2 Dec 2019, with RUBY gem\n Last update: 2019-12-06 +7 BETA"
		return str
	end
	### oracle ###
	def bot_oradb(search)
		str = ''
		i = 0
		@orain.rows.each{|row|
			if row[0].upcase.include?(search.upcase)  
				str += "\n##{i+=1})DBNAME: #{row[0]}\nHOSTNAME: #{row[1]}\nIP: #{row[2]}\nCAT: #{row[3]}\nPIC: #{row[4]}\nDB.ver: ORACLE #{row[7]}\nAPP: #{row[8]}\nCREATED: #{row[9]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_oradblist(search)
		str = '';
		i=0
		@orain.rows.each{|row|
			if row[1].upcase.include?(search.upcase)  
				str += "##{i+=1}|#{row[0]}|#{row[3]}|#{row[1]}|#{row[4]}|#{row[8]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_orahosts
		hosts=[]
		str="";
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
		str = ''
		i = 0
		@myin.rows.each{|row|
			if row[0].upcase.include?(search.upcase)  
				str += "\n##{i+=1})APP: #{row[0]}\nHOSTNAME: #{row[1]}\nIP: #{row[2]}\nCAT: #{row[3]}\nPIC: #{row[4]}\nDB.ver: #{row[7]}\nNOTE: #{row[9]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_mydblist(search)
		str = '';
		i=0
		@myin.rows.each{|row|
			if row[1].upcase.include?(search.upcase)  
				str += "##{i+=1}|#{row[0]}|#{row[3]}|#{row[6]}\n";
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def bot_myhosts(search)
		hosts=[]
		str='';
		@myin.rows.each{|row|
			h=row[1]+":"+row[2]
			if (h.upcase.include?(search.upcase))
				hosts.push(row[1]+":"+row[2]);
			end
		}
		i=0
		hosts.uniq.each{|host|
			str+= "##{i+=1}|#{host}\n " 
		}
		#return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
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
			if row[3].upcase.include?(search.upcase)  
				str += "#{i+=1})#{row[0]}\n"
			end
		}
		return "#{search} tidak ditemukan di invetory" if str=='' || str.size <= 0
		return "query ditemukan #{i}, mohon didetailkan lagi" if str.size >= 4096
		return str
	end

	def message_filter(message,bot)
		case message
		when Telegram::Bot::Types::CallbackQuery
			puts "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|REQUEST|#{message.from.username}|#{message.from.first_name}|#{message.message.chat.id}|#{message.message.chat.title}|#{message.message.chat.type}|#{message.message.text}"
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
		when Telegram::Bot::Types::Message
			puts "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|REQUEST|#{message.from.username}|#{message.from.first_name}|#{message.chat.id}|#{message.chat.title}|#{message.chat.type}|#{message.text}"
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
			when /^\/orahosts/, /^\/orahosts@oramodb_ssi_bot/
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_orahosts} ```")
			when /^\/oracat/,/^\/oracat@oramodb_ssi_bot/
				markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: self.bot_oracat_key,one_time_keyboard: true)
				bot.api.send_message(chat_id: message.chat.id, text: 'Pilih Kategori ORACLE', reply_markup: markup)
			when /^\/mydb (.+)/, /^\/mydb@oramodb_ssi_bot (.+)/
				search = $1
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_mydb(search)} ```")
			when /^\/mydblist (.+)/, /^\/mydblist@oramodb_ssi_bot (.+)/
				search = $1
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_mydblist(search)} ```")
			when /^\/mydbhosts (.+)/, /^\/mydbhosts@oramodb_ssi_bot (.+)/
				search = $1
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{self.bot_myhosts(search)} ```")
			when /^\/mydbcat (.+)/,/^\/mydbcat@oramodb_ssi_bot (.+)/
				puts "#{Time.new.strftime("%Y-%m-%d %H:%M:%S")}|REQUEST|#{message.text}";
				markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: self.bot_mycat_key,one_time_keyboard: true)
				bot.api.send_message(chat_id: message.chat.id, text: 'Pilih Kategori MYSQL', reply_markup: markup)
			end
		end
			
	end

	def start
		Telegram::Bot::Client.run(@teletoken) do |bot|
			bot.listen do |message|
				begin
					self.message_filter(message,bot)
				rescue Telegram::Bot::Exceptions::ResponseError => e
					bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "ERROR: #{e.to_s}")
				rescue Exception => e
					bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "error: try again")
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