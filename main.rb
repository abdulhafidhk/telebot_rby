#!/usr/bin/env ruby
require 'telegram/bot'
require 'bundler'
Bundler.require

session 	= GoogleDrive::Session.from_service_account_key("client_secret.json");
spreadsheet = session.spreadsheet_by_title("telebot_ssi_modb");
inv			= spreadsheet.worksheets.first;
token 		= '1063487728:AAE6TEMGGgxntgZr-DDtb5bitvFG1PeAvh4';


Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
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
				bot.api.send_message(chat_id: message.chat.id, text: "Created on 2 Dec 2019, with RUBY gem")
			when /^\/credits/
				bot.api.send_message(chat_id: message.chat.id, text: "patrict bots, on heroku")	
			when /^\/invload/
				inv = spreadsheet.worksheets.first;
				bot.api.send_message(chat_id: message.chat.id, text: "Hi #{message.from.first_name}, New inventory is loaded" )
			when /^\/db (.+)/
				search = $1;
				str = '';
				i=0
				inv.rows.each{|row|
					if row[0].upcase.include?(search.upcase)  
						str += "DBNAME: #{row[0]}\nHOSTNAME: #{row[1]}\nIP: #{row[2]}\nCAT: #{row[3]}\nPIC: #{row[4]}\nDB.ver: ORACLE #{row[7]}\nAPP: #{row[8]}\nCREATED: #{row[9]}\n";
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
			when /^\/host (.+)/
				search = $1;
				str = '';
				i=0
				inv.rows.each{|row|
					# puts "#{row[1]} == #{search.upcase} :#{row[1].include?(search.upcase)}"
					if row[1].upcase.include?(search.upcase)  
						str += "##{i+1} #{row[0]}|#{row[3]}|#{row[1]}|#{row[4]}|#{row[8]}\n";
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
			when /^\/oracleserver/
			
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

