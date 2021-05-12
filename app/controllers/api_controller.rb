class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authorized_key, only: %i[ view ]
    before_action :custom_message, only: %i[ view_message ]
    
    #view all the data inserted
    def view
        render json: @messages
    end

    # View only message to a key value
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
        # Check if the request is authorized
        def authorized_key
            auth_key = 123456 #static key value
            user_key = params[:key] #user post key value
            if auth_key == user_key
                @messages = Message.all
            else
                render json: @message.errors, status: :unprocessable_entity
            end
        end
        # Use callbacks to share common setup or constraints between actions.
        def custom_message
            @message = Message.where(key: params[:key]).first #check for key value to decrypt message
        end
        
        # Only allow a list of trusted parameters through.
        def message_params
            params.permit(:name, :email, :phone, :message, :key)
        end
end
