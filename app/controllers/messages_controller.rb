class MessagesController < ApplicationController
	before_action :set_conversation

  def create
		@message = @conversation.messages.build(message_params)
		@message.role = "user"

		if @message.save
		# generate LLM response
		llm_service = LlmService.new
		conversation_history = @conversation.messages.order(created_at: :asc)

		response_content = llm_service.generate_response(conversation_history)

		# Save assistant's response
		@assistant_message = @conversation.messages.create!(
			content: response_content,
			role: "assistant"
		)

		redirect_to @conversation
		else
			@messages = @conversation.messages.order(created_at: :asc)
			render "conversations/show"
		end
  end

	private

	def set_conversation
		@conversation = Conversation.find(params[:conversation_id])
	end

	def message_params
		params.require(:message).permit(:content)
	end
end
