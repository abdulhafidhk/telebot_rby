require 'telegram/bot'
require 'bundler'
Bundler.require

session 	= GoogleDrive::Session.from_service_account_key("client_secret.json");
spreadsheet = session.spreadsheet_by_title("telebot_ssi_modb");
inv			= spreadsheet.worksheets.first;
token 		= '1063487728:AAE6TEMGGgxntgZr-DDtb5bitvFG1PeAvh4';


Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
	case message
		when Telegram::Bot::Types::CallbackQuery
			case message.data
				when 'exa62a' 
					bot.api.send_message(chat_id: message.chat.id, text: "SCAN name: exapdb62a-scan")
				when 'exa62b' 
					bot.api.send_message(chat_id: message.from.id, text: "SCAN name: exapdb62b-scan")
				when 'exatbs' 
					bot.api.send_message(chat_id: message.from.id, text: "SCAN name: exapdb62tbsa-scan")
				when 'exabsd' 
					bot.api.send_message(chat_id: message.from.id, text: "SCAN name: exapdb62bsd-scan")
				when 'exaimc' 
					bot.api.send_message(chat_id: message.from.id, text: "SCAN name: exaimcpdb-scan")	
			end
	
		when Telegram::Bot::Types::Message
			case message.text
				when /^\/flip/
					num = rand(1..10);
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
						if row[0].include?(search.upcase)  
							str += "```
							DBNAME\t: #{row[0]}
							HOSTNAME\t: #{row[1]}
							IP\t: #{row[2]}
							CAT\t: #{row[3]}
							PIC\t: #{row[4]}
							DB.ver\t: ORACLE #{row[7]}
							APP\t: #{row[8]}
							CREATED\t: #{row[9]}```
							";
							i+=1
						end
					}
					if str == ''
						str = "cant found #{search} in inventory"
					end
					if(i > 5) 
						str = " query result  more than #{i}, please more specific"
					end
					bot.api.send_message(chat_id: message.chat.id, parse_mode: 'markdown',text: str );
				when /^\/scan/
					kb = [
					  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'exa62a', callback_data: 'exa62a'),
					  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'exa62b', callback_data: 'exa62b'),
					  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'exatbs', callback_data: 'exatbs'),
					  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'exabsd', callback_data: 'exabsd'),
					  Telegram::Bot::Types::InlineKeyboardButton.new(text: 'exaimc', callback_data: 'exaimc')
					]
					markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
					bot.api.send_message(chat_id: message.chat.id, text: 'which one ?', reply_markup: markup)
				end
		end
  end
end
