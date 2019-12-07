#!/usr/bin/env ruby
require 'telegram/bot'
require 'bundler'
Bundler.require

session 	= GoogleDrive::Session.from_service_account_key("client_secret.json");
spreadsheet = session.spreadsheet_by_title("telebot_ssi_modb");
inv			= spreadsheet.worksheets.first;
invm		= spreadsheet.worksheets[1];
token 		= '1063487728:AAE6TEMGGgxntgZr-DDtb5bitvFG1PeAvh4';


Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		case message
		###################### callback ##########################
		when Telegram::Bot::Types::CallbackQuery
			case message.data
			# Business Critical
			# Mission Critical
			# Business Support
			# Business Important
			# Mission Critical Business Critical
			when 'BC'
				search = 'Business Critical';
				str = ''
				i=0
				inv.rows.each{|row|
					#puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[3].upcase.include?(search.upcase)  
						str += "##{i+1}|#{row[0]}\n"
						i+=1;
					end
				}
				if(str == '')
					str = "cant found #{search} in inventory"
				end
				if(i > 30) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				puts message.inspect;
				# bot.api.editMessageReplyMarkup(chat_id:message.from.id,message_id:message.message.message_id,reply_markup: {inline_keyboard: []} )
				bot.api.send_message(chat_id: message.from.id, parse_mode: 'markdown',text: "``` #{str} ```");
			when 'MC'
				search = 'Mission Critical';
				str = ''
				i=0
				inv.rows.each{|row|
					#puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[3].upcase.include?(search.upcase)  
						str += "##{i+1}|#{row[0]}\n"
						i+=1;
					end
				}
				if(str == '')
					str = "cant found #{search} in inventory"
				end
				if(i > 30) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				puts message.inspect
				# bot.api.editMessageReplyMarkup(chat_id:message.from.id,message_id:message.message.message_id,reply_markup: {inline_keyboard: []} )
				bot.api.send_message(chat_id: message.from.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when 'BS'
				search = 'Business Support';
				str = ''
				i=0
				inv.rows.each{|row|
					#puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[3].upcase.include?(search.upcase)  
						str += "##{i+1}|#{row[0]}\n"
						i+=1;
					end
				}
				if(str == '')
					str = "cant found #{search} in inventory"
				end
				if(i > 30) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				puts message.inspect
				# bot.api.editMessageReplyMarkup(chat_id:message.from.id,message_id:message.message.message_id,reply_markup: {inline_keyboard: []} )
				bot.api.send_message(chat_id: message.from.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when 'BI'
				search = 'Business Important';
				str = ''
				i=0
				inv.rows.each{|row|
					#puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[3].upcase.include?(search.upcase)  
						str += "##{i+1}|#{row[0]}\n"
						i+=1;
					end
				}
				if(str == '')
					str = "cant found #{search} in inventory"
				end
				if(i > 30) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				puts message.inspect
				# bot.api.editMessageReplyMarkup(chat_id:message.from.id,message_id:message.message.message_id,reply_markup: {inline_keyboard: []} )
				bot.api.send_message(chat_id: message.from.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when 'MCBC'
				search = 'Mission Critical Business Critical';
				str = ''
				i=0
				inv.rows.each{|row|
					#puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[3].upcase.include?(search.upcase)  
						str += "##{i+1}|#{row[0]}\n"
						i+=1;
					end
				}
				if(str == '')
					str = "cant found #{search} in inventory"
				end
				if(i > 30) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				puts message.inspect
				# bot.api.editMessageReplyMarkup(chat_id:message.from.id,message_id:message.message.message_id,reply_markup: {inline_keyboard: []} )
				# bot.api.send_message(chat_id: message.from.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			end
			###################### msg ##########################
		when Telegram::Bot::Types::Message
			case message.text
			when /^\/flip/
				num = rand(1..100);
				str = '';
				if num%2 ==0
					str = 'Head'
				else
					str = 'Tail'
				end
				bot.api.send_message(chat_id: message.chat.id, text: "om #{message.from.first_name} get #{str}")
			when /^\/hello/
				bot.api.send_message(chat_id: message.chat.id, text: "Hello, om #{message.from.first_name}")
			when /^\/about/
				bot.api.send_message(chat_id: message.chat.id, text: "
				`/hello`
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
				Created on 2 Dec 2019, with RUBY gem\n Last update: 2019-12-06 +7 BETA")
			when /^\/credits/
				bot.api.send_message(chat_id: message.chat.id, text: "patrict bots, on local")	
			when /^\/load/
				inv = spreadsheet.worksheets.first;
				bot.api.send_message(chat_id: message.chat.id, text: "Hi #{message.from.first_name}, New inventory is loaded" )
			when /^\/oradb (.+)/ #show db
				search = $1;
				str = '';
				i=0
				inv.rows.each{|row|
					if row[0].upcase.include?(search.upcase)  
						str += "\n##{i+1})DBNAME: #{row[0]}\nHOSTNAME: #{row[1]}\nIP: #{row[2]}\nCAT: #{row[3]}\nPIC: #{row[4]}\nDB.ver: ORACLE #{row[7]}\nAPP: #{row[8]}\nCREATED: #{row[9]}\n";
						i+=1;
					end
				}
				if str == '' 
					str = "cant found #{search} in inventory"
				end
				if (i > 5) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when /^\/oradblist (.+)/ #show all db onhosts
				search = $1;
				str = '';
				i=0
				inv.rows.each{|row|
					# puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[1].upcase.include?(search.upcase)  
						str += "##{i+1}|#{row[0]}|#{row[3]}|#{row[1]}|#{row[4]}|#{row[8]}\n";
						i+=1;
					end
				}
				if(str == '')
					str = "cant found #{search} in inventory"
				end
				if(i > 30) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when /^\/orahost/ #show all hosts
				hosts=[]
				str="";
				inv.rows.each{|row|
					# puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if !(hosts.include?(row[1]))
						hosts.push(row[1]);
					end
				}
				i=0
				hosts.each{|host|
					str+= "##{i+=1}|#{host}\n ";
				}
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when /^\/oracataaa/
				kb = [
				  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Critical', callback_data: 'BC'),
				  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Mission Critical', callback_data: 'MC'),
				  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Support', callback_data: 'BS'),
				  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Business Important', callback_data: 'BI'),
				  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Mission Critical Business Critical', callback_data: 'MCBC')
				]
				markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb,one_time_keyboard: true)
				bot.api.send_message(chat_id: message.chat.id, text: 'Pick category', reply_markup: markup)
			when /^\/mydb (.+)/
				# puts invm.inspect;
				search = $1;
				str = '';
				i=0
				invm.rows.each{|row|
					if row[0].upcase.include?(search.upcase)  
						str += "\n##{i+1})APP: #{row[0]}\nHOSTNAME: #{row[1]}\nIP: #{row[2]}\nCAT: #{row[3]}\nPIC: #{row[4]}\nDB.ver: #{row[7]}\nNOTE: #{row[9]}\n";
						i+=1;
					end
				}
				if str == '' 
					str = " #{search} tidak ditemukan"
				end
				if (str.size >= 4096 ) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when /^\/mydblist (.+)/ #show all db on hosts
				search = $1;
				str = '';
				i=0
				invm.rows.each{|row|
					# puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[1].upcase.include?(search.upcase)  
						str += "*#{i+1}|#{row[0]}|#{row[7]}*";
						i+=1;
					end
				}
				if(str == '')
					str = " #{search} tidak ditemukan"
				end
				if(str.size >= 4096) 
					str = "query lebih dari  #{i}, input lebih detail"
				end
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{str} ```" );
			when /^\/myhosts/ #show all hosts
				hosts=[]
				str="";
				invm.rows.each{|row|
					# puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if !(hosts.include?(row[1]))
						hosts.push(row[1]);
					end
				}
				i=0
				hosts.each{|host|
					str+= "#{i+=1})#{host}|";
				}
				if(str.size >= 4096 )
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{i} ditemukan ```" );
				else
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: "``` #{str} ```" );
				end;
			when /^\/scanexaimc/
				str="*exaimcpdb-scan*
				10.53.71.166:1521
				10.53.71.165:1521
				10.53.71.167:1521
				vip 
				exaimcpdb1= 10.53.71.163:1521
				exaimcpdb2= 10.53.71.164:1521"
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: str );
			when /^\/scanexabsd/
				str="*exa62bsdpdb-scan*
				10.54.128.133:1521
				10.54.128.135:1521
				10.54.128.134:1521
				vip
				exa62bsdpdb1= 10.54.128.131:1521
				exa62bsdpdb2= 10.54.128.132:1521"
				bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: str );
			end
		end
	end
end
