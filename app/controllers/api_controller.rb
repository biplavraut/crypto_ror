class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorized_key, only: %i[ view ]
    before_action :custom_message, only: %i[ view_message ]
    
    def view
        render json: @messages
    end

    def view_message
        key = Lockbox.generate_key
        lockbox = Lockbox.new(key: key, encode: true)
        message = lockbox.encrypt(@message.message)
        render json: lockbox.decrypt(message)
    end

    # POST /api or /api.json
    def create
        @message = Message.new(message_params)
        key = Lockbox.generate_key
        lockbox = Lockbox.new(key: key, encode: true)
        message = lockbox.encrypt(@message.message)
        if @message.save
            render json: message, status: :created
        else
            render json: @message.errors, status: :unprocessable_entity
        end
    end
    
    private
        def authorized_key
            auth_key = 123456
            user_key = params[:key]
            if auth_key == user_key
                @messages = Message.all
            end

        end
        # Use callbacks to share common setup or constraints between actions.
        def set_message
            @message = Message.find(params[:id])
        end

        def custom_message
            @message = Message.where(key: params[:key]).first
        end
        
        # Only allow a list of trusted parameters through.
        def message_params
            params.permit(:name, :email, :phone, :message, :key)
        end
end
