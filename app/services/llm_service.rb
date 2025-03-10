class LlmService
	def initialize
		@client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
	end

	def generate_response(messages)
		response = @client.chat(
			parameters: {
				model: "gpt-4",
				messages: messages.map { |msg| { role: msg.role, content: msg.content } },
				temperature: 0.7
			}
		)

		response.dig("choices", 0, "message", "content")
	rescue => e
		Rails.logger.error("LLM API Error: #{e.message}")
		"Sorry, I could not generate a reponse at this time."
	end
end
