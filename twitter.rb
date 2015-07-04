require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		@client = JumpstartAuth.twitter
	end

	def dm(target, message)
		screen_names = followers_list
		
		if screen_names.include?(target)
			puts "Trying to send #{target} this direct message:"
			puts message
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "You can only send DMs to people who follow you"
		end
	end

	def followers_list
		@client.followers.map { |follower| @client.user(follower).screen_name }
	end

	def spam_my_followers(message)
		followers_list.each do |follower|
			dm(follower, message)
		end
	end

	def tweet(message)
		if message.length <= 140 && message.length > 0
			@client.update(message)
		else
			puts "Please enter message between 1 and 140 characters"
		end
	end

	def everyones_last_tweet
		screen_names = []
		last_tweets = []
		tweet_times = []
		@client.friends.map do |f|
			screen_names << @client.user(f).screen_name
			last_tweets << @client.user(f).status.text
			tweet_times << @client.user(f).status.created_at
		end

		screen_names.sort.each_with_index do |name, idx|
			puts "#{name} said: #{last_tweets[idx]} on #{tweet_times[idx].strftime('%A, %b %d')}\n\n"
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != 'q'
			printf "enter command: "
			input = gets.chomp.split(' ')
			command = input[0]
			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(input[1..-1].join(' '))
			when 'dm' then dm(input[1], input[2..-1].join(' '))
			when 'spam' then spam_my_followers(input[1..-1].join(' '))
			when 'elt' then everyones_last_tweet
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end
end

str = "Wonder whether this works"
blogger = MicroBlogger.new
blogger.run